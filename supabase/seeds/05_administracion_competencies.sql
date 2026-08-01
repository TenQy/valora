insert into competencies (name, description, category) values
  ('Gestión de Proyectos', 'Planificación y ejecución de proyectos.', 'domain_knowledge'),
  ('Scrum', 'Marco de trabajo ágil.', 'framework'),
  ('SAP', 'Software ERP corporativo.', 'tool'),
  ('Excel Avanzado', 'Manejo experto de hojas de cálculo y macros.', 'tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('Gestión de Proyectos', 'Scrum', 'SAP', 'Excel Avanzado')
and a.name = 'Administración'
on conflict (competency_id, professional_area_id) do nothing;
