insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador UX', 'Diseña la experiencia y el flujo de los usuarios en productos digitales.', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador UI', 'Diseña la interfaz visual, pantallas y componentes interactivos.', 18000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador UX/UI', 'Combina diseño de experiencia e interfaz para productos digitales.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Product Designer', 'Diseña el producto de principio a fin, alineando UX/UI con objetivos de negocio.', 25000, 55000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador Gráfico', 'Crea identidad visual corporativa, branding y materiales gráficos impresos o digitales.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador Web', 'Diseña la estructura visual y maquetación de sitios web.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Director de Arte', 'Lidera la visión visual y estética de proyectos creativos y de marketing.', 30000, 60000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador Editorial', 'Diseña maquetación de publicaciones impresas como libros, revistas y periódicos.', 12000, 22000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Animador / Motion Grapher', 'Crea animaciones y gráficos en movimiento para video y plataformas digitales.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador 3D / Modelador', 'Crea objetos, personajes y escenarios tridimensionales.', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Ilustrador Digital', 'Crea ilustraciones y piezas artísticas para diversos medios digitales.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador Industrial', 'Diseña productos físicos, mobiliario y objetos orientados a fabricación.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'Diseñador de Interiores', 'Diseña y optimiza espacios habitables y comerciales.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'UX Researcher', 'Investiga el comportamiento y necesidades de los usuarios para informar el diseño.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Diseño'), 'UX Writer', 'Escribe y optimiza los textos (microcopy) en interfaces para mejorar la UX.', 18000, 40000, 'MXN')
on conflict (professional_area_id, name) do nothing;
