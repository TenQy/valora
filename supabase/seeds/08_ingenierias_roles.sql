insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero Civil', 'Diseño y supervisión de obras de construcción civil e infraestructura.', 20000, 45000, 'MXN')
on conflict (professional_area_id, name) do nothing;
