insert into competencies (name, description, category) values
  ('SEO', 'Optimización para motores de búsqueda.', 'domain_knowledge'),
  ('Google Ads', 'Plataforma de publicidad digital de Google.', 'marketing_tool'),
  ('Facebook Ads', 'Publicidad en plataformas de Meta.', 'marketing_tool'),
  ('Google Analytics', 'Análisis de tráfico web.', 'marketing_tool'),
  ('Copywriting', 'Redacción publicitaria persuasiva.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in ('SEO', 'Google Ads', 'Facebook Ads', 'Google Analytics', 'Copywriting')
and a.name = 'Marketing'
on conflict (competency_id, professional_area_id) do nothing;
