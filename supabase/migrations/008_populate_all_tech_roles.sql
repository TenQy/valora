-- Poblar masivo de roles para el área de Tecnología
insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency)
values
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero de Software',
    'Diseña y construye sistemas de software complejos y escalables.',
    25000, 55000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Arquitecto de Software',
    'Define la estructura, patrones y decisiones técnicas de alto nivel de un sistema.',
    40000, 80000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero de Datos',
    'Construye y mantiene infraestructuras para la extracción, transformación y carga de datos (ETL).',
    25000, 55000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Administrador de Base de Datos (DBA)',
    'Gestiona, optimiza y asegura el rendimiento de las bases de datos.',
    20000, 45000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero de Machine Learning',
    'Desarrolla e implementa modelos predictivos y algoritmos de aprendizaje automático.',
    30000, 70000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Especialista en Ciberseguridad',
    'Protege redes, sistemas y datos de ataques cibernéticos y vulnerabilidades.',
    30000, 65000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero QA (Quality Assurance)',
    'Diseña y ejecuta pruebas automatizadas y manuales para garantizar la calidad del software.',
    18000, 40000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Scrum Master',
    'Facilita la metodología ágil y elimina impedimentos para el equipo de desarrollo.',
    25000, 50000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Product Manager Técnico',
    'Lidera la visión del producto combinando conocimiento de negocio y entendimiento técnico.',
    35000, 75000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Administrador de Sistemas',
    'Configura, mantiene y asegura el funcionamiento de servidores y sistemas informáticos.',
    15000, 35000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero Cloud',
    'Diseña y migra arquitecturas a plataformas en la nube (AWS, Azure, GCP).',
    30000, 65000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Desarrollador de Videojuegos',
    'Crea lógica, mecánicas y gráficos utilizando motores como Unity o Unreal.',
    18000, 45000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero de Blockchain',
    'Desarrolla contratos inteligentes y arquitecturas descentralizadas.',
    35000, 80000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Site Reliability Engineer (SRE)',
    'Aplica principios de ingeniería de software a operaciones para asegurar sistemas ultra disponibles.',
    35000, 75000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Especialista en Inteligencia Artificial',
    'Investiga y aplica modelos de IA generativa, NLP o visión computacional.',
    40000, 85000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero de Redes',
    'Diseña, implementa y gestiona infraestructuras de telecomunicaciones empresariales.',
    18000, 40000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Soporte Técnico / Help Desk',
    'Resuelve problemas de hardware y software a nivel usuario o corporativo.',
    10000, 20000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Analista de Negocios TI',
    'Traduce requerimientos comerciales en especificaciones técnicas de software.',
    22000, 45000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Especialista IoT (Internet de las Cosas)',
    'Desarrolla ecosistemas conectados de sensores y dispositivos inteligentes.',
    25000, 55000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero de Sistemas Embebidos',
    'Programa microcontroladores y hardware de bajo nivel.',
    25000, 55000, 'MXN'
  )
on conflict (professional_area_id, name) do nothing;
