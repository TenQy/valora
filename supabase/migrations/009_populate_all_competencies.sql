-- Poblar masivo de competencias tecnológicas
insert into competencies (name, description, category)
values
  -- Tecnología: Lenguajes
  ('Java', 'Lenguaje de programación orientado a objetos empresarial.', 'language'),
  ('C#', 'Lenguaje de programación desarrollado por Microsoft.', 'language'),
  ('C++', 'Lenguaje de propósito general de alto rendimiento.', 'language'),
  ('PHP', 'Lenguaje de script para desarrollo web.', 'language'),
  ('Swift', 'Lenguaje de programación para ecosistema Apple.', 'language'),
  ('Kotlin', 'Lenguaje moderno oficial para Android.', 'language'),
  ('Ruby', 'Lenguaje de programación dinámico y reflexivo.', 'language'),
  ('Rust', 'Lenguaje enfocado en rendimiento y seguridad.', 'language'),
  ('Go', 'Lenguaje concurrente desarrollado por Google.', 'language'),
  
  -- Tecnología: Frameworks
  ('Angular', 'Plataforma para construir interfaces web (Google).', 'framework'),
  ('Vue.js', 'Framework progresivo para interfaces de usuario.', 'framework'),
  ('Svelte', 'Compilador que genera código JavaScript optimizado.', 'framework'),
  ('Next.js', 'Framework de React para SSR y SSG.', 'framework'),
  ('Django', 'Framework web de alto nivel para Python.', 'framework'),
  ('Spring Boot', 'Framework para crear aplicaciones con Java.', 'framework'),
  ('.NET', 'Plataforma de desarrollo multiplataforma (Microsoft).', 'framework'),
  ('Laravel', 'Framework PHP elegante para artesanos web.', 'framework'),
  ('Express', 'Infraestructura web rápida y minimalista para Node.js.', 'framework'),
  ('TailwindCSS', 'Framework CSS utility-first.', 'framework'),
  
  -- Tecnología: Bases de datos
  ('MySQL', 'Sistema de gestión de bases de datos relacional.', 'database'),
  ('Oracle', 'Base de datos empresarial.', 'database'),
  ('Redis', 'Almacén de estructura de datos en memoria.', 'database'),
  ('Elasticsearch', 'Motor de búsqueda y analítica distribuido.', 'database'),
  ('DynamoDB', 'Base de datos NoSQL clave-valor de Amazon.', 'database'),

  -- Tecnología: Herramientas y DevOps
  ('Linux', 'Sistema operativo de código abierto.', 'tool'),
  ('Terraform', 'Herramienta de infraestructura como código.', 'tool'),
  ('Ansible', 'Plataforma de automatización de TI.', 'tool'),
  ('Jenkins', 'Servidor de automatización open source.', 'tool'),
  ('GitHub Actions', 'CI/CD integrado en GitHub.', 'tool'),
  ('Jira', 'Herramienta de gestión de proyectos y seguimiento de errores.', 'tool'),
  
  -- Tecnología: Dominio
  ('Microservicios', 'Arquitectura estructurada en servicios pequeños.', 'domain_knowledge'),
  ('GraphQL', 'Lenguaje de consulta para APIs.', 'domain_knowledge'),
  ('REST APIs', 'Estilo de arquitectura de software para servicios web.', 'domain_knowledge'),
  ('CI/CD', 'Integración y Entrega Continua.', 'domain_knowledge'),
  ('TDD', 'Desarrollo guiado por pruebas.', 'domain_knowledge'),

  -- Diseño: Herramientas
  ('Adobe Photoshop', 'Edición de imágenes y gráficos rasterizados.', 'design_tool'),
  ('Adobe XD', 'Prototipado y diseño de experiencia de usuario.', 'design_tool'),
  ('Sketch', 'Editor de gráficos vectoriales para Mac.', 'design_tool'),
  ('InVision', 'Plataforma de diseño de productos digitales.', 'design_tool'),
  ('Blender', 'Suite de creación 3D de código abierto.', 'design_tool'),
  ('After Effects', 'Efectos visuales y gráficos en movimiento.', 'design_tool'),

  -- Diseño: Dominio
  ('Wireframing', 'Creación de esquemas de página web o app.', 'domain_knowledge'),
  ('Prototypado', 'Creación de simulaciones interactivas.', 'domain_knowledge'),
  ('Design Thinking', 'Metodología para la resolución de problemas centrada en el usuario.', 'domain_knowledge'),
  ('Teoría del Color', 'Reglas básicas de la mezcla de colores en diseño.', 'domain_knowledge'),

  -- Marketing: Herramientas
  ('Google Analytics', 'Servicio de análisis web de Google.', 'marketing_tool'),
  ('Facebook Ads', 'Plataforma de publicidad de Meta.', 'marketing_tool'),
  ('LinkedIn Ads', 'Publicidad en la red profesional B2B.', 'marketing_tool'),
  ('Mailchimp', 'Plataforma de automatización de marketing y email.', 'marketing_tool'),
  ('HubSpot', 'Software de inbound marketing y ventas.', 'marketing_tool'),
  ('Salesforce', 'Plataforma CRM basada en la nube.', 'marketing_tool'),
  ('SEMrush', 'Herramienta para investigación de palabras clave.', 'marketing_tool'),
  ('WordPress', 'Sistema de gestión de contenidos web.', 'marketing_tool'),

  -- Marketing: Dominio
  ('Inbound Marketing', 'Metodología comercial que atrae clientes creando contenido valioso.', 'domain_knowledge'),
  ('Copywriting', 'Redacción publicitaria persuasiva.', 'domain_knowledge'),
  ('Email Marketing', 'Envío de correos comerciales para fidelizar.', 'domain_knowledge'),
  ('CRO', 'Optimización del ratio de conversión.', 'domain_knowledge'),
  ('Growth Hacking', 'Estrategias orientadas al crecimiento acelerado.', 'domain_knowledge')
on conflict (name) do nothing;


-- Vinculación masiva de Tecnología
insert into competency_areas (competency_id, professional_area_id)
select id, (select id from professional_areas where name = 'Tecnología')
from competencies
where name in (
  'Java', 'C#', 'C++', 'PHP', 'Swift', 'Kotlin', 'Ruby', 'Rust', 'Go',
  'Angular', 'Vue.js', 'Svelte', 'Next.js', 'Django', 'Spring Boot', '.NET', 'Laravel', 'Express', 'TailwindCSS',
  'MySQL', 'Oracle', 'Redis', 'Elasticsearch', 'DynamoDB',
  'Linux', 'Terraform', 'Ansible', 'Jenkins', 'GitHub Actions', 'Jira',
  'Microservicios', 'GraphQL', 'REST APIs', 'CI/CD', 'TDD'
)
on conflict (competency_id, professional_area_id) do nothing;


-- Vinculación masiva de Diseño
insert into competency_areas (competency_id, professional_area_id)
select id, (select id from professional_areas where name = 'Diseño')
from competencies
where name in (
  'Adobe Photoshop', 'Adobe XD', 'Sketch', 'InVision', 'Blender', 'After Effects',
  'Wireframing', 'Prototypado', 'Design Thinking', 'Teoría del Color'
)
on conflict (competency_id, professional_area_id) do nothing;


-- Vinculación masiva de Marketing
insert into competency_areas (competency_id, professional_area_id)
select id, (select id from professional_areas where name = 'Marketing')
from competencies
where name in (
  'Google Analytics', 'Facebook Ads', 'LinkedIn Ads', 'Mailchimp', 'HubSpot', 'Salesforce', 'SEMrush', 'WordPress',
  'Inbound Marketing', 'Copywriting', 'Email Marketing', 'CRO', 'Growth Hacking'
)
on conflict (competency_id, professional_area_id) do nothing;
