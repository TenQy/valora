insert into competencies (name, description, category) values
  ('AutoCAD', 'Software de diseño asistido por computadora.', 'tool'),
  ('Revit', 'Modelado de información de construcción (BIM).', 'tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('AutoCAD', 'Revit')
and a.name = 'Arquitectura'
on conflict (competency_id, professional_area_id) do nothing;
