insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Salud'), 'Médico General', 'Atención médica primaria y preventiva.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Psicólogo Clínico', 'Diagnóstico y tratamiento de trastornos psicológicos.', 15000, 35000, 'MXN')
on conflict (professional_area_id, name) do nothing;
