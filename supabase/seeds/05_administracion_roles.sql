insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Administración'), 'Asistente Administrativo', 'Brinda soporte en tareas de oficina, gestión de agenda y atención al cliente.', 8000, 15000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Auxiliar Administrativo', 'Realiza tareas de archivo, captura de datos y apoyo operativo general.', 7000, 12000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Recepcionista / Office Manager', 'Gestiona la recepción, paquetería y el correcto funcionamiento de la oficina.', 8000, 18000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Especialista en Recursos Humanos (HR)', 'Gestiona procesos de reclutamiento, clima laboral y desarrollo organizacional.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Reclutador / Talent Acquisition', 'Busca, filtra y selecciona talento para cubrir vacantes de la empresa.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'HR Manager / Gerente de RRHH', 'Lidera la estrategia de capital humano y retención de talento en la organización.', 30000, 70000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Especialista en Nómina', 'Procesa pagos, incidencias y cálculos de impuestos de los empleados.', 15000, 28000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Analista de Operaciones', 'Mide, optimiza y da seguimiento a los procesos internos de la empresa.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Gerente de Operaciones (COO)', 'Dirige las operaciones diarias asegurando la eficiencia de los procesos y recursos.', 45000, 100000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Especialista en Logística / Supply Chain', 'Coordina el transporte, inventarios y cadena de suministro.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Analista de Compras (Procurement)', 'Busca, negocia y adquiere los insumos y servicios necesarios al mejor costo.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Project Manager', 'Lidera la planificación, ejecución y entrega de proyectos en tiempo y forma.', 25000, 60000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Coordinador de Instalaciones (Facilities)', 'Supervisa el mantenimiento, seguridad y servicios de los espacios físicos.', 15000, 28000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Gerente General (CEO / General Manager)', 'Máximo responsable de la estrategia, visión y resultados financieros de la empresa.', 60000, 150000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Especialista en Desarrollo Organizacional', 'Diseña estrategias para mejorar la cultura, el desempeño y el diseño de la empresa.', 20000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Asistente Ejecutivo', 'Asiste a directivos de alto nivel en la organización de su agenda y proyectos clave.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Administración'), 'Especialista en Desarrollo de Negocios', 'Identifica nuevas oportunidades de mercado, alianzas y clientes potenciales.', 20000, 50000, 'MXN')
on conflict (professional_area_id, name) do nothing;
