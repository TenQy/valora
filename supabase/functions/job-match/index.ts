import { createClient } from "npm:@supabase/supabase-js@2.39.7";
import { GoogleGenerativeAI } from "npm:@google/generative-ai";
import { GEMINI_MODELS_FALLBACK } from "../_shared/ai_config.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface JobMatchRequest {
  profile_id?: string;
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

    let requestBody: JobMatchRequest = {};
    try {
      requestBody = await req.json();
    } catch {
      // Body can be empty
    }

    // 1. Fetch Profile
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
        JSON.stringify({ error: "No se encontró un perfil profesional." }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (!profileRow.professional_area_id) {
      return new Response(
        JSON.stringify({ error: "El perfil no tiene un área profesional asignada." }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 1.5 Fetch latest salary estimation to anchor the job match
    const { data: lastEstimation } = await supabase
      .from("salary_estimations")
      .select("estimated_min_salary, estimated_max_salary")
      .eq("profile_id", profileRow.id)
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    const currentValuationText = lastEstimation
      ? `$${lastEstimation.estimated_min_salary} - $${lastEstimation.estimated_max_salary} MXN`
      : 'Desconocido';

    // 2. Fetch Job Roles for the area (Optimizado sin description para ahorrar tokens)
    const { data: jobRoles, error: rolesError } = await supabase
      .from("job_roles")
      .select("id, name, min_salary, max_salary")
      .eq("professional_area_id", profileRow.professional_area_id)
      .eq("is_active", true);

    if (rolesError || !jobRoles || jobRoles.length === 0) {
      return new Response(
        JSON.stringify({ error: "No hay roles laborales configurados para esta área." }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // 3. Prepare AI Prompt
    const apiKey = Deno.env.get("GEMINI_API_KEY");
    if (!apiKey) {
      throw new Error("GEMINI_API_KEY is not set");
    }

    const genAI = new GoogleGenerativeAI(apiKey);
    const modelsToTry = GEMINI_MODELS_FALLBACK;

    const profileJson = JSON.stringify(profileRow, null, 2);
    const rolesJson = JSON.stringify(jobRoles, null, 2);

    const prompt = `
Eres un experto reclutador tecnológico (Technical Recruiter).
Tu objetivo es analizar un perfil profesional y encontrar los 3 mejores roles laborales de nuestro catálogo que encajen con las habilidades del usuario.

Perfil del usuario:
${profileJson}

Catálogo de Roles Disponibles:
${rolesJson}

Valoración Monetaria Actual del Usuario (Su Valor en el Mercado):
${currentValuationText}

Instrucciones:
1. Analiza el nivel, carrera, años de experiencia, lenguajes, certificaciones y competencias del usuario.
   - REGLA CRÍTICA: Si el usuario NO tiene competencias ni bio, NO inventes habilidades. Devuelve un arreglo vacío [] en "matched_competencies". Todas las habilidades requeridas por el rol deben ir en "missing_competencies".
2. Compara esto con el nombre de cada rol en el catálogo y utiliza tu conocimiento experto para inferir qué exige cada rol.
3. Selecciona los 3 roles con mayor compatibilidad.
4. Ajusta el salario estimado (min/max) dentro del rango del rol, pero ANCLADO estrechamente al mercado real en México y a su "Valoración Monetaria Actual". 
   - REGLA ESTRICTA: Un "Practicante", "Estudiante" o "Junior" rara vez supera los 15,000 a 25,000 MXN en México. Sé realista.
5. Genera una cadena de búsqueda (search_query) altamente optimizada para Google Jobs:
   - Usa el nombre puro del rol (ej. "Desarrollador Frontend") sin añadir niveles confusos (ni "mid level", ni "especialista", etc).
   - EXCEPCIÓN 1: Si el nivel es "Practicante" o "Pasante", busca "Practicante de [Rol]".
   - EXCEPCIÓN 2: Si el nivel es "Junior", busca "[Rol] junior".
6. Retorna ÚNICAMENTE un arreglo JSON con el siguiente formato exacto y sin markdown extra:
[
  {
    "job_role_id": "UUID del rol seleccionado",
    "job_role_name": "Nombre del rol seleccionado",
    "search_query": "Cadena de búsqueda para Google Jobs",
    "match_percentage": 85, // Número del 0 al 100
    "estimated_min_salary": 25000, // Número
    "estimated_max_salary": 35000, // Número
    "currency": "MXN",
    "matched_competencies": ["Competencia 1", "Competencia 2"],
    "missing_competencies": ["Competencia faltante 1"],
    "summary": "Breve justificación de 1 oración sobre por qué encaja este rol."
  }
]
`;

    let responseText = "";
    let lastError = null;

    for (const modelName of modelsToTry) {
      try {
        const model = genAI.getGenerativeModel({ model: modelName });
        const result = await model.generateContent({
          contents: [{ role: "user", parts: [{ text: prompt }] }],
          generationConfig: {
            temperature: 0.2,
          }
        });
        responseText = result.response.text();
        break;
      } catch (e) {
        lastError = e;
        console.warn(`Model ${modelName} failed:`, e);
      }
    }

    if (!responseText) {
      throw lastError || new Error("All Gemini models failed");
    }

    // Clean JSON (remove ```json block if present)
    let cleanedJson = responseText.trim();
    if (cleanedJson.startsWith("```json")) {
      cleanedJson = cleanedJson.replace(/^```json/, "").replace(/```$/, "").trim();
    } else if (cleanedJson.startsWith("```")) {
      cleanedJson = cleanedJson.replace(/^```/, "").replace(/```$/, "").trim();
    }

    let parsedResult;
    try {
      parsedResult = JSON.parse(cleanedJson);
    } catch (parseError) {
      console.error("Error parsing Gemini JSON:", responseText);
      return new Response(
        JSON.stringify({ error: "El motor de IA retornó un formato inválido." }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (!Array.isArray(parsedResult)) {
      parsedResult = [parsedResult];
    }

    // 4. Save to Database
    const recordsToInsert = parsedResult.map((match: any) => {
      const roleDef = jobRoles?.find((r) => r.id === match.job_role_id);
      const baseName = roleDef?.name || match.job_role_name || "Rol Profesional";
      const customTitle = profileRow.professional_level
        ? `${baseName} (${profileRow.professional_level})`
        : baseName;

      return {
        profile_id: profileRow.id,
        job_role_id: match.job_role_id,
        match_percentage: match.match_percentage,
        estimated_min_salary: match.estimated_min_salary,
        estimated_max_salary: match.estimated_max_salary,
        currency: match.currency || "MXN",
        matched_competencies: match.matched_competencies || [],
        missing_competencies: match.missing_competencies || [],
        summary: match.summary || "",
        search_query: match.search_query || baseName,
        job_role_title: customTitle,
      };
    });

    const recordsToReturn = recordsToInsert.map((match: any) => ({
      ...match,
      job_role_name: match.job_role_title,
    }));

    const { error: insertError } = await supabase
      .from("job_matches")
      .insert(recordsToInsert);

    if (insertError) {
      console.error("Error saving job matches:", insertError);
    }

    return new Response(
      JSON.stringify(recordsToReturn),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error: any) {
    console.error("Job Match Error:", error.message);
    return new Response(
      JSON.stringify({ error: "Ocurrió un error procesando la compatibilidad laboral." }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
