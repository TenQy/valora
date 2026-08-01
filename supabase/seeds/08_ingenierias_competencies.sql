insert into competencies (name, description, category) values
  ('Cálculo Estructural', 'Análisis de fuerzas y resistencia de materiales.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('Cálculo Estructural')
and a.name = 'Ingenierías'
on conflict (competency_id, professional_area_id) do nothing;
