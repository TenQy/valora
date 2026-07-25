import { createClient } from "npm:@supabase/supabase-js@2.39.7";
import { GoogleGenerativeAI } from "npm:@google/generative-ai";

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

    // 2. Fetch Job Roles for the area
    const { data: jobRoles, error: rolesError } = await supabase
      .from("job_roles")
      .select("id, name, description, min_salary, max_salary")
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
    const modelsToTry = [
      "gemini-3.5-flash-lite",
      "gemini-3.1-flash",
      "gemini-3.1-flash-lite",
      "gemini-2.5-flash",
      "gemini-2.5-flash-lite",
      "gemini-1.5-flash",
    ];

    const profileJson = JSON.stringify(profileRow, null, 2);
    const rolesJson = JSON.stringify(jobRoles, null, 2);

    const prompt = `
Eres un experto reclutador tecnológico (Technical Recruiter).
Tu objetivo es analizar un perfil profesional y encontrar los 3 mejores roles laborales de nuestro catálogo que encajen con las habilidades del usuario.

Perfil del usuario:
${profileJson}

Catálogo de Roles Disponibles:
${rolesJson}

Instrucciones:
1. Analiza el nivel, carrera, años de experiencia, lenguajes, certificaciones y competencias del usuario.
2. Compara esto con la descripción de cada rol en el catálogo.
3. Selecciona los 3 roles con mayor compatibilidad.
4. Ajusta el salario estimado dentro del rango del rol basándote en la experiencia del usuario (Junior vs Senior).
5. Genera una cadena de búsqueda (search_query) altamente optimizada para Google Jobs, siguiendo estas reglas estrictas:
   - NO incluyas palabras como "trabajo de" o "empleo de", busca el rol directo.
   - NO incluyas habilidades técnicas en la cadena.
   - Si el nivel es "Estudiante", omite el nivel (ej. "Desarrollador Frontend").
   - Si el nivel es "Practicante", ponlo antes (ej. "practicante de Desarrollador Frontend").
   - Si el nivel es "Junior", ponlo después (ej. "Desarrollador Frontend junior").
   - Si el nivel es "Semi Senior", usa el término "mid level" al final (ej. "Desarrollador Frontend mid level").
   - Si el nivel es "Senior", ponlo después (ej. "Desarrollador Frontend senior").
   - Si el nivel es "Especialista", ponlo después (ej. "Desarrollador Frontend especialista").
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
    const recordsToInsert = parsedResult.map((match: any) => ({
      profile_id: profileRow.id,
      job_role_id: match.job_role_id,
      match_percentage: match.match_percentage,
      estimated_min_salary: match.estimated_min_salary,
      estimated_max_salary: match.estimated_max_salary,
      currency: match.currency || "MXN",
      matched_competencies: match.matched_competencies || [],
      missing_competencies: match.missing_competencies || [],
      summary: match.summary || "",
      search_query: match.search_query || match.job_role_name,
    }));

    const recordsToReturn = parsedResult.map((match: any) => ({
      ...match,
      search_query: match.search_query || match.job_role_name,
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
