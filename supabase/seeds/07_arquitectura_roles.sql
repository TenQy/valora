insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Arquitectura'), 'Arquitecto Proyectista', 'Diseño de planos y conceptualización de espacios.', 18000, 40000, 'MXN')
on conflict (professional_area_id, name) do nothing;
