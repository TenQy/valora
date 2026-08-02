import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "npm:@supabase/supabase-js@2.39.7";
import { GEMINI_MODELS_FALLBACK } from "../_shared/ai_config.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { project_id } = await req.json();

    if (!project_id) {
      return new Response(JSON.stringify({ error: "Falta project_id" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey);

    // 1. Obtener Proyecto y Competencias
    const { data: projectData, error: projectError } = await supabase
      .from("projects")
      .select(`
        *,
        project_competencies (
          competencies ( name )
        ),
        profiles (
          id,
          professional_level,
          years_experience,
          professional_areas ( name )
        )
      `)
      .eq("id", project_id)
      .single();

    if (projectError || !projectData) {
      return new Response(JSON.stringify({ error: "Proyecto no encontrado" }), {
        status: 404,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const comps = projectData.project_competencies
      .map((pc: any) => pc.competencies?.name)
      .filter(Boolean)
      .join(", ");

    const profileData = projectData.profiles;
    const areaName = profileData.professional_areas?.name || "Tecnología";

    // 2. Prompt para Gemini
    const systemPrompt = `
Eres un experto estimador de proyectos freelance y corporativos en el área de ${areaName}.
Analiza el siguiente proyecto y estima su valor económico aproximado estrictamente en Pesos Mexicanos (MXN), basándote en la complejidad técnica, tiempo de desarrollo y tecnologías.
Debes ser extremadamente preciso. El rango entre el valor mínimo y máximo NO debe superar el 20% de diferencia para dar una cifra más certera.
Regresa la respuesta ÚNICAMENTE en JSON válido con el siguiente formato:
{
  "estimated_min_value": 15000,
  "estimated_max_value": 30000,
  "currency": "MXN",
  "complexity_result": "Nivel alto",
  "summary": "Breve explicación de por qué vale esto..."
}`;

    const userPrompt = `
Proyecto: ${projectData.name}
Descripción: ${projectData.description}
Tipo: ${projectData.project_type}
Complejidad: ${projectData.complexity}
Tiempo Estimado: ${projectData.estimated_time}
Plataformas: ${projectData.platforms}
Tecnologías usadas: ${comps || "No especificadas"}
Nivel del desarrollador: ${profileData.professional_level} con ${profileData.years_experience} años de exp.
`;

    const apiKey = Deno.env.get("GEMINI_API_KEY");
    if (!apiKey) throw new Error("API Key de Gemini no configurada");

    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODELS_FALLBACK[0]}:generateContent?key=${apiKey}`;

    const response = await fetch(geminiUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [
          { role: "user", parts: [{ text: systemPrompt + "\n" + userPrompt }] },
        ],
        generationConfig: {
          temperature: 0.2,
          responseMimeType: "application/json",
        },
      }),
    });

    const aiData = await response.json();
    if (!aiData.candidates || aiData.candidates.length === 0) {
      throw new Error(`Gemini API Error: ${JSON.stringify(aiData)}`);
    }

    let responseText = aiData.candidates[0].content.parts[0].text;
    // Remove markdown code block if present
    responseText = responseText.replace(/```json/g, "").replace(/```/g, "").trim();
    const parsedResult = JSON.parse(responseText);

    // 3. Guardar en Base de Datos
    const estimationRecord = {
      project_id: project_id,
      profile_id: profileData.id,
      estimated_min_value: parsedResult.estimated_min_value,
      estimated_max_value: parsedResult.estimated_max_value,
      currency: parsedResult.currency || "MXN",
      complexity_result: parsedResult.complexity_result,
      summary: parsedResult.summary,
    };

    const { error: insertError } = await supabase
      .from("project_estimations")
      .insert(estimationRecord);

    if (insertError) {
      throw insertError;
    }

    return new Response(JSON.stringify(estimationRecord), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error: any) {
    console.error("Error Edge Function:", error);
    return new Response(JSON.stringify({ error: error.message || String(error), stack: error.stack }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
