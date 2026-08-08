insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Derecho'), 'Abogado(a) / Litigante', 'Representación legal en procedimientos judiciales y resolución de conflictos.', 15000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Asesor Legal Corporativo', 'Asesoría jurídica empresarial, redacción de contratos y cumplimiento normativo.', 22000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Juez / Magistrado', 'Impartición de justicia y resolución de controversias en tribunales.', 40000, 90000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Notario Público', 'Funcionario que otorga fe pública para validar actos y contratos.', 40000, 100000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Fiscal / Ministerio Público', 'Investigación de delitos y ejercicio de la acción penal ante tribunales.', 20000, 55000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Defensor Público', 'Provisión de asistencia legal gratuita a quienes no pueden pagar un abogado.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Mediador / Conciliador', 'Facilitación de acuerdos extrajudiciales para la resolución de disputas.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Asistente Legal (Paralegal)', 'Apoyo en investigación, redacción de documentos y trámites judiciales.', 10000, 20000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Perito', 'Especialista que proporciona análisis técnico o científico para procesos legales.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Derecho'), 'Consultor Jurídico', 'Orientación especializada en ramas específicas del derecho e instituciones.', 20000, 60000, 'MXN')
on conflict (professional_area_id, name) do nothing;
