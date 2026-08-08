insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Educación'), 'Docente de Educación Preescolar', 'Educación integral y desarrollo temprano de niños.', 8000, 15000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Docente de Educación Primaria', 'Formación básica, alfabetización y desarrollo cognitivo.', 9000, 18000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Docente de Secundaria / Media Superior', 'Educación de nivel medio y preparación para nivel superior.', 10000, 22000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Docente de Educación Superior', 'Impartición de clases a nivel universitario o posgrado.', 12000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Investigador Académico', 'Investigación científica o social en instituciones académicas.', 15000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Coordinador Académico', 'Organización y supervisión del personal docente y programas de estudio.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Director(a) de Institución Educativa', 'Gestión administrativa, académica y financiera de un centro escolar.', 25000, 60000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Orientador Educativo / Consejero', 'Apoyo psicológico y vocacional para estudiantes.', 10000, 20000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Diseñador Instruccional', 'Diseño de programas educativos, e-learning y materiales de aprendizaje.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Educador Especial / Maestro de Apoyo', 'Educación y adaptación curricular para estudiantes con necesidades especiales.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Educación'), 'Evaluador Educativo', 'Diseño e implementación de instrumentos para medir la calidad educativa.', 15000, 30000, 'MXN')
on conflict (professional_area_id, name) do nothing;
