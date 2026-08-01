insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Derecho'), 'Abogado Corporativo', 'Asesoría jurídica empresarial y elaboración de contratos.', 22000, 50000, 'MXN')
on conflict (professional_area_id, name) do nothing;
