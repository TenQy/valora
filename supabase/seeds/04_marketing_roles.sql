insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Marketing'), 'Especialista SEO', 'Optimiza contenido y sitios para buscadores.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Social Media Manager', 'Gestión de comunidades y estrategias en redes sociales.', 12000, 28000, 'MXN')
on conflict (professional_area_id, name) do nothing;
