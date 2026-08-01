insert into competencies (name, description, category) values
  ('Derecho Corporativo', 'Leyes relacionadas con empresas y negocios.', 'domain_knowledge'),
  ('Litigio', 'Defensa legal en tribunales.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('Derecho Corporativo', 'Litigio')
and a.name = 'Derecho'
on conflict (competency_id, professional_area_id) do nothing;
