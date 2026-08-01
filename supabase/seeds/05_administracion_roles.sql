insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Administración'), 'Project Manager', 'Lidera la ejecución y entrega de proyectos en tiempo y forma.', 25000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Analista de Operaciones', 'Optimización y seguimiento de los procesos internos de la empresa.', 15000, 30000, 'MXN')
on conflict (professional_area_id, name) do nothing;
