insert into competencies (name, description, category) values
  ('Primeros Auxilios', 'Atención médica inmediata de emergencia.', 'domain_knowledge'),
  ('Expediente Clínico Electrónico', 'Manejo de historiales médicos digitales.', 'tool'),
  ('Psicoterapia Cognitivo Conductual', 'Enfoque terapéutico psicológico.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('Primeros Auxilios', 'Expediente Clínico Electrónico', 'Psicoterapia Cognitivo Conductual')
and a.name = 'Salud'
on conflict (competency_id, professional_area_id) do nothing;
