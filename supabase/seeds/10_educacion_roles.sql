insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Educación'), 'Docente de Educación Superior', 'Impartición de clases a nivel universitario o posgrado.', 12000, 30000, 'MXN')
on conflict (professional_area_id, name) do nothing;
