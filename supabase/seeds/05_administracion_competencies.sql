insert into competencies (name, description, category) values
  -- Herramientas de ERP & Gestión
  ('SAP', 'Software ERP corporativo líder a nivel mundial.', 'tool'),
  ('Oracle ERP Cloud', 'Plataforma empresarial de Oracle para finanzas y operaciones.', 'tool'),
  ('Microsoft Dynamics 365', 'Suite de aplicaciones empresariales inteligentes (ERP y CRM).', 'tool'),
  ('Odoo', 'Software empresarial de código abierto (ERP, CRM, ventas).', 'tool'),
  ('NetSuite', 'Sistema ERP en la nube diseñado por Oracle.', 'tool'),

  -- Herramientas de RRHH & Nómina
  ('Workday', 'Plataforma en la nube para gestión financiera y capital humano.', 'tool'),
  ('BambooHR', 'Software de recursos humanos para pequeñas y medianas empresas.', 'tool'),
  ('Factorial', 'Software de gestión de recursos humanos y tiempo.', 'tool'),
  ('Buk', 'Software integral de recursos humanos muy popular en Latinoamérica.', 'tool'),
  ('Applicant Tracking Systems (ATS)', 'Sistemas para gestionar y automatizar el reclutamiento.', 'domain_knowledge'),

  -- Herramientas de Productividad
  ('Microsoft Excel', 'Manejo de hojas de cálculo, tablas dinámicas y macros.', 'tool'),
  ('Microsoft Word', 'Procesador de textos para documentos corporativos.', 'tool'),
  ('Microsoft PowerPoint', 'Herramienta de creación de presentaciones y reportes visuales.', 'tool'),
  ('Google Workspace', 'Uso del ecosistema de productividad de Google (Docs, Sheets, Drive).', 'tool'),
  ('Asana', 'Software de gestión del trabajo para organizar, seguir y gestionar proyectos.', 'tool'),
  ('Trello', 'Herramienta visual de gestión de proyectos basada en tableros Kanban.', 'tool'),
  ('Notion', 'Espacio de trabajo todo en uno para notas, tareas y bases de datos.', 'tool'),

  -- Conocimientos & Metodologías HR
  ('Reclutamiento y Selección', 'Estrategias y técnicas para atraer y contratar el mejor talento.', 'domain_knowledge'),
  ('Gestión de Talento', 'Procesos orientados a retener, desarrollar y motivar a los empleados.', 'domain_knowledge'),
  ('Evaluación de Desempeño', 'Sistemas para medir la eficacia y productividad del personal.', 'domain_knowledge'),
  ('Cultura Corporativa y Clima', 'Creación de un ambiente de trabajo positivo y alineado a los valores.', 'domain_knowledge'),
  ('Legislación Laboral', 'Conocimiento profundo de las leyes y normativas de trabajo (ej. LFT en México).', 'domain_knowledge'),
  ('Nómina y Compensaciones', 'Cálculo de sueldos, beneficios y deducciones legales.', 'domain_knowledge'),
  ('Capacitación y Onboarding', 'Desarrollo de planes de integración y formación continua.', 'domain_knowledge'),

  -- Operaciones y Logística
  ('Supply Chain Management (SCM)', 'Gestión y optimización de la cadena de suministro.', 'domain_knowledge'),
  ('Gestión de Inventarios', 'Control de entradas, salidas y existencias de productos físicos.', 'domain_knowledge'),
  ('Negociación con Proveedores', 'Habilidad para conseguir las mejores condiciones y precios.', 'domain_knowledge'),
  ('Lean Manufacturing / Lean Management', 'Metodología para minimizar desperdicios y maximizar valor.', 'domain_knowledge'),
  ('Six Sigma', 'Conjunto de técnicas y herramientas para la mejora de procesos.', 'domain_knowledge'),

  -- Gestión de Proyectos y General Administrativo
  ('Gestión de Proyectos (PM)', 'Planificación y control de recursos para lograr objetivos específicos.', 'domain_knowledge'),
  ('Metodología Agile', 'Enfoque de gestión iterativa, especialmente útil en entornos dinámicos.', 'domain_knowledge'),
  ('Liderazgo', 'Habilidad para guiar, motivar y gestionar equipos de trabajo.', 'domain_knowledge'),
  ('Resolución de Conflictos', 'Manejo adecuado de tensiones y disputas internas o externas.', 'domain_knowledge'),
  ('Atención al Cliente', 'Técnicas orientadas a satisfacer las necesidades de los usuarios.', 'domain_knowledge'),
  ('Planificación Estratégica', 'Definición de metas a largo plazo y estrategias para alcanzarlas.', 'domain_knowledge'),
  ('Gestión de Presupuestos', 'Creación y seguimiento de la distribución de recursos financieros.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'SAP', 'Oracle ERP Cloud', 'Microsoft Dynamics 365', 'Odoo', 'NetSuite',
  'Workday', 'BambooHR', 'Factorial', 'Buk', 'Applicant Tracking Systems (ATS)',
  'Microsoft Excel', 'Microsoft Word', 'Microsoft PowerPoint', 'Google Workspace', 'Asana', 'Trello', 'Notion',
  'Reclutamiento y Selección', 'Gestión de Talento', 'Evaluación de Desempeño', 'Cultura Corporativa y Clima', 'Legislación Laboral', 'Nómina y Compensaciones', 'Capacitación y Onboarding',
  'Supply Chain Management (SCM)', 'Gestión de Inventarios', 'Negociación con Proveedores', 'Lean Manufacturing / Lean Management', 'Six Sigma',
  'Gestión de Proyectos (PM)', 'Metodología Agile', 'Liderazgo', 'Resolución de Conflictos', 'Atención al Cliente', 'Planificación Estratégica', 'Gestión de Presupuestos'
)
and a.name = 'Administración'
on conflict (competency_id, professional_area_id) do nothing;
