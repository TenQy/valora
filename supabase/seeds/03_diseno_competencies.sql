insert into competencies (name, description, category) values
  -- Herramientas UX/UI
  ('Figma', 'Herramienta de diseño de interfaces y prototipos líder en la industria.', 'design_tool'),
  ('Sketch', 'Herramienta de diseño vectorial y de interfaces para macOS.', 'design_tool'),
  ('Adobe XD', 'Plataforma de diseño de experiencias de usuario de Adobe.', 'design_tool'),
  ('InVision', 'Plataforma de prototipado y flujo de trabajo de diseño digital.', 'design_tool'),
  ('Framer', 'Herramienta de prototipado interactivo y desarrollo web visual.', 'design_tool'),
  ('Webflow', 'Herramienta de diseño web visual y CMS.', 'design_tool'),
  
  -- Suite Adobe
  ('Adobe Photoshop', 'Software estándar para edición de imágenes y fotografía.', 'design_tool'),
  ('Adobe Illustrator', 'Herramienta principal de ilustración y diseño vectorial.', 'design_tool'),
  ('Adobe InDesign', 'Aplicación de composición digital de páginas y maquetación editorial.', 'design_tool'),
  ('Adobe Premiere Pro', 'Software de edición de video no lineal.', 'design_tool'),
  ('Adobe After Effects', 'Software de gráficos en movimiento y efectos visuales.', 'design_tool'),
  ('Adobe Lightroom', 'Editor de fotografías y gestor de imágenes.', 'design_tool'),
  
  -- Animación y 3D
  ('Blender', 'Software de código abierto para modelado, animación y renderizado 3D.', 'design_tool'),
  ('Cinema 4D', 'Software avanzado para modelado 3D, animación y motion graphics.', 'design_tool'),
  ('Autodesk Maya', 'Software de animación, modelado y simulación 3D.', 'design_tool'),
  ('ZBrush', 'Herramienta de escultura digital en 3D.', 'design_tool'),
  
  -- Diseño Industrial / Arquitectónico
  ('AutoCAD', 'Software de diseño asistido por computadora para dibujo 2D y 3D.', 'tool'),
  ('Rhinoceros 3D', 'Software de modelado 3D basado en NURBS.', 'design_tool'),
  ('SolidWorks', 'Software de diseño asistido por computadora para diseño mecánico.', 'tool'),
  
  -- Conceptos y Metodologías
  ('Diseño de Interfaz (UI)', 'Diseño visual de componentes, pantallas y layouts interactivos.', 'domain_knowledge'),
  ('Experiencia de Usuario (UX)', 'Prácticas para mejorar la interacción del usuario con productos digitales.', 'domain_knowledge'),
  ('Design Thinking', 'Metodología para la resolución práctica y creativa de problemas.', 'domain_knowledge'),
  ('Wireframing', 'Creación de esquemas y estructuras básicas de interfaces.', 'domain_knowledge'),
  ('Prototipado Interactivo', 'Creación de flujos de interacción demostrativos.', 'domain_knowledge'),
  ('Investigación de Usuarios (User Research)', 'Técnicas de análisis y descubrimiento de necesidades de usuarios.', 'domain_knowledge'),
  ('Pruebas de Usabilidad', 'Técnicas para evaluar interfaces observando usuarios reales.', 'domain_knowledge'),
  ('Arquitectura de la Información', 'Organización y estructuración lógica de contenido digital.', 'domain_knowledge'),
  ('Teoría del Color', 'Principios para el uso armonioso y psicológico del color.', 'domain_knowledge'),
  ('Tipografía', 'Arte y técnica de organizar letras y texto de forma legible y atractiva.', 'domain_knowledge'),
  ('Identidad Corporativa (Branding)', 'Construcción y diseño de los elementos visuales de una marca.', 'domain_knowledge'),
  ('Motion Graphics', 'Animación gráfica digital que crea ilusión de movimiento.', 'domain_knowledge'),
  ('Diseño Editorial', 'Maquetación y composición de publicaciones impresas/digitales.', 'domain_knowledge'),
  ('Sistemas de Diseño (Design Systems)', 'Creación de librerías de componentes y guías visuales escalables.', 'domain_knowledge'),
  
  -- Interiores y Arquitectura 3D
  ('SketchUp', 'Software de modelado 3D intuitivo muy usado en arquitectura e interiores.', 'design_tool'),
  ('Revit', 'Software BIM (Building Information Modeling) para arquitectura.', 'design_tool'),
  ('3ds Max', 'Herramienta de modelado, animación y renderizado 3D de Autodesk.', 'design_tool'),
  ('V-Ray', 'Motor de renderizado avanzado para visualización fotorrealista.', 'design_tool'),
  ('Lumion', 'Software de renderizado arquitectónico en tiempo real.', 'design_tool'),
  ('Ergonomía', 'Estudio de la adaptación de productos y espacios a las capacidades humanas.', 'domain_knowledge'),
  
  -- Industrial e Impresión 3D
  ('Fusion 360', 'Herramienta CAD, CAM y CAE en la nube de Autodesk.', 'design_tool'),
  ('KeyShot', 'Software de renderizado 3D y animación independiente.', 'design_tool'),
  ('Impresión 3D', 'Creación de objetos físicos mediante manufactura aditiva.', 'domain_knowledge'),
  
  -- Ilustración y Animación 2D
  ('Procreate', 'Aplicación líder de pintura digital e ilustración para iPad.', 'design_tool'),
  ('Clip Studio Paint', 'Software especializado en ilustración, cómic y animación 2D.', 'design_tool'),
  ('CorelDRAW', 'Software de diseño vectorial y maquetación gráfica.', 'design_tool'),
  ('Toon Boom Harmony', 'Estándar de la industria para animación 2D profesional.', 'design_tool'),
  ('Spine 2D', 'Herramienta de animación esquelética 2D para videojuegos.', 'design_tool'),
  ('Storyboarding', 'Organización gráfica y secuencial para planificar animaciones o videos.', 'domain_knowledge'),
  ('Rigging', 'Creación de esqueletos digitales para animar modelos 2D/3D.', 'domain_knowledge'),
  
  -- UX Research y UX Writing
  ('Hotjar', 'Herramienta de análisis de comportamiento de usuarios (mapas de calor).', 'tool'),
  ('Miro', 'Pizarra colaborativa digital usada en workshops e ideación.', 'tool'),
  ('Pruebas A/B', 'Metodología para comparar dos versiones de una interfaz o contenido.', 'domain_knowledge'),
  ('Card Sorting', 'Técnica de UX para diseñar o evaluar la arquitectura de información.', 'domain_knowledge'),
  ('Microcopy', 'Redacción de fragmentos cortos de texto en interfaces de usuario.', 'domain_knowledge'),
  ('Estrategia de Contenido (Content Strategy)', 'Planificación y gestión de contenido útil y relevante.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Figma', 'Sketch', 'Adobe XD', 'InVision', 'Framer', 'Webflow',
  'Adobe Photoshop', 'Adobe Illustrator', 'Adobe InDesign', 'Adobe Premiere Pro', 'Adobe After Effects', 'Adobe Lightroom',
  'Blender', 'Cinema 4D', 'Autodesk Maya', 'ZBrush',
  'AutoCAD', 'Rhinoceros 3D', 'SolidWorks',
  'Diseño de Interfaz (UI)', 'Experiencia de Usuario (UX)', 'Design Thinking', 'Wireframing', 'Prototipado Interactivo',
  'Investigación de Usuarios (User Research)', 'Pruebas de Usabilidad', 'Arquitectura de la Información',
  'Teoría del Color', 'Tipografía', 'Identidad Corporativa (Branding)', 'Motion Graphics', 'Diseño Editorial',
  'Sistemas de Diseño (Design Systems)', 'SketchUp', 'Revit', '3ds Max', 'V-Ray', 'Lumion', 'Ergonomía',
  'Fusion 360', 'KeyShot', 'Impresión 3D', 'Procreate', 'Clip Studio Paint', 'CorelDRAW', 'Toon Boom Harmony',
  'Spine 2D', 'Storyboarding', 'Rigging', 'Hotjar', 'Miro', 'Pruebas A/B', 'Card Sorting', 'Microcopy',
  'Estrategia de Contenido (Content Strategy)'
)
and a.name = 'Diseño'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Design Thinking',
  'Wireframing',
  'Prototipado Interactivo',
  'Pruebas de Usabilidad',
  'Arquitectura de la Información',
  'Teoría del Color',
  'Tipografía',
  'Sistemas de Diseño (Design Systems)',
  'Ergonomía',
  'Storyboarding',
  'Pruebas A/B',
  'Card Sorting',
  'Microcopy'
);
