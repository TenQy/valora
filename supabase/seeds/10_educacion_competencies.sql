insert into competencies (name, description, category) values
  ('Diseño Instruccional', 'Creación de experiencias de aprendizaje.', 'domain_knowledge'),
  ('Moodle', 'Plataforma de aprendizaje (LMS).', 'tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('Diseño Instruccional', 'Moodle')
and a.name = 'Educación'
on conflict (competency_id, professional_area_id) do nothing;
