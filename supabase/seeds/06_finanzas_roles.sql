insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Finanzas'), 'Analista Financiero', 'Evaluación de proyectos de inversión y proyecciones financieras.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Contador Fiscal', 'Gestión de obligaciones fiscales y contables corporativas.', 18000, 35000, 'MXN')
on conflict (professional_area_id, name) do nothing;
