insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador UX/UI', 'Diseña experiencias e interfaces digitales centradas en el usuario.', 18000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador Gráfico', 'Creación de identidad visual corporativa y materiales gráficos.', 12000, 25000, 'MXN')
on conflict (professional_area_id, name) do nothing;
