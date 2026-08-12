import { createClient } from "npm:@supabase/supabase-js@2.39.7";
import { GoogleGenerativeAI } from "npm:@google/generative-ai";
import { GEMINI_MODELS_FALLBACK } from "../_shared/ai_config.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface GrowthPathRequest {
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

    let requestBody: GrowthPathRequest = {};
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

    // 2. Prepare AI Prompt
    const apiKey = Deno.env.get("GEMINI_API_KEY");
    if (!apiKey) {
      throw new Error("GEMINI_API_KEY is not set");
    }

    const genAI = new GoogleGenerativeAI(apiKey);
    const modelsToTry = GEMINI_MODELS_FALLBACK;

    const profileJson = JSON.stringify(profileRow, null, 2);

    const prompt = `
Eres un experto coach de carrera y mentor profesional.
Tu objetivo es analizar un perfil profesional y generar una "Ruta de Crecimiento" (Growth Path) realista y estructurada para ayudar al usuario a subir al siguiente nivel profesional y mejorar sus ingresos.

Perfil del usuario:
${profileJson}

Instrucciones:
1. Analiza el nivel, carrera, años de experiencia, lenguajes, certificaciones y competencias actuales del usuario.
2. Determina cuál es el "Siguiente Nivel" lógico en su carrera (por ejemplo, si es Junior, el siguiente es "Mid-Level" o "Semi Senior"; si es Senior, el siguiente puede ser "Lead" o "Manager").
3. Diseña de 3 a 5 "milestones" (hitos o pasos) altamente precisos que debe cumplir para alcanzar ese nivel. 
IMPORTANTE: Debes ser extremadamente específico. No uses frases genéricas como "Aprender nuevas tecnologías". Menciona los nombres exactos de los lenguajes, frameworks, herramientas, metodologías o certificaciones de mercado (ej. "Aprender Docker y Kubernetes", "Certificación AWS Solutions Architect", "Dominar estado global con Riverpod").
4. Estima el tiempo realista que tomaría completar esta ruta de crecimiento (ej. "6 a 12 meses", "1 a 2 años").
5. Escribe un breve resumen motivador en segunda persona.
6. Retorna ÚNICAMENTE un objeto JSON válido con el siguiente formato exacto y sin markdown extra:
{
  "current_level": "Nivel actual (ej. Junior Developer)",
  "next_level": "Siguiente nivel (ej. Semi Senior Developer)",
  "estimated_time": "Tiempo estimado (ej. 6 - 12 meses)",
  "summary": "Resumen motivador de 1 o 2 oraciones.",
  "milestones": [
    {
      "title": "Aprender React y Manejo de Estado",
      "description": "Domina herramientas modernas como Redux o Riverpod para aplicaciones escalables.",
      "type": "skill" // Puede ser "skill", "certification", "experience", "language" o "soft_skill"
    }
  ]
}
`;

    let responseText = "";
    let lastError = null;

    for (const modelName of modelsToTry) {
      try {
        const model = genAI.getGenerativeModel({ model: modelName });
        const result = await model.generateContent({
          contents: [{ role: "user", parts: [{ text: prompt }] }],
          generationConfig: {
            temperature: 0.3,
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
    if (cleanedJson.startsWith("\`\`\`json")) {
      cleanedJson = cleanedJson.replace(/^\`\`\`json/, "").replace(/\`\`\`$/, "").trim();
    } else if (cleanedJson.startsWith("\`\`\`")) {
      cleanedJson = cleanedJson.replace(/^\`\`\`/, "").replace(/\`\`\`$/, "").trim();
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

    // 4. Save to Database
    const { error: insertError } = await supabase
      .from("growth_paths")
      .insert({
        profile_id: profileRow.id,
        current_level: parsedResult.current_level || "",
        next_level: parsedResult.next_level || "",
        estimated_time: parsedResult.estimated_time || "",
        summary: parsedResult.summary || "",
        milestones: parsedResult.milestones || []
      });

    if (insertError) {
      console.error("Error saving growth path:", insertError);
    }

    return new Response(
      JSON.stringify(parsedResult),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error: any) {
    console.error("Growth Path Error:", error.message);
    return new Response(
      JSON.stringify({ error: "Ocurrió un error generando la ruta de crecimiento." }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
