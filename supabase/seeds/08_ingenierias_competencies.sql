insert into competencies (name, description, category) values
  -- CAD, CAE y Simulación
  ('CATIA', 'Software CAD/CAM/CAE avanzado muy usado en industria automotriz y aeroespacial.', 'tool'),
  ('ANSYS', 'Software de simulación para análisis de elementos finitos (FEA) y fluidos (CFD).', 'tool'),
  ('MATLAB', 'Plataforma de cálculo numérico, análisis de datos y desarrollo de algoritmos.', 'tool'),
  ('Simulink', 'Entorno de diagramas de bloques para simulación multidominio en MATLAB.', 'tool'),
  ('Siemens NX', 'Solución integrada CAD/CAM/CAE para diseño y manufactura avanzada.', 'tool'),
  ('PTC Creo', 'Suite de software de diseño CAD 3D.', 'tool'),
  ('LabVIEW', 'Entorno de desarrollo gráfico para sistemas de pruebas, medición y control.', 'tool'),
  ('Arena Simulation', 'Software de simulación de eventos discretos para optimización de procesos.', 'tool'),
  ('FlexSim', 'Software de simulación 3D para modelado de sistemas de manufactura y logística.', 'tool'),

  -- Automatización y Electrónica
  ('Programación de PLCs', 'Controladores lógicos programables para automatización de maquinaria.', 'domain_knowledge'),
  ('SCADA', 'Sistemas de supervisión, control y adquisición de datos industriales.', 'tool'),
  ('Automatización Industrial', 'Uso de sistemas de control para operar equipos con mínima intervención humana.', 'domain_knowledge'),
  ('Robótica Industrial', 'Programación y mantenimiento de brazos robóticos y celdas automatizadas.', 'domain_knowledge'),
  ('Diseño de Circuitos Electrónicos', 'Conocimientos de diseño de PCB y esquemáticos.', 'domain_knowledge'),

  -- Calidad y Manufactura
  ('Core Tools (APQP, PPAP, FMEA, SPC, MSA)', 'Herramientas clave de calidad usadas principalmente en industria automotriz.', 'domain_knowledge'),
  ('ISO 9001 (Gestión de Calidad)', 'Norma internacional para sistemas de gestión de calidad.', 'domain_knowledge'),
  ('Control Estadístico de Procesos (CEP/SPC)', 'Aplicación de métodos estadísticos para monitorear y controlar procesos.', 'domain_knowledge'),

  -- Ingeniería Mecánica, Civil y Químico/Ambiental
  ('Mecánica de Fluidos', 'Estudio del comportamiento de los fluidos en reposo o en movimiento.', 'domain_knowledge'),
  ('Termodinámica', 'Estudio de la energía, el calor y su transferencia en sistemas físicos.', 'domain_knowledge'),
  ('Resistencia de Materiales', 'Cálculo de tensiones y deformaciones en sólidos bajo cargas.', 'domain_knowledge'),
  ('Mantenimiento Productivo Total (TPM)', 'Metodología lean para el mantenimiento óptimo de equipos.', 'domain_knowledge'),
  ('Cálculo Estructural', 'Análisis de fuerzas y resistencia de materiales.', 'domain_knowledge'),

  -- Ingeniería Química y Procesos
  ('Aspen HYSYS', 'Software de simulación de procesos químicos y optimización.', 'tool'),
  ('Diseño de Reactores', 'Cálculo y diseño de equipos para reacciones químicas industriales.', 'domain_knowledge'),
  ('Operaciones Unitarias', 'Análisis de procesos de transferencia de masa y calor en la industria.', 'domain_knowledge'),
  
  -- Telecomunicaciones y Redes
  ('Cisco Packet Tracer', 'Simulador de redes de datos para diseño y configuración.', 'tool'),
  ('Diseño de Redes (LAN/WAN)', 'Arquitectura e implementación de infraestructura de telecomunicaciones.', 'domain_knowledge'),
  ('Radiofrecuencia (RF) y Microondas', 'Diseño y análisis de sistemas de transmisión inalámbrica.', 'domain_knowledge'),
  
  -- Ingeniería Ambiental
  ('Evaluación de Impacto Ambiental (EIA)', 'Análisis de los efectos ambientales de proyectos e industrias.', 'domain_knowledge'),
  ('Gestión de Residuos', 'Estrategias para el manejo y tratamiento de desechos industriales/urbanos.', 'domain_knowledge'),
  ('Tratamiento de Aguas', 'Procesos para la purificación y recuperación de recursos hídricos.', 'domain_knowledge'),
  
  -- Ingeniería Petrolera y Energía
  ('Simulación de Yacimientos', 'Modelado del comportamiento de fluidos en reservorios petroleros.', 'domain_knowledge'),
  ('Ingeniería de Perforación', 'Diseño y optimización de la perforación de pozos petroleros/gas.', 'domain_knowledge'),
  ('Energías Renovables', 'Diseño e implementación de sistemas solares, eólicos y alternativas energéticas.', 'domain_knowledge'),
  
  -- Manufactura y CNC
  ('Programación CNC', 'Programación de máquinas herramienta de control numérico computarizado.', 'domain_knowledge'),
  ('Metrología', 'Ciencia de la medición aplicada al aseguramiento de tolerancias industriales.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'CATIA', 'ANSYS', 'MATLAB', 'Simulink', 'Siemens NX', 'PTC Creo', 'LabVIEW', 'Arena Simulation', 'FlexSim',
  'Programación de PLCs', 'SCADA', 'Automatización Industrial', 'Robótica Industrial', 'Diseño de Circuitos Electrónicos',
  'Core Tools (APQP, PPAP, FMEA, SPC, MSA)', 'ISO 9001 (Gestión de Calidad)', 'Control Estadístico de Procesos (CEP/SPC)',
  'Mecánica de Fluidos', 'Termodinámica', 'Resistencia de Materiales', 'Mantenimiento Productivo Total (TPM)', 'Cálculo Estructural',
  'Aspen HYSYS', 'Diseño de Reactores', 'Operaciones Unitarias',
  'Cisco Packet Tracer', 'Diseño de Redes (LAN/WAN)', 'Radiofrecuencia (RF) y Microondas',
  'Evaluación de Impacto Ambiental (EIA)', 'Gestión de Residuos', 'Tratamiento de Aguas',
  'Simulación de Yacimientos', 'Ingeniería de Perforación', 'Energías Renovables',
  'Programación CNC', 'Metrología',
  -- Competencias transversales importadas de otras áreas:
  'SolidWorks', 'AutoCAD', 'Civil 3D', 'Microsoft Excel',
  'Lean Manufacturing / Lean Management', 'Six Sigma', 'Gestión de Proyectos (PM)', 'Supply Chain Management (SCM)',
  'Gestión de Inventarios', 'Evaluación de Proyectos de Inversión', 'Gestión de Presupuestos'
)
and a.name = 'Ingenierías'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Core Tools (APQP, PPAP, FMEA, SPC, MSA)',
  'ISO 9001 (Gestión de Calidad)',
  'Control Estadístico de Procesos (CEP/SPC)',
  'Mecánica de Fluidos',
  'Termodinámica',
  'Resistencia de Materiales',
  'Mantenimiento Productivo Total (TPM)',
  'Operaciones Unitarias',
  'Evaluación de Impacto Ambiental (EIA)',
  'Gestión de Residuos',
  'Tratamiento de Aguas',
  'Energías Renovables'
);
