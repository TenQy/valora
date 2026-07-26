-- Poblar más competencias técnicas
insert into competencies (name, description, category)
values
  ('TypeScript', 'Superset de JavaScript tipado.', 'language'),
  ('Node.js', 'Entorno de ejecución para JavaScript en el servidor.', 'framework'),
  ('AWS', 'Amazon Web Services, plataforma de nube.', 'tool'),
  ('Docker', 'Plataforma para contenedores de software.', 'tool'),
  ('Dart', 'Lenguaje optimizado para UI, usado por Flutter.', 'language'),
  ('Firebase', 'Plataforma de desarrollo móvil de Google.', 'database'),
  ('MongoDB', 'Base de datos NoSQL orientada a documentos.', 'database'),
  ('SQL', 'Lenguaje de consulta estructurada para BD relacionales.', 'language'),
  ('UI/UX', 'Diseño de interfaz y experiencia de usuario.', 'domain_knowledge'),
  ('Kubernetes', 'Orquestación de contenedores.', 'tool')
on conflict (name) do nothing;

-- Relacionar competencias con el área de Tecnología (y Diseño para UI/UX)
insert into competency_areas (competency_id, professional_area_id)
values
  ((select id from competencies where name = 'TypeScript'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'Node.js'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'AWS'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'Docker'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'Dart'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'Firebase'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'MongoDB'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'SQL'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'Kubernetes'), (select id from professional_areas where name = 'Tecnología')),
  ((select id from competencies where name = 'UI/UX'), (select id from professional_areas where name = 'Diseño'))
on conflict (competency_id, professional_area_id) do nothing;

-- Poblar más roles laborales para hacer match
insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency)
values
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Desarrollador Full Stack',
    'Domina tanto el frontend como el backend de las aplicaciones.',
    25000, 50000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Desarrollador Móvil',
    'Crea aplicaciones nativas o multiplataforma para iOS y Android.',
    22000, 45000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Tecnología'),
    'Ingeniero DevOps',
    'Automatiza despliegues y administra infraestructura en la nube.',
    30000, 60000, 'MXN'
  ),
  (
    (select id from professional_areas where name = 'Diseño'),
    'Diseñador UX/UI',
    'Diseña interfaces intuitivas y atractivas centradas en el usuario.',
    18000, 35000, 'MXN'
  )
on conflict (professional_area_id, name) do nothing;
