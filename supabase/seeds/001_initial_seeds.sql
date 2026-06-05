insert into professional_areas (name, description)
values
  ('Tecnología', 'Desarrollo de software, datos e infraestructura tecnológica.'),
  ('Diseño', 'Diseño visual, experiencia de usuario e identidad de marca.'),
  ('Marketing', 'Marketing digital, posicionamiento y campañas.')
on conflict (name) do nothing;

insert into competencies (name, description, category)
values
  ('Flutter', 'Framework para construir aplicaciones multiplataforma.', 'Tecnología'),
  ('React', 'Biblioteca para construir interfaces web.', 'Tecnología'),
  ('Python', 'Lenguaje de programación de propósito general.', 'Tecnología'),
  ('PostgreSQL', 'Sistema de base de datos relacional.', 'Tecnología'),
  ('Git', 'Sistema de control de versiones.', 'Tecnología'),
  ('Figma', 'Herramienta de diseño de interfaces y prototipos.', 'Diseño'),
  ('Adobe Illustrator', 'Herramienta de ilustración y diseño vectorial.', 'Diseño'),
  ('SEO', 'Optimización para motores de búsqueda.', 'Marketing'),
  ('Google Ads', 'Plataforma de publicidad digital de Google.', 'Marketing')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
values
  (
    (select id from competencies where name = 'Flutter'),
    (select id from professional_areas where name = 'Tecnología')
  ),
  (
    (select id from competencies where name = 'React'),
    (select id from professional_areas where name = 'Tecnología')
  ),
  (
    (select id from competencies where name = 'Python'),
    (select id from professional_areas where name = 'Tecnología')
  ),
  (
    (select id from competencies where name = 'PostgreSQL'),
    (select id from professional_areas where name = 'Tecnología')
  ),
  (
    (select id from competencies where name = 'Git'),
    (select id from professional_areas where name = 'Tecnología')
  ),
  (
    (select id from competencies where name = 'Figma'),
    (select id from professional_areas where name = 'Diseño')
  ),
  (
    (select id from competencies where name = 'Adobe Illustrator'),
    (select id from professional_areas where name = 'Diseño')
  ),
  (
    (select id from competencies where name = 'SEO'),
    (select id from professional_areas where name = 'Marketing')
  ),
  (
    (select id from competencies where name = 'Google Ads'),
    (select id from professional_areas where name = 'Marketing')
  )
on conflict (competency_id, professional_area_id) do nothing;

insert into languages (name)
values
  ('Español'),
  ('Inglés')
on conflict (name) do nothing;

insert into language_levels (name, description)
values
  ('A1', 'Nivel inicial.'),
  ('A2', 'Nivel básico.'),
  ('B1', 'Nivel intermedio.'),
  ('B2', 'Nivel intermedio alto.'),
  ('C1', 'Nivel avanzado.'),
  ('C2', 'Nivel avanzado superior.'),
  ('Nativo', 'Dominio nativo del idioma.')
on conflict (name) do nothing;

insert into job_roles (
  professional_area_id,
  name,
  description,
  min_salary,
  max_salary,
  currency
)
values
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Desarrollador Frontend',
    'Construye interfaces web y aplicaciones cliente.',
    18000,
    35000,
    'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Desarrollador Backend',
    'Construye APIs, servicios y lógica de servidor.',
    20000,
    40000,
    'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Analista de Datos',
    'Analiza datos para generar reportes e insights.',
    18000,
    38000,
    'MXN'
  ),
  (
    (select id from professional_areas where name = 'Diseño'),
    'Diseñador UX/UI',
    'Diseña experiencias e interfaces digitales.',
    16000,
    32000,
    'MXN'
  ),
  (
    (select id from professional_areas where name = 'Marketing'),
    'Especialista SEO',
    'Optimiza contenido y sitios para buscadores.',
    15000,
    30000,
    'MXN'
  )
on conflict (professional_area_id, name) do nothing;
