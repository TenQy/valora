import { createClient } from "npm:@supabase/supabase-js@2.39.7";
import { GoogleGenerativeAI } from "npm:@google/generative-ai";
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

interface GuestProfile {
  level: string;
  years_experience: number;
  area_name: string;
  competencies: Array<{ name: string; level: string }>;
  languages: Array<{ name: string; level: string }>;
  certifications: Array<{ name: string }>;
}

interface EstimateSalaryRequest {
  profile_id?: string;
  guest_profile?: GuestProfile;
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

    let requestBody: EstimateSalaryRequest = {};
    try {
      requestBody = await req.json();
    } catch {
      // Body can be empty
    }

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    // Si no hay usuario y no hay guest_profile, denegar
    if ((userError || !user) && !requestBody.guest_profile) {
      return new Response(
        JSON.stringify({ error: "Unauthorized user session" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    let level = "Junior";
    let yearsExp = 0;
    let areaName = "Tecnología";
    let userComps: Array<any> = [];
    let userLangs: Array<any> = [];
    let certs: Array<any> = [];
    let profileId: string | null = null;
    let profileAreaId: string | null = null;

    if (requestBody.guest_profile) {
      // Usar datos del invitado
      const guest = requestBody.guest_profile;
      level = guest.level || "Junior";
      yearsExp = guest.years_experience || 0;
      areaName = guest.area_name || "Tecnología";

      userComps = (guest.competencies || []).map(c => ({
        level: c.level,
        competencies: { name: c.name }
      }));

      userLangs = (guest.languages || []).map(l => ({
        language_levels: { name: l.level },
        languages: { name: l.name }
      }));

      certs = (guest.certifications || []).map(c => ({
        name: c.name
      }));
    } else if (user) {
      // Usar base de datos
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

      level = profileRow.professional_level ?? "Junior";
      yearsExp = profileRow.years_experience ?? 0;
      areaName = (profileRow.professional_areas as Record<string, unknown> | null)?.name as string ?? "Tecnología";
      userComps = (profileRow.user_competencies as Array<Record<string, unknown>>) || [];
      userLangs = (profileRow.user_languages as Array<Record<string, unknown>>) || [];
      certs = (profileRow.certifications as Array<Record<string, unknown>>) || [];
      profileId = profileRow.id;
      profileAreaId = profileRow.professional_area_id;
    }

    // =========================================================================
    // RANGOS SALARIALES CALIBRADOS AL MERCADO NACIONAL MEXICANO (MXN / mes)
    // =========================================================================

    // 1. Rangos base realistas por nivel
    let baseMin = 13000;
    let baseMax = 20000;
    let maxLevelCap = 25000; // Tope máximo realista para este nivel

    // Mapear los niveles dinámicos a los brackets base de salario
    let mappedLevel = "Junior"; // default fallback
    const lvlLower = level.toLowerCase();
    
    if (["estudiante", "becario", "interno", "dibujante", "pasante"].some(k => lvlLower.includes(k))) {
      mappedLevel = "Estudiante";
    } else if (["practicante", "auxiliar"].some(k => lvlLower.includes(k))) {
      mappedLevel = "Practicante";
    } else if (["junior", "médico general", "abogado junior"].some(k => lvlLower.includes(k))) {
      mappedLevel = "Junior";
    } else if (["semi senior", "analista", "titular", "residente", "proyectista", "proyecto", "asociado"].some(k => lvlLower.includes(k)) && !lvlLower.includes("senior")) {
      mappedLevel = "Semi Senior";
    } else if (["senior", "coordinador"].some(k => lvlLower.includes(k))) {
      mappedLevel = "Senior";
    } else if (["especialista", "gerente", "director", "lead", "staff", "socio", "adscrito", "investigador"].some(k => lvlLower.includes(k))) {
      mappedLevel = "Especialista";
    }

    switch (mappedLevel) {
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

    // 4. Idiomas
    let langBonus = 0;
    let nativosContados = 0;
    for (const lang of userLangs) {
      const langObj = lang.languages as Record<string, unknown> | null;
      const levelObj = lang.language_levels as Record<string, unknown> | null;
      const langName = (langObj?.name as string) ?? "";
      const lvlName = (levelObj?.name as string) ?? "";

      if (lvlName === "Nativo") {
        nativosContados++;
        if (nativosContados === 1) {
          continue; // Ignorar el primer idioma nativo
        }
      }

      const isEnglish = langName.toLowerCase().includes("ingl") || langName.toLowerCase().includes("engl");
      let bonus = 0;

      if (isEnglish) {
        bonus = ["C1", "C2", "Nativo"].includes(lvlName) ? 0.18 : ["B2"].includes(lvlName) ? 0.10 : 0.04;
      } else {
        bonus = ["C1", "C2", "Nativo"].includes(lvlName) ? 0.10 : ["B2"].includes(lvlName) ? 0.05 : 0.02;
      }

      langBonus += bonus;
      const label = `${langName} ${lvlName}`;
      influentialFactors.push(label);
      highlightCandidates.push({ label, rawBonus: bonus });
    }

    // 5. Certificaciones (+3% cada una, tope +8%)
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

    let summary = "";
    if (requestBody.guest_profile) {
      if (userComps.length > 0) {
        summary = `¡Excelente inicio! Según el área de ${areaName} y las habilidades que agregaste, estimamos que este es el valor promedio actual en el mercado para un perfil ${level}. Regístrate para afinar este resultado añadiendo tu experiencia real, idiomas y certificaciones.`;
      } else {
        summary = `¡Excelente inicio! Según el área de ${areaName}, este es el valor base estimado en el mercado para un ${level}. Regístrate para agregar tus habilidades, experiencia e idiomas, y obtener un cálculo personalizado.`;
      }
    } else {
      const expText = yearsExp > 0 ? `experiencia de ${yearsExp} años` : `trayectoria inicial`;
      const compText = userComps.length > 0 ? ` y tus ${userComps.length} habilidades registradas` : ``;
      summary = `Basado en tu ${expText}${compText}, tienes un perfil con potencial de nivel ${level} en el área de ${areaName}. Este rango refleja el valor actual que las empresas están dispuestas a pagar por tu perfil en el mercado.`;
    }

    // =========================================================================
    // REFINAMIENTO CON IA (GEMINI)
    // =========================================================================
    let finalMin = estimatedMinSalary;
    let finalMax = estimatedMaxSalary;
    let finalSummary = summary;

    try {
      const apiKey = Deno.env.get("GEMINI_API_KEY");
      if (apiKey) {
        const genAI = new GoogleGenerativeAI(apiKey);
        const modelsToTry = [
          "gemini-3.5-flash-lite",
          "gemini-3.1-flash",
          "gemini-3.1-flash-lite",
          "gemini-2.5-flash",
          "gemini-2.5-flash-lite",
        ];

        const profileJson = JSON.stringify({
          level, yearsExp, areaName, userComps, userLangs, certs
        }, null, 2);

        const prompt = `
Eres un experto reclutador y analista de salarios en el sector profesional.
Tu objetivo es analizar un perfil profesional y refinar su rango salarial matemáticamente calculado para hacerlo más preciso, detectando posibles anomalías de coherencia.

Perfil del Usuario:
${profileJson}

Rango Salarial Base Calculado Matemáticamente:
Mínimo: $${estimatedMinSalary} MXN
Máximo: $${estimatedMaxSalary} MXN

Instrucciones:
1. Analiza el perfil buscando anomalías (por ejemplo, un Junior con 15 años de experiencia, o un "Desarrollador de Software" con la competencia "Cirugía Médica").
2. Si detectas anomalías de coherencia, penaliza ligeramente el rango salarial (reduciendo un poco el máximo) porque indica que el perfil no está enfocado o los datos son inconsistentes. Si el perfil es altamente coherente y especializado, puedes acotar (volver más preciso) el rango salarial (ej. subir un poco el mínimo y bajar un poco el máximo para dar un rango de mayor confianza).
3. NUNCA inventes rangos muy por fuera del rango base calculado. Usa el rango base como tu ancla estricta, solo refínalo (acótalo) para mayor precisión.
4. Genera un 'summary' (resumen) redactado directamente para el usuario de unas 2 a 3 oraciones (en segunda persona). Explícale de forma profesional por qué tiene ese valor salarial, mencionando sus habilidades clave o años de experiencia. Si detectaste anomalías, menciónalas de forma constructiva (ej. "Notamos habilidades fuera de tu área que no añaden valor directo a tu rol principal..."). NUNCA uses markdown en el summary.
5. Retorna ÚNICAMENTE un JSON válido con este formato exacto:
{
  "estimated_min_salary": 26000,
  "estimated_max_salary": 32000,
  "summary": "Texto del resumen personalizado..."
}
`;
        let responseText = "";
        for (const modelName of modelsToTry) {
          try {
            const model = genAI.getGenerativeModel({ model: modelName });
            const result = await model.generateContent({
              contents: [{ role: "user", parts: [{ text: prompt }] }],
              generationConfig: { temperature: 0.2 }
            });
            responseText = result.response.text();
            break;
          } catch (e) {
            console.warn(`Gemini model ${modelName} failed:`, e);
          }
        }

        if (responseText) {
          let cleanedJson = responseText.trim();
          if (cleanedJson.startsWith("```json")) {
            cleanedJson = cleanedJson.replace(/^```json/, "").replace(/```$/, "").trim();
          } else if (cleanedJson.startsWith("```")) {
            cleanedJson = cleanedJson.replace(/^```/, "").replace(/```$/, "").trim();
          }
          const parsed = JSON.parse(cleanedJson);
          if (parsed.estimated_min_salary && parsed.estimated_max_salary && parsed.summary) {
            finalMin = parsed.estimated_min_salary;
            finalMax = parsed.estimated_max_salary;
            finalSummary = parsed.summary;
          }
        }
      }
    } catch (e) {
      console.error("Gemini Salary Refinement Error:", e);
      // Fallback silencioso a los valores matemáticos
    }

    if (profileId && profileAreaId) {
      // Evitar guardar historial si el valor es exactamente el mismo que el anterior
      const { data: lastEst } = await supabase
        .from("salary_estimations")
        .select("estimated_min_salary, estimated_max_salary, summary")
        .eq("profile_id", profileId)
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle();

      const isDuplicate = lastEst &&
        lastEst.estimated_min_salary === finalMin &&
        lastEst.estimated_max_salary === finalMax &&
        lastEst.summary === finalSummary;

      if (!isDuplicate) {
        await supabase.from("salary_estimations").insert({
          profile_id: profileId,
          professional_area_id: profileAreaId,
          estimated_min_salary: finalMin,
          estimated_max_salary: finalMax,
          currency: "MXN",
          professional_level: level,
          summary: finalSummary,
        });
      }
    }

    return new Response(
      JSON.stringify({
        estimated_min_salary: finalMin,
        estimated_max_salary: finalMax,
        currency: "MXN",
        professional_level: level,
        summary: finalSummary,
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
