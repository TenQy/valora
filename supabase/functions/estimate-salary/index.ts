import { createClient } from "npm:@supabase/supabase-js@2.39.7";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface EstimateSalaryRequest {
  profile_id?: string;
}

interface HighlightItem {
  label: string;
  boost: string;
}

interface BreakdownItem {
  category: string;
  percentage: number;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing Authorization header" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: "Unauthorized user session" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    let requestBody: EstimateSalaryRequest = {};
    try {
      requestBody = await req.json();
    } catch {
      // Body can be empty
    }

    let query = supabase
      .from("profiles")
      .select(`
        id,
        user_id,
        full_name,
        career,
        professional_level,
        years_experience,
        bio,
        professional_area_id,
        professional_areas ( name ),
        user_competencies ( level, competencies ( name, category ) ),
        user_languages ( languages ( name ), language_levels ( name ) ),
        certifications ( name, issuer )
      `);

    if (requestBody.profile_id) {
      query = query.eq("id", requestBody.profile_id);
    } else {
      query = query.eq("user_id", user.id);
    }

    const { data: profileRow, error: profileError } = await query.single();

    if (profileError || !profileRow) {
      return new Response(
        JSON.stringify({
          error: "No se encontró un perfil profesional para calcular el salario.",
        }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // =========================================================================
    // RANGOS SALARIALES CALIBRADOS AL MERCADO NACIONAL MEXICANO (MXN / mes)
    // =========================================================================
    const level = profileRow.professional_level ?? "Junior";
    const yearsExp = profileRow.years_experience ?? 0;
    const areaName = (profileRow.professional_areas as Record<string, unknown> | null)?.name as string ?? "Tecnología";

    // 1. Rangos base realistas por nivel
    let baseMin = 13000;
    let baseMax = 20000;
    let maxLevelCap = 25000; // Tope máximo realista para este nivel

    switch (level) {
      case "Estudiante":
        baseMin = 6000;
        baseMax = 9000;
        maxLevelCap = 11000;
        break;
      case "Practicante":
        baseMin = 8000;
        baseMax = 12000;
        maxLevelCap = 14000;
        break;
      case "Junior":
        baseMin = 13000;
        baseMax = 19000;
        maxLevelCap = 24000;
        break;
      case "Semi Senior":
        baseMin = 22000;
        baseMax = 32000;
        maxLevelCap = 40000;
        break;
      case "Senior":
        baseMin = 35000;
        baseMax = 52000;
        maxLevelCap = 65000;
        break;
      case "Especialista":
        baseMin = 48000;
        baseMax = 72000;
        maxLevelCap = 88000;
        break;
    }

    if (["Tecnología", "Ingenierías"].includes(areaName)) {
      baseMin = Math.round(baseMin * 1.04);
      baseMax = Math.round(baseMax * 1.04);
      maxLevelCap = Math.round(maxLevelCap * 1.04);
    }

    const influentialFactors: string[] = [];
    const highlightCandidates: { label: string; rawBonus: number }[] = [];

    // 2. Experiencia (+3.5% por año, tope +18%)
    const expBonus = Math.min(yearsExp * 0.035, 0.18);
    if (yearsExp > 0) {
      const label = `${yearsExp} año${yearsExp > 1 ? "s" : ""} de experiencia laboral`;
      influentialFactors.push(label);
      highlightCandidates.push({ label, rawBonus: expBonus });
    }

    // 3. Competencias (+2% avanzada, +1% intermedia, tope +12%)
    let compBonus = 0;
    const userComps = (profileRow.user_competencies as Array<Record<string, unknown>>) || [];
    for (const comp of userComps) {
      const compObj = comp.competencies as Record<string, unknown> | null;
      const name = compObj?.name as string | undefined;
      const compLevel = comp.level as string | undefined;

      if (name) {
        const bonus = compLevel === "Avanzado" ? 0.02 : compLevel === "Intermedio" ? 0.01 : 0.005;
        compBonus += bonus;
        const label = `${name} (${compLevel ?? "Básico"})`;
        influentialFactors.push(label);
        highlightCandidates.push({ label, rawBonus: bonus });
      }
    }
    compBonus = Math.min(compBonus, 0.12);

    // 4. Idiomas (Inglés B2 +10%, C1/C2 +18%)
    let langBonus = 0;
    const userLangs = (profileRow.user_languages as Array<Record<string, unknown>>) || [];
    for (const lang of userLangs) {
      const langObj = lang.languages as Record<string, unknown> | null;
      const levelObj = lang.language_levels as Record<string, unknown> | null;
      const langName = (langObj?.name as string) ?? "";
      const lvlName = (levelObj?.name as string) ?? "";

      if (langName.toLowerCase().includes("ingl") || langName.toLowerCase().includes("engl")) {
        const bonus = ["C1", "C2", "Nativo"].includes(lvlName) ? 0.18 : ["B2"].includes(lvlName) ? 0.10 : 0.04;
        langBonus += bonus;
        const label = `Inglés ${lvlName}`;
        influentialFactors.push(label);
        highlightCandidates.push({ label, rawBonus: bonus });
      }
    }

    // 5. Certificaciones (+3% cada una, tope +8%)
    const certs = (profileRow.certifications as Array<Record<string, unknown>>) || [];
    let certBonus = 0;
    for (const cert of certs) {
      certBonus += 0.03;
      if (cert.name) {
        const label = `Certificación: ${cert.name}`;
        influentialFactors.push(label);
        highlightCandidates.push({ label, rawBonus: 0.03 });
      }
    }
    certBonus = Math.min(certBonus, 0.08);

    const rawMultiplier = 1 + expBonus + compBonus + langBonus + certBonus;
    const finalMultiplier = Math.min(rawMultiplier, 1.25); // Máximo 25% de incremento total sobre la base

    let estimatedMinSalary = Math.round(baseMin * finalMultiplier);
    let estimatedMaxSalary = Math.round(baseMax * finalMultiplier);

    // Aplicar tope máximo del nivel para no inflar salarios en perfiles Junior
    if (estimatedMaxSalary > maxLevelCap) {
      estimatedMaxSalary = maxLevelCap;
    }
    if (estimatedMinSalary >= estimatedMaxSalary) {
      estimatedMinSalary = Math.round(estimatedMaxSalary * 0.75);
    }

    // 6. Factores Destacados con incremento exacto en MXN
    highlightCandidates.sort((a, b) => b.rawBonus - a.rawBonus);
    const topHighlights: HighlightItem[] = highlightCandidates.slice(0, 4).map((c) => {
      const mxnBoost = Math.round(baseMin * c.rawBonus);
      return {
        label: c.label,
        boost: `+ \$${mxnBoost.toLocaleString("en-US")} MXN`,
      };
    });

    // 7. Desglose de Impacto Ponderado
    const expWeight = 0.52 + expBonus;
    const compWeight = userComps.length > 0 ? 0.24 + compBonus : 0;
    const langWeight = userLangs.length > 0 ? 0.16 + langBonus : 0;
    const certWeight = certs.length > 0 ? 0.08 + certBonus : 0;

    const grandTotalWeight = expWeight + compWeight + langWeight + certWeight;

    const expPct = Math.round((expWeight / grandTotalWeight) * 100);
    const compPct = compWeight > 0 ? Math.round((compWeight / grandTotalWeight) * 100) : 0;
    const langPct = langWeight > 0 ? Math.round((langWeight / grandTotalWeight) * 100) : 0;
    const certPct = certWeight > 0 ? Math.round((certWeight / grandTotalWeight) * 100) : 0;

    const factorBreakdown: BreakdownItem[] = [
      { category: "Experiencia y Trayectoria", percentage: expPct },
    ];
    
    if (compPct > 0) {
      factorBreakdown.push({ category: "Competencias Técnicas", percentage: compPct });
    }
    if (langPct > 0) {
      factorBreakdown.push({ category: "Dominio de Idiomas", percentage: langPct });
    }
    if (certPct > 0) {
      factorBreakdown.push({ category: "Certificaciones Oficiales", percentage: certPct });
    }

    factorBreakdown.sort((a, b) => b.percentage - a.percentage);

    const summary = `Basado en tu experiencia de ${yearsExp} años y tus ${userComps.length} habilidades principales, tienes un perfil sólido de nivel ${level} en el área de ${areaName}. Este rango refleja el valor actual que las empresas están dispuestas a pagar por tu combinación de conocimientos e idiomas en el mercado.`;

    if (profileRow.id && profileRow.professional_area_id) {
      // Evitar guardar historial si el valor es exactamente el mismo que el anterior
      const { data: lastEst } = await supabase
        .from("salary_estimations")
        .select("estimated_min_salary, estimated_max_salary, summary")
        .eq("profile_id", profileRow.id)
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle();

      const isDuplicate = lastEst &&
        lastEst.estimated_min_salary === estimatedMinSalary &&
        lastEst.estimated_max_salary === estimatedMaxSalary &&
        lastEst.summary === summary;

      if (!isDuplicate) {
        await supabase.from("salary_estimations").insert({
          profile_id: profileRow.id,
          professional_area_id: profileRow.professional_area_id,
          estimated_min_salary: estimatedMinSalary,
          estimated_max_salary: estimatedMaxSalary,
          currency: "MXN",
          professional_level: level,
          summary: summary,
        });
      }
    }

    return new Response(
      JSON.stringify({
        estimated_min_salary: estimatedMinSalary,
        estimated_max_salary: estimatedMaxSalary,
        currency: "MXN",
        professional_level: level,
        summary: summary,
        influential_factors: influentialFactors,
        top_highlights: topHighlights,
        factor_breakdown: factorBreakdown,
      }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  } catch (err: unknown) {
    const errorMsg = err instanceof Error ? err.message : "Internal server error";
    return new Response(
      JSON.stringify({ error: errorMsg }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
