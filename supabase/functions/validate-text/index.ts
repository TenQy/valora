import { createClient } from "npm:@supabase/supabase-js@2.39.7";
import { GoogleGenerativeAI } from "npm:@google/generative-ai";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
    // DISABLED AUTH FOR DEBUGGING
    /*
    const authHeader = req.headers.get("Authorization");

    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing Authorization header" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized user session" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }
    */

    const { text, type } = await req.json();

    if (!text || text.trim().length === 0) {
      return new Response(JSON.stringify({ isValid: false, reason: "Text is empty" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const geminiKey = Deno.env.get("GEMINI_API_KEY");
    if (!geminiKey) {
      // Si no hay llave configurada, lo dejamos pasar temporalmente (fail-open)
      console.warn("GEMINI_API_KEY not found. Allowing text by default.");
      return new Response(JSON.stringify({ isValid: true, reason: "No key configured" }), {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Call Gemini using the official SDK
    const genAI = new GoogleGenerativeAI(geminiKey);
    
    let promptContext = "una certificación o título profesional";
    if (type === "career") promptContext = "una carrera universitaria o profesión";
    
    const prompt = `Actúa como un validador de datos para una aplicación profesional llamada Valora. 
El usuario ha ingresado el siguiente texto que dice ser ${promptContext}:
"${text}"

Tu tarea es determinar si este texto es una broma, un insulto, texto sin sentido ("asdfg"), o algo claramente irreal (ej. "Comedor de hamburguesas", "Rey del mundo").
Si el texto parece un nombre realista, válido o posible (incluso si está escrito con alguna pequeña falta de ortografía), responde "true". 
Si es claramente inválido, falso, broma o basura, responde "false". 
Responde ÚNICAMENTE con la palabra "true" o "false", sin ningún otro texto.`;

    const modelsToTry = ["gemini-3.1-flash", "gemini-3.1-flash-lite", "gemini-2.5-flash", "gemini-2.5-flash-lite"];
    let lastError: any = null;

    for (const modelName of modelsToTry) {
      try {
        const model = genAI.getGenerativeModel({ model: modelName });
        const result = await model.generateContent({
          contents: [{ role: "user", parts: [{ text: prompt }] }],
          generationConfig: {
            maxOutputTokens: 10,
            temperature: 0.1,
          }
        });
        const response = await result.response;
        const resultText = response.text().trim().toLowerCase();
        const isValid = resultText === "true";

        return new Response(JSON.stringify({ isValid, modelUsed: modelName }), {
          status: 200,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      } catch (e: any) {
        console.warn(`Gemini API Error with model ${modelName}:`, e.message);
        lastError = e;
        // Si el error es 404, pasamos al siguiente modelo
      }
    }

    // Si todos los modelos fallaron
    console.error("All Gemini models failed. Last error:", lastError);
    return new Response(JSON.stringify({ error: `API failed for all fallback models. Last error: ${lastError?.message}` }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (err: unknown) {
    const errorMsg = err instanceof Error ? err.message : "Internal server error";
    return new Response(JSON.stringify({ error: errorMsg }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
