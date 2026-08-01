insert into competencies (name, description, category) values
  -- Herramientas de Diseño y BIM
  ('AutoCAD', 'Software estándar para dibujo asistido por computadora en 2D y 3D.', 'tool'),
  ('Revit', 'Plataforma líder para Modelado de Información de Construcción (BIM).', 'tool'),
  ('ArchiCAD', 'Software BIM enfocado en la arquitectura y el diseño de edificios.', 'tool'),
  ('Navisworks', 'Software de revisión de proyectos 3D para coordinación y análisis.', 'tool'),
  ('Civil 3D', 'Software de diseño y documentación para ingeniería civil.', 'tool'),

  -- Renderizado y Visualización
  ('Enscape', 'Renderizado en tiempo real y realidad virtual integrado en herramientas CAD.', 'design_tool'),
  ('Twinmotion', 'Herramienta de visualización inmersiva en tiempo real.', 'design_tool'),

  -- Herramientas de Gestión de Obra y Costos (Especializadas en Latam)
  ('Neodata', 'Software líder en México para análisis de precios unitarios y presupuestos.', 'tool'),
  ('Opus', 'Sistema integral para la planeación y control integral de la construcción.', 'tool'),

  -- Conceptos y Metodologías
  ('Building Information Modeling (BIM)', 'Metodología de trabajo colaborativo para creación y gestión de proyectos.', 'domain_knowledge'),
  ('Dibujo Técnico / Planos', 'Elaboración e interpretación de representación gráfica estandarizada.', 'domain_knowledge'),
  ('Diseño Estructural', 'Conocimiento del comportamiento y cálculo de estructuras de soporte.', 'domain_knowledge'),
  ('Diseño Sustentable / LEED', 'Principios para la creación de proyectos ecológicos y de eficiencia energética.', 'domain_knowledge'),
  ('Urbanismo', 'Estudio, planificación y ordenamiento de las ciudades y territorio.', 'domain_knowledge'),
  ('Paisajismo', 'Diseño e integración de espacios verdes y elementos naturales.', 'domain_knowledge'),
  ('Topografía', 'Técnicas para medir y representar la forma y superficie del terreno.', 'domain_knowledge'),
  ('Análisis de Precios Unitarios (APU)', 'Cálculo detallado del costo de materiales, mano de obra y equipo.', 'domain_knowledge'),
  ('Supervisión de Obra', 'Vigilancia y control de calidad, tiempos y presupuesto durante la construcción.', 'domain_knowledge'),
  ('Reglamentos de Construcción', 'Conocimiento de la normativa y lineamientos legales vigentes.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'AutoCAD', 'Revit', 'ArchiCAD', 'Navisworks', 'Civil 3D',
  'Enscape', 'Twinmotion',
  'Neodata', 'Opus',
  'Building Information Modeling (BIM)', 'Dibujo Técnico / Planos', 'Diseño Estructural', 'Diseño Sustentable / LEED',
  'Urbanismo', 'Paisajismo', 'Topografía', 'Análisis de Precios Unitarios (APU)', 'Supervisión de Obra', 'Reglamentos de Construcción',
  -- Competencias transversales que ya fueron inyectadas en otras áreas:
  'SketchUp', '3ds Max', 'V-Ray', 'Lumion', 'Adobe Photoshop', 'Adobe Illustrator',
  'Gestión de Proyectos (PM)', 'Microsoft Excel'
)
and a.name = 'Arquitectura'
on conflict (competency_id, professional_area_id) do nothing;
