insert into competencies (name, description, category) values
  ('Análisis Financiero', 'Evaluación de viabilidad y rentabilidad.', 'domain_knowledge'),
  ('Contabilidad Corporativa', 'Gestión contable de empresas.', 'domain_knowledge'),
  ('QuickBooks', 'Software de contabilidad.', 'tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('Análisis Financiero', 'Contabilidad Corporativa', 'QuickBooks')
and a.name = 'Finanzas'
on conflict (competency_id, professional_area_id) do nothing;
