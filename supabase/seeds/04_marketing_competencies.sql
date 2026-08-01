insert into competencies (name, description, category) values
  -- Plataformas Publicitarias (Paid Media / SEM)
  ('Google Ads', 'Plataforma líder para publicidad en motores de búsqueda y red de display.', 'marketing_tool'),
  ('Meta Ads', 'Plataforma de publicidad pagada para Facebook, Instagram y WhatsApp.', 'marketing_tool'),
  ('LinkedIn Ads', 'Publicidad B2B orientada a profesionales y empresas.', 'marketing_tool'),
  ('TikTok Ads', 'Publicidad enfocada en formatos de video corto para audiencias jóvenes.', 'marketing_tool'),
  ('Programmatic Advertising', 'Compra automatizada de espacios publicitarios digitales.', 'domain_knowledge'),
  
  -- Analítica y Datos
  ('Google Analytics (GA4)', 'Herramienta esencial para medición de tráfico y comportamiento web.', 'marketing_tool'),
  ('Google Tag Manager (GTM)', 'Gestión e inyección de etiquetas de seguimiento en sitios web.', 'marketing_tool'),
  ('Looker Studio', 'Plataforma de visualización de datos y reportes (antes Google Data Studio).', 'marketing_tool'),
  ('Metricool', 'Herramienta de análisis, gestión y medición de redes sociales.', 'marketing_tool'),
  ('Adobe Analytics', 'Plataforma avanzada de análisis de datos para marketing empresarial.', 'marketing_tool'),
  ('Análisis de Datos en Marketing', 'Interpretación de KPIs para mejorar el retorno de inversión (ROI).', 'domain_knowledge'),

  -- SEO (Search Engine Optimization)
  ('SEO On-Page', 'Optimización técnica y de contenido dentro del propio sitio web.', 'domain_knowledge'),
  ('SEO Off-Page', 'Estrategias externas como link building para mejorar la autoridad del dominio.', 'domain_knowledge'),
  ('Keyword Research', 'Investigación de palabras clave para orientar la estrategia de contenido.', 'domain_knowledge'),
  ('SEMrush', 'Herramienta integral de análisis SEO, SEM y competitividad.', 'marketing_tool'),
  ('Ahrefs', 'Plataforma especializada en investigación de enlaces y análisis SEO.', 'marketing_tool'),
  ('Google Search Console', 'Herramienta para monitorear el estado de indexación de un sitio en Google.', 'marketing_tool'),

  -- Redes Sociales y Gestión de Comunidades
  ('Hootsuite', 'Plataforma de programación y gestión de redes sociales.', 'marketing_tool'),
  ('Sprout Social', 'Software integral de gestión y escucha social para marcas.', 'marketing_tool'),
  ('Estrategia de Redes Sociales', 'Planificación de contenido y crecimiento en plataformas sociales.', 'domain_knowledge'),
  ('Gestión de Comunidades', 'Interacción y construcción de relaciones con la audiencia digital.', 'domain_knowledge'),
  ('Gestión de Crisis', 'Manejo de reputación ante eventos negativos en medios digitales.', 'domain_knowledge'),

  -- CRM, Email & Inbound Marketing
  ('HubSpot', 'Plataforma integral de CRM y automatización de Inbound Marketing.', 'marketing_tool'),
  ('Salesforce', 'El CRM más utilizado a nivel global para gestión de ventas y marketing.', 'marketing_tool'),
  ('Mailchimp', 'Plataforma popular para envío masivo de correos y automatizaciones básicas.', 'marketing_tool'),
  ('Klaviyo', 'Herramienta avanzada de email y SMS marketing, muy usada en E-commerce.', 'marketing_tool'),
  ('ActiveCampaign', 'Software de automatización de email marketing y ventas.', 'marketing_tool'),
  ('Inbound Marketing', 'Metodología para atraer prospectos de forma no invasiva.', 'domain_knowledge'),
  ('Lead Nurturing', 'Proceso de cultivar relaciones con posibles clientes a través de un embudo.', 'domain_knowledge'),
  ('Automatización de Marketing', 'Uso de software para automatizar tareas repetitivas de marketing.', 'domain_knowledge'),

  -- E-commerce y Plataformas Web
  ('WordPress', 'Sistema de gestión de contenidos (CMS) predominante en la web.', 'marketing_tool'),
  ('Shopify', 'Plataforma líder para creación y gestión de tiendas en línea.', 'marketing_tool'),
  ('WooCommerce', 'Plugin de comercio electrónico de código abierto para WordPress.', 'marketing_tool'),
  ('Optimización de Tasa de Conversión (CRO)', 'Prácticas para aumentar el porcentaje de visitantes que compran o convierten.', 'domain_knowledge'),

  -- Contenido y Redacción
  ('Redacción Publicitaria (Copywriting)', 'Escritura persuasiva con el objetivo de generar ventas o conversiones.', 'domain_knowledge'),
  ('Storytelling', 'Técnica de comunicación narrativa para conectar con la audiencia.', 'domain_knowledge'),
  ('Estrategia de Contenido', 'Planificación del desarrollo y distribución de contenido valioso.', 'domain_knowledge'),
  ('Edición de Video (CapCut / Reels)', 'Habilidad básica para crear contenido nativo y dinámico para redes.', 'domain_knowledge'),

  -- Conceptos Estratégicos
  ('Growth Hacking', 'Estrategias creativas y analíticas para escalar rápidamente un negocio.', 'domain_knowledge'),
  ('Marketing de Afiliados', 'Promoción de productos de terceros a cambio de una comisión.', 'domain_knowledge'),
  ('Relaciones Públicas (PR)', 'Gestión de la comunicación estratégica entre una organización y el público.', 'domain_knowledge'),
  ('Posicionamiento de Marca (Branding)', 'Estrategia para ubicar una marca en la mente de los consumidores.', 'domain_knowledge'),
  ('Análisis de Competencia', 'Monitoreo de tácticas y resultados de empresas rivales.', 'domain_knowledge'),
  ('Marketing de Influencers', 'Colaboraciones comerciales con creadores de contenido.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Google Ads', 'Meta Ads', 'LinkedIn Ads', 'TikTok Ads', 'Programmatic Advertising',
  'Google Analytics (GA4)', 'Google Tag Manager (GTM)', 'Looker Studio', 'Metricool', 'Adobe Analytics', 'Análisis de Datos en Marketing',
  'SEO On-Page', 'SEO Off-Page', 'Keyword Research', 'SEMrush', 'Ahrefs', 'Google Search Console',
  'Hootsuite', 'Sprout Social', 'Estrategia de Redes Sociales', 'Gestión de Comunidades', 'Gestión de Crisis',
  'HubSpot', 'Salesforce', 'Mailchimp', 'Klaviyo', 'ActiveCampaign', 'Inbound Marketing', 'Lead Nurturing', 'Automatización de Marketing',
  'WordPress', 'Shopify', 'WooCommerce', 'Optimización de Tasa de Conversión (CRO)',
  'Redacción Publicitaria (Copywriting)', 'Storytelling', 'Estrategia de Contenido', 'Edición de Video (CapCut / Reels)',
  'Growth Hacking', 'Marketing de Afiliados', 'Relaciones Públicas (PR)', 'Posicionamiento de Marca (Branding)', 'Análisis de Competencia', 'Marketing de Influencers'
)
and a.name = 'Marketing'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Programmatic Advertising',
  'Estrategia de Redes Sociales',
  'Gestión de Comunidades',
  'Gestión de Crisis',
  'Inbound Marketing',
  'Lead Nurturing',
  'Automatización de Marketing',
  'Optimización de Tasa de Conversión (CRO)',
  'Storytelling',
  'Estrategia de Contenido',
  'Growth Hacking',
  'Marketing de Afiliados',
  'Relaciones Públicas (PR)',
  'Posicionamiento de Marca (Branding)',
  'Análisis de Competencia',
  'Marketing de Influencers'
);
