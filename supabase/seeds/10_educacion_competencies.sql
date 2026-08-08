insert into competencies (name, description, category) values
  -- Sistemas de Gestión del Aprendizaje (LMS)
  ('Moodle', 'Plataforma de aprendizaje (LMS) de código abierto.', 'tool'),
  ('Canvas LMS', 'Sistema de gestión de aprendizaje líder en educación superior.', 'tool'),
  ('Blackboard', 'Entorno de aprendizaje virtual y sistema de gestión de cursos.', 'tool'),
  ('Google Classroom', 'Plataforma educativa gratuita para escuelas y profesores.', 'tool'),
  ('Microsoft Teams para Educación', 'Espacio de colaboración digital para aulas.', 'tool'),

  -- Herramientas de Creación de Contenido e Interacción
  ('Articulate Storyline', 'Software para la creación de cursos e-learning interactivos.', 'tool'),
  ('Adobe Captivate', 'Herramienta de autoría rápida para e-learning.', 'tool'),
  ('Kahoot!', 'Plataforma de aprendizaje basada en juegos y cuestionarios interactivos.', 'tool'),
  ('Genially', 'Herramienta en línea para crear presentaciones y contenidos interactivos.', 'tool'),
  ('Zoom', 'Plataforma de videoconferencias, vital para educación a distancia.', 'tool'),

  -- Conceptos y Metodologías
  ('Pedagogía General', 'Ciencia y arte de la educación y enseñanza de los niños.', 'domain_knowledge'),
  ('Didáctica', 'Técnicas y métodos de enseñanza para facilitar el aprendizaje.', 'domain_knowledge'),
  ('Diseño Instruccional', 'Planificación y creación estructurada de experiencias de aprendizaje.', 'domain_knowledge'),
  ('Aprendizaje Basado en Proyectos (ABP)', 'Metodología donde los estudiantes aprenden resolviendo problemas reales.', 'domain_knowledge'),
  ('Flipped Classroom (Aula Invertida)', 'Modelo pedagógico que invierte los métodos tradicionales de enseñanza.', 'domain_knowledge'),
  ('Gamificación Educativa', 'Uso de mecánicas de juego en entornos educativos para mejorar el compromiso.', 'domain_knowledge'),
  ('Evaluación del Aprendizaje', 'Diseño de instrumentos para medir los conocimientos adquiridos.', 'domain_knowledge'),
  ('Inclusión Educativa', 'Atención a la diversidad y necesidades educativas especiales (NEE).', 'domain_knowledge'),
  ('Diseño de Currículo', 'Planificación de los contenidos, objetivos y criterios de evaluación educativos.', 'domain_knowledge'),
  ('E-learning / Educación a Distancia', 'Modalidad de enseñanza y aprendizaje a través de medios digitales.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Moodle', 'Canvas LMS', 'Blackboard', 'Google Classroom', 'Microsoft Teams para Educación',
  'Articulate Storyline', 'Adobe Captivate', 'Kahoot!', 'Genially', 'Zoom',
  'Pedagogía General', 'Didáctica', 'Diseño Instruccional', 'Aprendizaje Basado en Proyectos (ABP)',
  'Flipped Classroom (Aula Invertida)', 'Gamificación Educativa', 'Evaluación del Aprendizaje',
  'Inclusión Educativa', 'Diseño de Currículo', 'E-learning / Educación a Distancia',
  -- Competencias transversales
  'Microsoft Word', 'Microsoft Excel', 'Microsoft PowerPoint', 'Google Workspace'
)
and a.name = 'Educación'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Pedagogía General',
  'Didáctica',
  'Diseño Instruccional',
  'Aprendizaje Basado en Proyectos (ABP)',
  'Flipped Classroom (Aula Invertida)',
  'Gamificación Educativa',
  'Evaluación del Aprendizaje',
  'Inclusión Educativa',
  'Diseño de Currículo',
  'E-learning / Educación a Distancia'
);
