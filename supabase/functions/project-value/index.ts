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
          bio,
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
    
    const bioRaw = profileData.bio || "";
    const bio = bioRaw.length > 800 ? bioRaw.substring(0, 800) + "..." : bioRaw;

    // 2. Prompt para Gemini
    const systemPrompt = `
Eres un experto estimador de proyectos freelance y corporativos en el área de ${areaName}.
Estás evaluando directamente a la persona que realizó este proyecto. Háblale de "tú" de forma profesional y directa (ej. "Tu proyecto demuestra...", "Has utilizado...").
Analiza detalladamente el proyecto proporcionado y estima su valor económico aproximado estrictamente en Pesos Mexicanos (MXN).

REGLAS CRÍTICAS DE EVALUACIÓN:
1. COHERENCIA: Analiza la relación entre el Nombre/Título, la Descripción y las Tecnologías/Competencias.
2. PENALIZACIÓN: Si las tecnologías o competencias parecen agregadas al azar y no concuerdan con la descripción, o si la descripción es demasiado vaga (ej. "hice una app"), debes disminuir drásticamente la complejidad y el valor estimado. El valor real depende de cómo se justifica el trabajo en la descripción.
3. CONTEXTO DEL AUTOR: Ajusta el valor y las expectativas basándote en su nivel profesional y sus años de experiencia.
4. PRECISIÓN: El rango entre el valor mínimo y máximo NO debe superar el 20% de diferencia.
5. PERSONALIZACIÓN: El "summary" y el "complexity_result" deben estar redactados en segunda persona (dirigiéndote al usuario).

Regresa la respuesta ÚNICAMENTE en JSON válido con el siguiente formato:
{
  "estimated_min_value": 15000,
  "estimated_max_value": 18000,
  "currency": "MXN",
  "complexity_result": "Una sola frase muy corta y directa indicando la complejidad final (Ej. 'Complejidad Alta: Arquitectura robusta' o 'Complejidad Baja: Poca coherencia').",
  "summary": "Breve explicación dirigiéndote al usuario, detallando la coherencia encontrada en su proyecto, la complejidad real que has asignado y por qué su proyecto vale esto..."
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
Bio del desarrollador: ${bio || "No proporcionada"}
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
    // Eliminar estimaciones previas si existen (para soportar recálculo limpio)
    await supabase.from("project_estimations").delete().eq("project_id", project_id);

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
