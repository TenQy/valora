insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Civil', 'Diseño, cálculo y supervisión de obras de construcción e infraestructura.', 18000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Industrial', 'Optimización de procesos, recursos y sistemas productivos o de servicios.', 15000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Mecánico', 'Diseño, análisis y fabricación de maquinaria y sistemas mecánicos.', 18000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Eléctrico', 'Diseño, instalación y mantenimiento de sistemas eléctricos y de potencia.', 18000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Mecatrónico', 'Integración de mecánica, electrónica y control para automatización.', 20000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Químico', 'Diseño y control de procesos químicos e industriales a gran escala.', 20000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) de Manufactura / Producción', 'Gestión, diseño y mejora de líneas de producción y ensamblaje.', 18000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) de Calidad', 'Aseguramiento del cumplimiento de normativas de calidad en productos/servicios.', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) en Telecomunicaciones', 'Diseño y mantenimiento de redes de comunicación y transmisión de datos.', 18000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Ambiental', 'Desarrollo de soluciones para prevenir y mitigar el impacto ambiental.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Automotriz', 'Diseño, desarrollo y manufactura de vehículos y componentes automotrices.', 22000, 55000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) Petrolero / Energía', 'Extracción de recursos y diseño de sistemas energéticos.', 25000, 70000, 'MXN'),
  ((select id from professional_areas where name = 'Ingenierías'), 'Ingeniero(a) de Mantenimiento', 'Planificación y ejecución del mantenimiento preventivo y correctivo de planta.', 15000, 35000, 'MXN')
on conflict (professional_area_id, name) do nothing;
