import { createClient } from "npm:@supabase/supabase-js@2.39.7";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface EstimateSalaryRequest {
  profile_id?: string;
}

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
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

    // 1. Get authenticated user
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

    // 2. Fetch profile with competencies, languages, certifications, and professional area
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

    // 3. Calculation Algorithm (Ajustado al mercado mexicano realista en MXN / mes)
    const level = profileRow.professional_level ?? "Junior";
    const yearsExp = profileRow.years_experience ?? 0;
    const areaName = (profileRow.professional_areas as Record<string, unknown> | null)?.name as string ?? "Tecnología";

    // Rangos salariales base realistas (MXN / mes)
    let baseMin = 14000;
    let baseMax = 22000;

    switch (level) {
      case "Estudiante":
        baseMin = 6000;
        baseMax = 9000;
        break;
      case "Practicante":
        baseMin = 8000;
        baseMax = 12000;
        break;
      case "Junior":
        baseMin = 14000;
        baseMax = 22000;
        break;
      case "Semi Senior":
        baseMin = 22000;
        baseMax = 35000;
        break;
      case "Senior":
        baseMin = 35000;
        baseMax = 55000;
        break;
      case "Especialista":
        baseMin = 48000;
        baseMax = 75000;
        break;
    }

    // Ligero ajuste según área profesional (Tecnología / Ingenierías +5%)
    if (["Tecnología", "Ingenierías"].includes(areaName)) {
      baseMin = Math.round(baseMin * 1.05);
      baseMax = Math.round(baseMax * 1.05);
    }

    const influentialFactors: string[] = [];

    // Factor 1: Años de Experiencia (+2% por año, tope +15%)
    const expBonus = Math.min(yearsExp * 0.02, 0.15);
    if (yearsExp > 0) {
      influentialFactors.push(`${yearsExp} año${yearsExp > 1 ? "s" : ""} de experiencia`);
    }

    // Factor 2: Competencias dominadas (+2% por avanzada, +1% por intermedia, tope +15%)
    let compBonus = 0;
    const userComps = (profileRow.user_competencies as Array<Record<string, unknown>>) || [];
    for (const comp of userComps) {
      const compObj = comp.competencies as Record<string, unknown> | null;
      const name = compObj?.name as string | undefined;
      const compLevel = comp.level as string | undefined;

      if (name) {
        if (compLevel === "Avanzado") {
          compBonus += 0.02;
          influentialFactors.push(`${name} (Avanzado)`);
        } else if (compLevel === "Intermedio") {
          compBonus += 0.01;
          influentialFactors.push(`${name} (Intermedio)`);
        }
      }
    }
    compBonus = Math.min(compBonus, 0.15);

    // Factor 3: Idiomas (Inglés B2 +8%, C1/C2/Nativo +12%)
    let langBonus = 0;
    const userLangs = (profileRow.user_languages as Array<Record<string, unknown>>) || [];
    for (const lang of userLangs) {
      const langObj = lang.languages as Record<string, unknown> | null;
      const levelObj = lang.language_levels as Record<string, unknown> | null;
      const langName = (langObj?.name as string) ?? "";
      const lvlName = (levelObj?.name as string) ?? "";

      if (langName.toLowerCase().includes("ingl") || langName.toLowerCase().includes("engl")) {
        if (["B2"].includes(lvlName)) {
          langBonus += 0.08;
          influentialFactors.push(`Inglés ${lvlName}`);
        } else if (["C1", "C2", "Nativo"].includes(lvlName)) {
          langBonus += 0.12;
          influentialFactors.push(`Inglés ${lvlName}`);
        } else if (["A2", "B1"].includes(lvlName)) {
          langBonus += 0.04;
          influentialFactors.push(`Inglés ${lvlName}`);
        }
      }
    }

    // Factor 4: Certificaciones (+3% por certificación, tope +10%)
    const certs = (profileRow.certifications as Array<Record<string, unknown>>) || [];
    let certBonus = 0;
    for (const cert of certs) {
      certBonus += 0.03;
      if (cert.name) {
        influentialFactors.push(`Certificación: ${cert.name}`);
      }
    }
    certBonus = Math.min(certBonus, 0.10);

    // Multiplicador total topeado a máximo +35% de incremento sobre la base
    const rawMultiplier = 1 + expBonus + compBonus + langBonus + certBonus;
    const finalMultiplier = Math.min(rawMultiplier, 1.35);

    const estimatedMinSalary = Math.round(baseMin * finalMultiplier);
    const estimatedMaxSalary = Math.round(baseMax * finalMultiplier);

    const summary =
      `Estimación salarial aproximada para el área de ${areaName} (Nivel ${level}). ` +
      `Evaluación basada en experiencia (${yearsExp} años), ${userComps.length} competencias ` +
      `y nivel de idioma registrado.`;

    // 4. Guardar estimación en la tabla salary_estimations
    if (profileRow.id && profileRow.professional_area_id) {
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

    // 5. Retornar respuesta estructurada
    return new Response(
      JSON.stringify({
        estimated_min_salary: estimatedMinSalary,
        estimated_max_salary: estimatedMaxSalary,
        currency: "MXN",
        professional_level: level,
        summary: summary,
        influential_factors: influentialFactors,
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
