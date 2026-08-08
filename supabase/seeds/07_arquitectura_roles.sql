insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Arquitectura'), 'Arquitecto(a)', 'Diseña, planifica y supervisa la construcción de edificaciones.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Arquitecto(a) Proyectista', 'Enfocado en el diseño, desarrollo de planos y conceptualización espacial.', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Arquitecto(a) Residente de Obra', 'Supervisa la ejecución del proyecto en sitio, controlando calidad y tiempos.', 18000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'BIM Manager', 'Lidera la implementación y gestión de modelos BIM en proyectos arquitectónicos.', 30000, 60000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Urbanista', 'Planifica y diseña estrategias para el desarrollo de ciudades y espacios públicos.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Arquitecto(a) Paisajista', 'Diseña y gestiona espacios exteriores, áreas verdes y medio ambiente natural.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Dibujante / Cadista', 'Elabora y digitaliza planos arquitectónicos y de ingeniería en 2D/3D.', 10000, 20000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Calculista / Especialista en Estructuras', 'Diseña y calcula la resistencia y viabilidad de las estructuras de la obra.', 22000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Analista de Costos y Presupuestos', 'Realiza la cuantificación, análisis de precios unitarios y presupuestos de obra.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Director de Obra', 'Máximo responsable técnico y administrativo de la ejecución de una construcción.', 35000, 80000, 'MXN'),
  ((select id from professional_areas where name = 'Arquitectura'), 'Arquitecto(a) de Interiores', 'Diseña, planifica y distribuye espacios habitables o comerciales.', 15000, 35000, 'MXN')
on conflict (professional_area_id, name) do nothing;
