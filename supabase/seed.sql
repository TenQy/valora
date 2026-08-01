
insert into languages (name) values
  ('Español'), ('Inglés'), ('Portugués'), ('Francés'), ('Alemán'), ('Italiano'),
  ('Chino Mandarín'), ('Japonés'), ('Ruso'), ('Coreano'), ('Árabe'), ('Hindi')
on conflict (name) do nothing;

insert into language_levels (name, description) values
  ('A1', 'Nivel inicial.'),
  ('A2', 'Nivel básico.'),
  ('B1', 'Nivel intermedio.'),
  ('B2', 'Nivel intermedio alto.'),
  ('C1', 'Nivel avanzado.'),
  ('C2', 'Nivel avanzado superior.'),
  ('Nativo', 'Dominio nativo del idioma.')
on conflict (name) do nothing;

insert into certification_issuers (name) values
  -- Tecnología y General
  ('Amazon Web Services'), ('Google'), ('Microsoft'), ('Meta'), ('Oracle'),
  ('Cisco'), ('IBM'), ('Apple'), ('Platzi'), ('Udemy'), ('Coursera'), ('edX'),
  ('LinkedIn Learning'), ('FreeCodeCamp'),
  -- Project Management y Agilidad
  ('Scrum.org'), ('Scrum Alliance'), ('Project Management Institute (PMI)'),
  -- Marketing
  ('HubSpot Academy'), ('Salesforce'), ('Digital Marketing Institute (DMI)'),
  -- Finanzas y Contabilidad
  ('CFA Institute'), ('CFP Board'), ('GARP'), ('CAIA Association'),
  -- Salud
  ('American Heart Association (AHA)'), ('AAPC'),
  -- Administración y RRHH
  ('SHRM'), ('HRCI'),
  -- Diseño y Arquitectura
  ('Autodesk'), ('Interaction Design Foundation (IxDF)'), ('NCARB'), ('USGBC'),
  -- Idiomas y Educación
  ('Cambridge Assessment English'), ('ETS (TOEFL, GRE)'), ('EF SET')
on conflict (name) do nothing;

insert into professional_areas (name, description) values
  ('Tecnología', 'Desarrollo de software, datos e infraestructura tecnológica.'),
  ('Diseño', 'Diseño visual, experiencia de usuario, industrial e identidad de marca.'),
  ('Marketing', 'Marketing digital, comunicación, posicionamiento y campañas.'),
  ('Administración', 'Gestión empresarial, operaciones y recursos humanos.'),
  ('Finanzas', 'Contabilidad, análisis financiero, inversiones y economía.'),
  ('Arquitectura', 'Diseño, urbanismo, modelado 3D y planeación de espacios.'),
  ('Ingenierías', 'Ingeniería civil, industrial, mecánica, mecatrónica, etc.'),
  ('Salud', 'Medicina, enfermería, psicología, nutrición y especialidades médicas.'),
  ('Educación', 'Pedagogía, docencia, capacitación e investigación educativa.'),
  ('Derecho', 'Asesoría legal, litigio, corporativo y notarial.')
on conflict (name) do nothing;

insert into competencies (name, description, category) values
  -- Lenguajes
  ('Python', 'Lenguaje de programación de propósito general, fuerte en datos e IA.', 'language'),
  ('JavaScript', 'Lenguaje principal de la web interactiva.', 'language'),
  ('TypeScript', 'Superset de JavaScript tipado.', 'language'),
  ('Java', 'Lenguaje orientado a objetos de propósito general y empresarial.', 'language'),
  ('C#', 'Lenguaje multiparadigma desarrollado por Microsoft.', 'language'),
  ('C++', 'Lenguaje de propósito general de alto rendimiento.', 'language'),
  ('C', 'Lenguaje de programación de sistemas.', 'language'),
  ('Ruby', 'Lenguaje dinámico y reflexivo enfocado en la simplicidad.', 'language'),
  ('PHP', 'Lenguaje de scripting enfocado al desarrollo web backend.', 'language'),
  ('Go (Golang)', 'Lenguaje compilado y concurrente creado por Google.', 'language'),
  ('Rust', 'Lenguaje enfocado en rendimiento y seguridad de memoria.', 'language'),
  ('Swift', 'Lenguaje de Apple para desarrollo en iOS y macOS.', 'language'),
  ('Kotlin', 'Lenguaje moderno e interoperable con Java, oficial para Android.', 'language'),
  ('Objective-C', 'Lenguaje clásico para desarrollo en ecosistemas Apple.', 'language'),
  ('Dart', 'Lenguaje optimizado para UI, usado por Flutter.', 'language'),
  ('Scala', 'Lenguaje que combina programación orientada a objetos y funcional.', 'language'),
  ('R', 'Lenguaje especializado en estadística y análisis de datos.', 'language'),
  ('Bash / Shell', 'Lenguaje de scripting para intérpretes de comandos en Unix/Linux.', 'language'),
  ('PowerShell', 'Framework de automatización de tareas y gestión de configuración multiplataforma.', 'language'),
  ('SQL', 'Lenguaje de consulta estructurada para BD relacionales.', 'language'),

  -- Frontend Web
  ('HTML5', 'Lenguaje de marcado estándar para la web.', 'language'),
  ('CSS3', 'Lenguaje de hojas de estilo para diseño web.', 'language'),
  ('React', 'Biblioteca para construir interfaces web.', 'framework'),
  ('Angular', 'Framework robusto de Google para aplicaciones web (SPA).', 'framework'),
  ('Vue.js', 'Framework progresivo de JavaScript para interfaces.', 'framework'),
  ('Svelte', 'Compilador que genera código JavaScript optimizado para interfaces.', 'framework'),
  ('Next.js', 'Framework de React para renderizado del lado del servidor (SSR).', 'framework'),
  ('Nuxt.js', 'Framework de Vue.js para SSR y aplicaciones universales.', 'framework'),
  ('Sass/SCSS', 'Preprocesador de CSS.', 'tool'),
  ('Tailwind CSS', 'Framework CSS basado en utilidades.', 'framework'),
  ('Bootstrap', 'Framework CSS y JS para interfaces responsivas.', 'framework'),
  ('Material-UI (MUI)', 'Biblioteca de componentes React basada en Material Design.', 'framework'),
  ('Webpack', 'Empaquetador de módulos estáticos para aplicaciones web.', 'tool'),
  ('Vite', 'Herramienta de construcción web ultra rápida.', 'tool'),

  -- Backend Web
  ('Node.js', 'Entorno de ejecución para JavaScript en el servidor.', 'framework'),
  ('Express.js', 'Framework web minimalista para Node.js.', 'framework'),
  ('NestJS', 'Framework progresivo de Node.js para backend escalable.', 'framework'),
  ('Spring Boot', 'Framework para crear aplicaciones robustas en Java.', 'framework'),
  ('.NET Core / ASP.NET', 'Framework de Microsoft para aplicaciones multiplataforma.', 'framework'),
  ('Django', 'Framework web de alto nivel para Python.', 'framework'),
  ('Flask', 'Micro-framework web para Python.', 'framework'),
  ('FastAPI', 'Framework moderno y rápido para construir APIs con Python.', 'framework'),
  ('Ruby on Rails', 'Framework full-stack para Ruby.', 'framework'),
  ('Laravel', 'Framework PHP elegante para artesanos web.', 'framework'),

  -- Móvil
  ('Flutter', 'Framework de Google para aplicaciones nativas multiplataforma.', 'framework'),
  ('React Native', 'Framework para crear apps móviles usando React.', 'framework'),
  ('Xamarin / .NET MAUI', 'Framework de Microsoft para desarrollo móvil multiplataforma.', 'framework'),
  ('Ionic', 'Framework para crear apps móviles híbridas con tecnologías web.', 'framework'),

  -- Bases de Datos
  ('PostgreSQL', 'Sistema de base de datos relacional open source muy potente.', 'database'),
  ('MySQL', 'Sistema de gestión de bases de datos relacional popular.', 'database'),
  ('MariaDB', 'Fork de base de datos relacional de código abierto de MySQL.', 'database'),
  ('SQL Server (MSSQL)', 'Sistema de bases de datos relacional de Microsoft.', 'database'),
  ('Oracle DB', 'Sistema de gestión de base de datos relacional empresarial.', 'database'),
  ('SQLite', 'Motor de base de datos relacional ligero e integrado.', 'database'),
  ('MongoDB', 'Base de datos NoSQL orientada a documentos.', 'database'),
  ('Firebase', 'Plataforma BaaS con bases de datos NoSQL en tiempo real.', 'database'),
  ('Redis', 'Almacén de estructura de datos en memoria (caché y NoSQL).', 'database'),
  ('Cassandra', 'Base de datos NoSQL distribuida de alta escalabilidad.', 'database'),
  ('DynamoDB', 'Base de datos NoSQL clave-valor y documentos administrada por AWS.', 'database'),
  ('Elasticsearch', 'Motor de búsqueda y análisis distribuido.', 'database'),

  -- ORM y Acceso a Datos
  ('Prisma', 'ORM moderno para Node.js y TypeScript.', 'tool'),
  ('TypeORM', 'ORM para TypeScript y JavaScript.', 'tool'),
  ('Entity Framework', 'ORM para plataformas .NET.', 'tool'),
  ('Hibernate', 'Framework ORM para Java.', 'tool'),
  ('SQLAlchemy', 'Kit de herramientas SQL y ORM para Python.', 'tool'),

  -- Infraestructura, Cloud y DevOps
  ('AWS', 'Amazon Web Services, plataforma líder de nube pública.', 'tool'),
  ('Microsoft Azure', 'Servicios de computación en la nube de Microsoft.', 'tool'),
  ('Google Cloud Platform (GCP)', 'Servicios en la nube de Google.', 'tool'),
  ('Docker', 'Plataforma para contenedores de software.', 'tool'),
  ('Kubernetes', 'Orquestación de contenedores a gran escala.', 'tool'),
  ('Terraform', 'Herramienta de infraestructura como código (IaC).', 'tool'),
  ('Ansible', 'Herramienta de automatización y configuración de software.', 'tool'),
  ('Jenkins', 'Servidor de automatización open source para CI/CD.', 'tool'),
  ('GitLab CI/CD', 'Herramienta integrada de integración y entrega continua.', 'tool'),
  ('GitHub Actions', 'Automatización de flujos de trabajo directamente en GitHub.', 'tool'),
  ('Prometheus', 'Sistema de monitorización de eventos y alertas.', 'tool'),
  ('Grafana', 'Plataforma de análisis y monitorización interactiva.', 'tool'),
  ('Linux', 'Sistema operativo de código abierto predominante en servidores.', 'domain_knowledge'),
  ('Nginx', 'Servidor web, proxy inverso y balanceador de carga.', 'tool'),

  -- Datos e Inteligencia Artificial
  ('Pandas', 'Biblioteca de análisis de datos para Python.', 'framework'),
  ('NumPy', 'Biblioteca para computación científica en Python.', 'framework'),
  ('Scikit-learn', 'Biblioteca de machine learning para Python.', 'framework'),
  ('TensorFlow', 'Plataforma de código abierto para machine learning.', 'framework'),
  ('PyTorch', 'Framework de machine learning de código abierto.', 'framework'),
  ('Apache Spark', 'Motor unificado de análisis para procesamiento de datos a gran escala.', 'framework'),
  ('Hadoop', 'Framework para procesamiento distribuido de grandes conjuntos de datos.', 'framework'),
  ('Kafka', 'Plataforma de streaming de eventos distribuidos.', 'tool'),
  ('Airflow', 'Plataforma para gestionar flujos de trabajo de datos.', 'tool'),
  ('Power BI', 'Servicio de análisis empresarial de Microsoft.', 'tool'),
  ('Tableau', 'Software de inteligencia de negocios y visualización de datos.', 'tool'),

  -- Seguridad y Redes
  ('Kali Linux', 'Distribución de Linux diseñada para forense digital y pruebas de penetración.', 'tool'),
  ('Wireshark', 'Analizador de protocolos de red.', 'tool'),
  ('Metasploit', 'Proyecto de seguridad informática para ejecutar exploits.', 'tool'),
  ('Burp Suite', 'Plataforma para pruebas de seguridad de aplicaciones web.', 'tool'),
  ('Nmap', 'Herramienta de escaneo de red y auditoría de seguridad.', 'tool'),
  ('OWASP', 'Estándares y metodologías de seguridad web.', 'domain_knowledge'),
  ('Criptografía', 'Técnicas de cifrado y seguridad de la información.', 'domain_knowledge'),

  -- Herramientas y Metodologías Varias
  ('Git', 'Sistema de control de versiones distribuido.', 'tool'),
  ('Jira', 'Herramienta de seguimiento de errores y gestión ágil.', 'tool'),
  ('Confluence', 'Software de colaboración para espacios de trabajo corporativos.', 'tool'),
  ('Metodologías Ágiles', 'Gestión de proyectos basada en iteraciones y colaboración.', 'domain_knowledge'),
  ('Scrum', 'Marco de trabajo ágil para desarrollo.', 'framework'),
  ('Kanban', 'Metodología visual para la gestión ágil del trabajo.', 'domain_knowledge'),
  ('Microservicios', 'Arquitectura de software modular distribuida.', 'domain_knowledge'),
  ('RESTful APIs', 'Estilo de arquitectura de red para sistemas distribuidos.', 'domain_knowledge'),
  ('GraphQL', 'Lenguaje de consulta para APIs.', 'language'),
  ('gRPC', 'Framework RPC de alto rendimiento de código abierto.', 'framework'),
  ('RabbitMQ', 'Intermediario de mensajes (Message Broker) open source.', 'tool'),

  -- Game Development
  ('Unity', 'Motor de videojuegos multiplataforma.', 'framework'),
  ('Unreal Engine', 'Motor de juego de alto rendimiento desarrollado por Epic Games.', 'framework'),
  ('Godot', 'Motor de videojuegos open source avanzado.', 'framework'),

  -- Blockchain & Web3
  ('Solidity', 'Lenguaje de programación para contratos inteligentes en Ethereum.', 'language'),
  ('Ethereum', 'Plataforma blockchain open source descentralizada.', 'domain_knowledge'),
  ('Web3.js', 'Biblioteca de JavaScript para interactuar con Ethereum.', 'framework'),
  ('Smart Contracts', 'Programas ejecutables que corren en una blockchain.', 'domain_knowledge'),

  -- Sistemas Embebidos & IoT
  ('Arduino', 'Plataforma de creación de electrónica de código abierto.', 'tool'),
  ('Raspberry Pi', 'Ordenadores de placa reducida de bajo costo.', 'platform'),
  ('RTOS', 'Sistemas operativos de tiempo real para sistemas embebidos.', 'domain_knowledge'),
  ('Microcontroladores', 'Sistemas de computación en un chip.', 'domain_knowledge'),

  -- QA & Testing
  ('Selenium', 'Entorno de pruebas de software para aplicaciones web.', 'tool'),
  ('Cypress', 'Herramienta de testing de frontend para web moderna.', 'tool'),
  ('Appium', 'Framework open source de automatización de pruebas para apps móviles.', 'tool'),
  ('Jest', 'Framework de pruebas de JavaScript.', 'framework'),
  ('JUnit', 'Framework para realizar pruebas unitarias en Java.', 'framework'),
  ('Postman', 'Plataforma para construir y probar APIs.', 'tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Python', 'JavaScript', 'TypeScript', 'Java', 'C#', 'C++', 'C', 'Ruby', 'PHP', 'Go (Golang)', 'Rust', 'Swift', 'Kotlin', 'Objective-C', 'Dart', 'Scala', 'R', 'Bash / Shell', 'PowerShell', 'SQL',
  'HTML5', 'CSS3', 'React', 'Angular', 'Vue.js', 'Svelte', 'Next.js', 'Nuxt.js', 'Sass/SCSS', 'Tailwind CSS', 'Bootstrap', 'Material-UI (MUI)', 'Webpack', 'Vite',
  'Node.js', 'Express.js', 'NestJS', 'Spring Boot', '.NET Core / ASP.NET', 'Django', 'Flask', 'FastAPI', 'Ruby on Rails', 'Laravel',
  'Flutter', 'React Native', 'Xamarin / .NET MAUI', 'Ionic',
  'PostgreSQL', 'MySQL', 'MariaDB', 'SQL Server (MSSQL)', 'Oracle DB', 'SQLite', 'MongoDB', 'Firebase', 'Redis', 'Cassandra', 'DynamoDB', 'Elasticsearch',
  'Prisma', 'TypeORM', 'Entity Framework', 'Hibernate', 'SQLAlchemy',
  'AWS', 'Microsoft Azure', 'Google Cloud Platform (GCP)', 'Docker', 'Kubernetes', 'Terraform', 'Ansible', 'Jenkins', 'GitLab CI/CD', 'GitHub Actions', 'Prometheus', 'Grafana', 'Linux', 'Nginx',
  'Pandas', 'NumPy', 'Scikit-learn', 'TensorFlow', 'PyTorch', 'Apache Spark', 'Hadoop', 'Kafka', 'Airflow', 'Power BI', 'Tableau',
  'Kali Linux', 'Wireshark', 'Metasploit', 'Burp Suite', 'Nmap', 'OWASP', 'Criptografía',
  'Git', 'Jira', 'Confluence', 'Metodologías Ágiles', 'Scrum', 'Kanban', 'Microservicios', 'RESTful APIs', 'GraphQL', 'gRPC', 'RabbitMQ',
  'Unity', 'Unreal Engine', 'Godot', 'Solidity', 'Ethereum', 'Web3.js', 'Smart Contracts', 'Arduino', 'Raspberry Pi', 'RTOS', 'Microcontroladores', 'Selenium', 'Cypress', 'Appium', 'Jest', 'JUnit', 'Postman'
)
and a.name = 'Tecnología'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Metodologías Ágiles',
  'Scrum',
  'Kanban',
  'OWASP',
  'Microservicios',
  'RESTful APIs',
  'Ethereum',
  'Smart Contracts',
  'RTOS',
  'Microcontroladores'
);

insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Tecnología'), 'Desarrollador Frontend', 'Construye interfaces web y aplicaciones cliente.', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Desarrollador Backend', 'Construye APIs, servicios y lógica de servidor.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Desarrollador Full Stack', 'Domina tanto el frontend como el backend de las aplicaciones.', 25000, 55000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Desarrollador Móvil', 'Crea aplicaciones nativas o multiplataforma para iOS y Android.', 22000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Arquitecto de Software', 'Diseña la estructura de alto nivel y los patrones de sistemas de software.', 45000, 80000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Arquitecto Cloud', 'Diseña y gestiona infraestructuras en plataformas en la nube (AWS, Azure, GCP).', 50000, 90000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Ingeniero DevOps', 'Automatiza despliegues, integración continua y administra infraestructura.', 30000, 65000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Site Reliability Engineer (SRE)', 'Garantiza la disponibilidad, latencia y rendimiento de servicios a gran escala.', 35000, 70000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Ingeniero de Datos (Data Engineer)', 'Diseña y mantiene arquitecturas de procesamiento y bases de datos grandes.', 30000, 60000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Científico de Datos (Data Scientist)', 'Analiza datos complejos y crea modelos predictivos.', 35000, 70000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Analista de Datos', 'Interpreta datos para generar reportes e insights de negocio.', 18000, 38000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Machine Learning Engineer', 'Desarrolla modelos de inteligencia artificial y los pone en producción.', 40000, 80000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Administrador de Bases de Datos (DBA)', 'Configura, mantiene y asegura el rendimiento de bases de datos.', 25000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Ingeniero de Ciberseguridad', 'Protege redes, sistemas y programas de ataques digitales.', 35000, 75000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Pentester / Ethical Hacker', 'Realiza pruebas de penetración para encontrar vulnerabilidades.', 30000, 70000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'QA Automation Engineer', 'Desarrolla scripts y frameworks para pruebas automáticas de software.', 22000, 48000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'QA Manual Tester', 'Realiza pruebas funcionales, exploratorias y de regresión manuales.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Administrador de Sistemas (SysAdmin)', 'Mantiene sistemas informáticos y redes de servidores operando correctamente.', 20000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Ingeniero de Redes', 'Diseña, implementa y mantiene redes de telecomunicaciones y datos.', 22000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Scrum Master', 'Facilita metodologías ágiles en equipos de desarrollo.', 25000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Product Manager (Técnico)', 'Lidera la estrategia y desarrollo de productos tecnológicos.', 35000, 75000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Tech Lead / Líder Técnico', 'Lidera técnicamente al equipo de desarrollo y toma decisiones de arquitectura.', 45000, 85000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Ingeniero de Sistemas Embebidos', 'Desarrolla software para hardware específico o dispositivos IoT.', 25000, 55000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Desarrollador de Videojuegos', 'Crea motores, mecánicas y lógicas para juegos interactivos.', 20000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Ingeniero Web3 / Blockchain', 'Desarrolla contratos inteligentes y aplicaciones descentralizadas (dApps).', 40000, 90000, 'MXN'),
  ((select id from professional_areas where name = 'Tecnología'), 'Especialista en Soporte TI', 'Resuelve incidencias técnicas de hardware y software a usuarios finales.', 12000, 25000, 'MXN')
on conflict (professional_area_id, name) do nothing;

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

insert into competencies (name, description, category) values
  -- Plataformas Publicitarias (Paid Media / SEM)
  ('Google Ads', 'Plataforma líder para publicidad en motores de búsqueda y red de display.', 'marketing_tool'),
  ('Meta Ads', 'Plataforma de publicidad pagada para Facebook, Instagram y WhatsApp.', 'marketing_tool'),
  ('LinkedIn Ads', 'Publicidad B2B orientada a profesionales y empresas.', 'marketing_tool'),
  ('TikTok Ads', 'Publicidad enfocada en formatos de video corto para audiencias jóvenes.', 'marketing_tool'),
  ('Programmatic Advertising', 'Compra automatizada de espacios publicitarios digitales.', 'domain_knowledge'),
  
  -- Analítica y Datos
  ('Google Analytics (GA4)', 'Herramienta esencial para medición de tráfico y comportamiento web.', 'marketing_tool'),
  ('Google Tag Manager (GTM)', 'Gestión e inyección de etiquetas de seguimiento en sitios web.', 'marketing_tool'),
  ('Looker Studio', 'Plataforma de visualización de datos y reportes (antes Google Data Studio).', 'marketing_tool'),
  ('Metricool', 'Herramienta de análisis, gestión y medición de redes sociales.', 'marketing_tool'),
  ('Adobe Analytics', 'Plataforma avanzada de análisis de datos para marketing empresarial.', 'marketing_tool'),
  ('Análisis de Datos en Marketing', 'Interpretación de KPIs para mejorar el retorno de inversión (ROI).', 'domain_knowledge'),

  -- SEO (Search Engine Optimization)
  ('SEO On-Page', 'Optimización técnica y de contenido dentro del propio sitio web.', 'domain_knowledge'),
  ('SEO Off-Page', 'Estrategias externas como link building para mejorar la autoridad del dominio.', 'domain_knowledge'),
  ('Keyword Research', 'Investigación de palabras clave para orientar la estrategia de contenido.', 'domain_knowledge'),
  ('SEMrush', 'Herramienta integral de análisis SEO, SEM y competitividad.', 'marketing_tool'),
  ('Ahrefs', 'Plataforma especializada en investigación de enlaces y análisis SEO.', 'marketing_tool'),
  ('Google Search Console', 'Herramienta para monitorear el estado de indexación de un sitio en Google.', 'marketing_tool'),

  -- Redes Sociales y Gestión de Comunidades
  ('Hootsuite', 'Plataforma de programación y gestión de redes sociales.', 'marketing_tool'),
  ('Sprout Social', 'Software integral de gestión y escucha social para marcas.', 'marketing_tool'),
  ('Estrategia de Redes Sociales', 'Planificación de contenido y crecimiento en plataformas sociales.', 'domain_knowledge'),
  ('Gestión de Comunidades', 'Interacción y construcción de relaciones con la audiencia digital.', 'domain_knowledge'),
  ('Gestión de Crisis', 'Manejo de reputación ante eventos negativos en medios digitales.', 'domain_knowledge'),

  -- CRM, Email & Inbound Marketing
  ('HubSpot', 'Plataforma integral de CRM y automatización de Inbound Marketing.', 'marketing_tool'),
  ('Salesforce', 'El CRM más utilizado a nivel global para gestión de ventas y marketing.', 'marketing_tool'),
  ('Mailchimp', 'Plataforma popular para envío masivo de correos y automatizaciones básicas.', 'marketing_tool'),
  ('Klaviyo', 'Herramienta avanzada de email y SMS marketing, muy usada en E-commerce.', 'marketing_tool'),
  ('ActiveCampaign', 'Software de automatización de email marketing y ventas.', 'marketing_tool'),
  ('Inbound Marketing', 'Metodología para atraer prospectos de forma no invasiva.', 'domain_knowledge'),
  ('Lead Nurturing', 'Proceso de cultivar relaciones con posibles clientes a través de un embudo.', 'domain_knowledge'),
  ('Automatización de Marketing', 'Uso de software para automatizar tareas repetitivas de marketing.', 'domain_knowledge'),

  -- E-commerce y Plataformas Web
  ('WordPress', 'Sistema de gestión de contenidos (CMS) predominante en la web.', 'marketing_tool'),
  ('Shopify', 'Plataforma líder para creación y gestión de tiendas en línea.', 'marketing_tool'),
  ('WooCommerce', 'Plugin de comercio electrónico de código abierto para WordPress.', 'marketing_tool'),
  ('Optimización de Tasa de Conversión (CRO)', 'Prácticas para aumentar el porcentaje de visitantes que compran o convierten.', 'domain_knowledge'),

  -- Contenido y Redacción
  ('Redacción Publicitaria (Copywriting)', 'Escritura persuasiva con el objetivo de generar ventas o conversiones.', 'domain_knowledge'),
  ('Storytelling', 'Técnica de comunicación narrativa para conectar con la audiencia.', 'domain_knowledge'),
  ('Estrategia de Contenido', 'Planificación del desarrollo y distribución de contenido valioso.', 'domain_knowledge'),
  ('Edición de Video (CapCut / Reels)', 'Habilidad básica para crear contenido nativo y dinámico para redes.', 'domain_knowledge'),

  -- Conceptos Estratégicos
  ('Growth Hacking', 'Estrategias creativas y analíticas para escalar rápidamente un negocio.', 'domain_knowledge'),
  ('Marketing de Afiliados', 'Promoción de productos de terceros a cambio de una comisión.', 'domain_knowledge'),
  ('Relaciones Públicas (PR)', 'Gestión de la comunicación estratégica entre una organización y el público.', 'domain_knowledge'),
  ('Posicionamiento de Marca (Branding)', 'Estrategia para ubicar una marca en la mente de los consumidores.', 'domain_knowledge'),
  ('Análisis de Competencia', 'Monitoreo de tácticas y resultados de empresas rivales.', 'domain_knowledge'),
  ('Marketing de Influencers', 'Colaboraciones comerciales con creadores de contenido.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Google Ads', 'Meta Ads', 'LinkedIn Ads', 'TikTok Ads', 'Programmatic Advertising',
  'Google Analytics (GA4)', 'Google Tag Manager (GTM)', 'Looker Studio', 'Metricool', 'Adobe Analytics', 'Análisis de Datos en Marketing',
  'SEO On-Page', 'SEO Off-Page', 'Keyword Research', 'SEMrush', 'Ahrefs', 'Google Search Console',
  'Hootsuite', 'Sprout Social', 'Estrategia de Redes Sociales', 'Gestión de Comunidades', 'Gestión de Crisis',
  'HubSpot', 'Salesforce', 'Mailchimp', 'Klaviyo', 'ActiveCampaign', 'Inbound Marketing', 'Lead Nurturing', 'Automatización de Marketing',
  'WordPress', 'Shopify', 'WooCommerce', 'Optimización de Tasa de Conversión (CRO)',
  'Redacción Publicitaria (Copywriting)', 'Storytelling', 'Estrategia de Contenido', 'Edición de Video (CapCut / Reels)',
  'Growth Hacking', 'Marketing de Afiliados', 'Relaciones Públicas (PR)', 'Posicionamiento de Marca (Branding)', 'Análisis de Competencia', 'Marketing de Influencers'
)
and a.name = 'Marketing'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Programmatic Advertising',
  'Estrategia de Redes Sociales',
  'Gestión de Comunidades',
  'Gestión de Crisis',
  'Inbound Marketing',
  'Lead Nurturing',
  'Automatización de Marketing',
  'Optimización de Tasa de Conversión (CRO)',
  'Storytelling',
  'Estrategia de Contenido',
  'Growth Hacking',
  'Marketing de Afiliados',
  'Relaciones Públicas (PR)',
  'Posicionamiento de Marca (Branding)',
  'Análisis de Competencia',
  'Marketing de Influencers'
);

insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Marketing'), 'Especialista en Marketing Digital', 'Diseña y ejecuta campañas estratégicas en múltiples canales digitales.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Social Media Manager', 'Desarrolla la estrategia de redes sociales y gestiona la imagen de la marca.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Community Manager', 'Gestiona las interacciones con la comunidad en redes sociales.', 10000, 20000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Especialista SEO', 'Optimiza de forma orgánica contenido y sitios web para motores de búsqueda.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Especialista SEM / Paid Media', 'Gestiona campañas de publicidad pagada y presupuestos (Google Ads, Meta Ads).', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Content Manager / Creador de Contenido', 'Planifica, crea y gestiona contenidos de valor para la audiencia.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Copywriter', 'Redacta textos persuasivos orientados a la conversión y ventas.', 12000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Analista de Marketing', 'Analiza datos de campañas y mercado para extraer insights de negocio.', 18000, 38000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Growth Hacker', 'Utiliza datos y experimentación ágil para lograr crecimiento acelerado.', 25000, 60000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Email Marketing Specialist', 'Crea y gestiona campañas y automatizaciones por correo electrónico.', 15000, 28000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Especialista en Inbound Marketing', 'Diseña estrategias para atraer clientes de forma no intrusiva.', 18000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Director de Marketing (CMO)', 'Lidera la estrategia global de marketing y el posicionamiento de la empresa.', 50000, 120000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Brand Manager', 'Asegura la coherencia, reputación y posicionamiento de una marca.', 25000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Product Marketing Manager (PMM)', 'Conecta el desarrollo del producto con las necesidades del mercado y ventas.', 30000, 65000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Especialista en Relaciones Públicas (PR)', 'Gestiona la comunicación y la imagen pública frente a medios y eventos.', 15000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Especialista en E-commerce', 'Optimiza tiendas en línea, catálogos y estrategias de conversión (CRO).', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Gestor de Campañas (Campaign Manager)', 'Planifica, ejecuta y monitorea campañas integrales de principio a fin.', 20000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Marketing'), 'Especialista en Influencer Marketing', 'Negocia y gestiona campañas con creadores de contenido e influencers.', 15000, 30000, 'MXN')
on conflict (professional_area_id, name) do nothing;

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

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Applicant Tracking Systems (ATS)',
  'Evaluación de Desempeño',
  'Cultura Corporativa y Clima',
  'Legislación Laboral',
  'Capacitación y Onboarding',
  'Lean Manufacturing / Lean Management',
  'Six Sigma',
  'Planificación Estratégica'
);

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

insert into competencies (name, description, category) values
  -- Software Contable y Financiero
  ('QuickBooks', 'Software de contabilidad diseñado para pequeñas y medianas empresas.', 'tool'),
  ('Xero', 'Software de contabilidad en la nube popular para pymes.', 'tool'),
  ('SAP FI/CO', 'Módulo de SAP para gestión contable y controlling.', 'tool'),
  ('Aspel COI / NOI', 'Sistemas de contabilidad y nómina muy utilizados en México y LATAM.', 'tool'),
  ('Contpaqi', 'Software contable y administrativo estándar en México.', 'tool'),
  ('Sage', 'Software de gestión empresarial y contable.', 'tool'),

  -- Terminales y Herramientas Especializadas
  ('Bloomberg Terminal', 'Sistema de software para acceder a datos y análisis financieros en tiempo real.', 'tool'),
  ('Reuters Eikon', 'Plataforma de información financiera para profesionales.', 'tool'),

  -- Normativas e Impuestos
  ('NIIF / IFRS', 'Normas Internacionales de Información Financiera.', 'domain_knowledge'),
  ('US GAAP', 'Principios de contabilidad generalmente aceptados en los Estados Unidos.', 'domain_knowledge'),
  ('Legislación Fiscal', 'Conocimiento de leyes tributarias e impuestos (ISR, IVA, etc.).', 'domain_knowledge'),
  ('Declaraciones de Impuestos', 'Proceso de calcular y presentar obligaciones tributarias al gobierno.', 'domain_knowledge'),

  -- Conceptos y Metodologías Financieras
  ('Contabilidad General', 'Registro y análisis sistemático de las transacciones financieras.', 'domain_knowledge'),
  ('Cuentas por Cobrar (AR)', 'Gestión del dinero adeudado a la empresa por sus clientes.', 'domain_knowledge'),
  ('Cuentas por Pagar (AP)', 'Gestión de las obligaciones de pago de la empresa a sus proveedores.', 'domain_knowledge'),
  ('Conciliación Bancaria', 'Proceso de cuadrar los registros contables con los estados bancarios.', 'domain_knowledge'),
  ('Análisis de Estados Financieros', 'Evaluación del balance general, estado de resultados y flujo de caja.', 'domain_knowledge'),
  ('Presupuesto y Pronóstico (Forecasting)', 'Planificación financiera y estimación de ingresos/gastos futuros.', 'domain_knowledge'),
  ('Modelado Financiero (Financial Modeling)', 'Construcción de representaciones matemáticas del desempeño financiero.', 'domain_knowledge'),
  ('Gestión de Riesgos (Risk Management)', 'Identificación y mitigación de amenazas a la salud financiera de la empresa.', 'domain_knowledge'),
  ('Auditoría', 'Revisión sistemática e independiente de los registros contables y operativos.', 'domain_knowledge'),
  ('Evaluación de Proyectos de Inversión', 'Cálculo de viabilidad de inversiones (TIR, VAN / NPV, Payback).', 'domain_knowledge'),
  ('Gestión de Flujo de Efectivo', 'Monitoreo y optimización de las entradas y salidas de dinero.', 'domain_knowledge'),
  ('Tesorería', 'Administración de la liquidez, fondos e inversiones a corto plazo de una empresa.', 'domain_knowledge'),
  ('Contabilidad de Costos', 'Análisis de los costos de producción y rentabilidad de productos/servicios.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'QuickBooks', 'Xero', 'SAP FI/CO', 'Aspel COI / NOI', 'Contpaqi', 'Sage',
  'Bloomberg Terminal', 'Reuters Eikon',
  'NIIF / IFRS', 'US GAAP', 'Legislación Fiscal', 'Declaraciones de Impuestos',
  'Contabilidad General', 'Cuentas por Cobrar (AR)', 'Cuentas por Pagar (AP)', 'Conciliación Bancaria',
  'Análisis de Estados Financieros', 'Presupuesto y Pronóstico (Forecasting)', 'Modelado Financiero (Financial Modeling)',
  'Gestión de Riesgos (Risk Management)', 'Auditoría', 'Evaluación de Proyectos de Inversión',
  'Gestión de Flujo de Efectivo', 'Tesorería', 'Contabilidad de Costos',
  'Microsoft Excel', 'SAP', 'Oracle ERP Cloud', 'Power BI', 'Tableau'
)
and a.name = 'Finanzas'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'NIIF / IFRS',
  'US GAAP',
  'Legislación Fiscal',
  'Declaraciones de Impuestos',
  'Cuentas por Cobrar (AR)',
  'Cuentas por Pagar (AP)',
  'Conciliación Bancaria'
);

insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Finanzas'), 'Analista Financiero', 'Analiza datos financieros, proyecciones y viabilidad de proyectos.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Contador', 'Maneja el registro contable, pólizas y estados financieros.', 12000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Especialista en Impuestos (Fiscalista)', 'Gestión, planeación y cumplimiento de obligaciones fiscales y tributarias.', 18000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Auditor', 'Revisa y evalúa la exactitud de los registros contables y el cumplimiento de normativas.', 20000, 45000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Tesorero / Gerente de Tesorería', 'Administra el flujo de efectivo, liquidez e inversiones a corto plazo.', 25000, 55000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Contralor (Controller)', 'Supervisa la contabilidad general, auditorías internas y control financiero.', 35000, 70000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Director Financiero (CFO)', 'Máximo responsable de la estrategia financiera, riesgo y estructura de capital.', 60000, 150000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Especialista en Cuentas por Pagar (AP)', 'Gestiona los pagos a proveedores y obligaciones a corto plazo.', 12000, 22000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Especialista en Cuentas por Cobrar (AR)', 'Gestiona la cobranza, facturación y crédito a clientes.', 12000, 22000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Analista de Riesgos', 'Evalúa y mitiga riesgos financieros, operativos y de crédito.', 25000, 50000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Analista de Crédito', 'Evalúa la solvencia de solicitantes de crédito o financiamiento.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Gestor de Patrimonios (Wealth Manager)', 'Asesora sobre inversiones y gestión de capital para clientes o instituciones.', 30000, 80000, 'MXN'),
  ((select id from professional_areas where name = 'Finanzas'), 'Analista de Inversiones', 'Investiga mercados y activos para fundamentar decisiones de inversión.', 22000, 50000, 'MXN')
on conflict (professional_area_id, name) do nothing;

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

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Building Information Modeling (BIM)',
  'Diseño Sustentable / LEED',
  'Reglamentos de Construcción'
);

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

insert into competencies (name, description, category) values
  -- Herramientas y Sistemas Clínicos
  ('Expediente Clínico Electrónico (ECE)', 'Software para la gestión de historiales médicos digitales de los pacientes.', 'tool'),
  ('PACS (Picture Archiving)', 'Sistemas de almacenamiento y comunicación de imágenes médicas (Rayos X, RM).', 'tool'),

  -- Soporte Vital y Urgencias
  ('Soporte Vital Básico (BLS)', 'Maniobras iniciales de atención de emergencias cardiopulmonares.', 'domain_knowledge'),
  ('Soporte Vital Cardiovascular Avanzado (ACLS)', 'Protocolos avanzados para emergencias cardiovasculares y paro cardíaco.', 'domain_knowledge'),
  ('Primeros Auxilios', 'Atención inmediata y temporal a víctimas de accidentes o enfermedades repentinas.', 'domain_knowledge'),
  ('Reanimación Cardiopulmonar (RCP)', 'Técnicas manuales para mantener la oxigenación en emergencias.', 'domain_knowledge'),
  
  -- Procedimientos Clínicos Generales
  ('Suturas y Cuidado de Heridas', 'Técnicas de cierre y manejo de heridas quirúrgicas o traumáticas.', 'domain_knowledge'),
  ('Venopunción / Extracción de Sangre', 'Procedimientos seguros para la recolección de muestras sanguíneas.', 'domain_knowledge'),
  ('Inmunización / Vacunación', 'Manejo de red de frío y administración segura de vacunas.', 'domain_knowledge'),
  ('Control de Infecciones / Bioseguridad', 'Protocolos para prevenir infecciones intrahospitalarias (nosocomiales).', 'domain_knowledge'),
  
  -- Diagnóstico
  ('Interpretación de Análisis Clínicos', 'Lectura diagnóstica de estudios de laboratorio (hematología, química sanguínea, etc.).', 'domain_knowledge'),
  ('Interpretación de Imagenología', 'Lectura básica de estudios radiológicos, ultrasonidos y tomografías.', 'domain_knowledge'),
  ('Electrocardiografía (ECG)', 'Toma e interpretación de la actividad eléctrica del corazón.', 'domain_knowledge'),

  -- Conocimientos por Especialidad
  ('Farmacología', 'Conocimiento de interacciones, mecanismos y dosis de medicamentos.', 'domain_knowledge'),
  ('Anatomía y Fisiología', 'Conocimiento profundo de la estructura y funcionamiento del cuerpo humano.', 'domain_knowledge'),
  ('Terapia Cognitivo-Conductual (TCC)', 'Enfoque psicoterapéutico basado en la modificación de pensamientos y conductas.', 'domain_knowledge'),
  ('Evaluación Nutricional', 'Cálculo de requerimientos calóricos y diseño de planes dietéticos.', 'domain_knowledge'),
  ('Kinesioterapia / Rehabilitación Física', 'Tratamiento de dolencias mediante el movimiento y terapia manual.', 'domain_knowledge'),
  ('Odontología Preventiva y Restaurativa', 'Prevención de caries, limpieza dental, resinas y tratamientos bucales básicos.', 'domain_knowledge'),
  
  -- Gestión y Normativa
  ('Normativas de Salud', 'Conocimiento de la legislación sanitaria (Ej. NOMs en México, HIPAA en EE.UU.).', 'domain_knowledge'),
  ('Ética Médica y Bioética', 'Principios éticos aplicados al trato del paciente y experimentación médica.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Expediente Clínico Electrónico (ECE)', 'PACS (Picture Archiving)',
  'Soporte Vital Básico (BLS)', 'Soporte Vital Cardiovascular Avanzado (ACLS)', 'Primeros Auxilios', 'Reanimación Cardiopulmonar (RCP)',
  'Suturas y Cuidado de Heridas', 'Venopunción / Extracción de Sangre', 'Inmunización / Vacunación', 'Control de Infecciones / Bioseguridad',
  'Interpretación de Análisis Clínicos', 'Interpretación de Imagenología', 'Electrocardiografía (ECG)',
  'Farmacología', 'Anatomía y Fisiología', 'Terapia Cognitivo-Conductual (TCC)', 'Evaluación Nutricional',
  'Kinesioterapia / Rehabilitación Física', 'Odontología Preventiva y Restaurativa',
  'Normativas de Salud', 'Ética Médica y Bioética'
)
and a.name = 'Salud'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Soporte Vital Básico (BLS)',
  'Soporte Vital Cardiovascular Avanzado (ACLS)',
  'Primeros Auxilios',
  'Reanimación Cardiopulmonar (RCP)',
  'Inmunización / Vacunación',
  'Control de Infecciones / Bioseguridad',
  'Anatomía y Fisiología',
  'Normativas de Salud',
  'Ética Médica y Bioética'
);

insert into job_roles (professional_area_id, name, description, min_salary, max_salary, currency) values
  ((select id from professional_areas where name = 'Salud'), 'Médico General', 'Atención médica primaria, diagnóstico y prevención de enfermedades.', 18000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Médico Especialista', 'Atención médica de alta especialidad (Pediatría, Cirugía, Cardiología, etc.).', 30000, 80000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Enfermero(a)', 'Atención directa y cuidado integral de pacientes en hospitales y clínicas.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Enfermero(a) Especialista', 'Atención especializada (quirúrgica, cuidados intensivos, pediatría).', 18000, 35000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Odontólogo / Dentista', 'Diagnóstico y tratamiento de la salud bucodental.', 15000, 40000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Psicólogo Clínico', 'Evaluación, diagnóstico y tratamiento de la salud mental y emocional.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Nutriólogo / Dietista', 'Evaluación y diseño de planes de alimentación para la salud y prevención.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Fisioterapeuta / Kinesiólogo', 'Rehabilitación física y tratamiento de lesiones musculoesqueléticas.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Paramédico / TUM', 'Técnico en Urgencias Médicas. Atención prehospitalaria y soporte vital.', 10000, 20000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Químico Farmacobiólogo (QFB)', 'Análisis clínicos, microbiológicos y de laboratorio para diagnóstico.', 12000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Farmacéutico', 'Gestión, control y dispensación técnica de medicamentos.', 15000, 30000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Optometrista', 'Cuidado primario de la salud visual, refracción y adaptación de lentes.', 10000, 25000, 'MXN'),
  ((select id from professional_areas where name = 'Salud'), 'Médico Veterinario (MVZ)', 'Prevención, diagnóstico y tratamiento de enfermedades en animales.', 12000, 30000, 'MXN')
on conflict (professional_area_id, name) do nothing;

insert into competencies (name, description, category) values
  -- Sistemas de Gestión del Aprendizaje (LMS)
  ('Moodle', 'Plataforma de aprendizaje (LMS) de código abierto.', 'tool'),
  ('Canvas LMS', 'Sistema de gestión de aprendizaje líder en educación superior.', 'tool'),
  ('Blackboard', 'Entorno de aprendizaje virtual y sistema de gestión de cursos.', 'tool'),
  ('Google Classroom', 'Plataforma educativa gratuita para escuelas y profesores.', 'tool'),
  ('Microsoft Teams para Educación', 'Espacio de colaboración digital para aulas.', 'tool'),

  -- Herramientas de Creación de Contenido e Interacción
  ('Articulate Storyline', 'Software para la creación de cursos e-learning interactivos.', 'tool'),
  ('Adobe Captivate', 'Herramienta de autoría rápida para e-learning.', 'tool'),
  ('Kahoot!', 'Plataforma de aprendizaje basada en juegos y cuestionarios interactivos.', 'tool'),
  ('Genially', 'Herramienta en línea para crear presentaciones y contenidos interactivos.', 'tool'),
  ('Zoom', 'Plataforma de videoconferencias, vital para educación a distancia.', 'tool'),

  -- Conceptos y Metodologías
  ('Pedagogía General', 'Ciencia y arte de la educación y enseñanza de los niños.', 'domain_knowledge'),
  ('Didáctica', 'Técnicas y métodos de enseñanza para facilitar el aprendizaje.', 'domain_knowledge'),
  ('Diseño Instruccional', 'Planificación y creación estructurada de experiencias de aprendizaje.', 'domain_knowledge'),
  ('Aprendizaje Basado en Proyectos (ABP)', 'Metodología donde los estudiantes aprenden resolviendo problemas reales.', 'domain_knowledge'),
  ('Flipped Classroom (Aula Invertida)', 'Modelo pedagógico que invierte los métodos tradicionales de enseñanza.', 'domain_knowledge'),
  ('Gamificación Educativa', 'Uso de mecánicas de juego en entornos educativos para mejorar el compromiso.', 'domain_knowledge'),
  ('Evaluación del Aprendizaje', 'Diseño de instrumentos para medir los conocimientos adquiridos.', 'domain_knowledge'),
  ('Inclusión Educativa', 'Atención a la diversidad y necesidades educativas especiales (NEE).', 'domain_knowledge'),
  ('Diseño de Currículo', 'Planificación de los contenidos, objetivos y criterios de evaluación educativos.', 'domain_knowledge'),
  ('E-learning / Educación a Distancia', 'Modalidad de enseñanza y aprendizaje a través de medios digitales.', 'domain_knowledge')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Moodle', 'Canvas LMS', 'Blackboard', 'Google Classroom', 'Microsoft Teams para Educación',
  'Articulate Storyline', 'Adobe Captivate', 'Kahoot!', 'Genially', 'Zoom',
  'Pedagogía General', 'Didáctica', 'Diseño Instruccional', 'Aprendizaje Basado en Proyectos (ABP)',
  'Flipped Classroom (Aula Invertida)', 'Gamificación Educativa', 'Evaluación del Aprendizaje',
  'Inclusión Educativa', 'Diseño de Currículo', 'E-learning / Educación a Distancia',
  -- Competencias transversales
  'Microsoft Word', 'Microsoft Excel', 'Microsoft PowerPoint', 'Google Workspace'
)
and a.name = 'Educación'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Pedagogía General',
  'Didáctica',
  'Diseño Instruccional',
  'Aprendizaje Basado en Proyectos (ABP)',
  'Flipped Classroom (Aula Invertida)',
  'Gamificación Educativa',
  'Evaluación del Aprendizaje',
  'Inclusión Educativa',
  'Diseño de Currículo',
  'E-learning / Educación a Distancia'
);

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

insert into competencies (name, description, category) values
  -- Ramas del Derecho (Conceptos y Dominio)
  ('Derecho Civil', 'Regulación de las relaciones privadas entre personas (contratos, propiedad).', 'domain_knowledge'),
  ('Derecho Penal', 'Normas que regulan las conductas punibles y las penas impuestas por el Estado.', 'domain_knowledge'),
  ('Derecho Corporativo / Mercantil', 'Leyes relacionadas con la actividad empresarial y comercial.', 'domain_knowledge'),
  ('Derecho Laboral', 'Regulación de las relaciones entre empleadores y trabajadores.', 'domain_knowledge'),
  ('Derecho Familiar', 'Normas referentes a las relaciones de familia (divorcios, custodia).', 'domain_knowledge'),
  ('Derecho Fiscal', 'Estudio y aplicación de las leyes tributarias y obligaciones fiscales.', 'domain_knowledge'),
  ('Derecho Constitucional', 'Análisis de la Constitución y protección de los derechos fundamentales.', 'domain_knowledge'),
  ('Derecho Internacional', 'Regulación de las relaciones entre Estados y organizaciones internacionales.', 'domain_knowledge'),

  -- Competencias Técnicas y Procesales
  ('Litigio', 'Estrategia y representación activa en juicios ante tribunales.', 'domain_knowledge'),
  ('Redacción de Contratos', 'Elaboración técnica de documentos legales vinculantes.', 'domain_knowledge'),
  ('Negociación Legal', 'Técnicas para alcanzar acuerdos favorables y evitar procedimientos judiciales.', 'domain_knowledge'),
  ('Juicio de Amparo', 'Procedimiento legal para la defensa de los derechos humanos y garantías constitucionales.', 'domain_knowledge'),
  ('Investigación Jurídica', 'Búsqueda e interpretación profunda de leyes, jurisprudencia y doctrina.', 'domain_knowledge'),
  ('Argumentación Jurídica', 'Habilidad para razonar y presentar argumentos persuasivos ante un tribunal.', 'domain_knowledge'),
  ('Cumplimiento Normativo (Compliance)', 'Implementación de controles para asegurar que una empresa cumpla la ley.', 'domain_knowledge'),
  ('Propiedad Intelectual', 'Protección legal de marcas, patentes y derechos de autor.', 'domain_knowledge'),

  -- LegalTech y Bases de Datos
  ('vLex / Tirant lo Blanch', 'Uso de plataformas digitales avanzadas de bases de datos de jurisprudencia.', 'tool'),
  ('Sistemas de Gestión de Expedientes (Lex-Doctor, Clio, etc.)', 'Software especializado para la administración de firmas de abogados.', 'tool')
on conflict (name) do nothing;

insert into competency_areas (competency_id, professional_area_id)
select c.id, a.id
from competencies c, professional_areas a
where c.name in (
  'Derecho Civil', 'Derecho Penal', 'Derecho Corporativo / Mercantil', 'Derecho Laboral',
  'Derecho Familiar', 'Derecho Fiscal', 'Derecho Constitucional', 'Derecho Internacional',
  'Litigio', 'Redacción de Contratos', 'Negociación Legal', 'Juicio de Amparo',
  'Investigación Jurídica', 'Argumentación Jurídica', 'Cumplimiento Normativo (Compliance)', 'Propiedad Intelectual',
  'vLex / Tirant lo Blanch', 'Sistemas de Gestión de Expedientes (Lex-Doctor, Clio, etc.)',
  -- Competencias transversales de ofimática
  'Microsoft Word', 'Microsoft Excel', 'Google Workspace'
)
and a.name = 'Derecho'
on conflict (competency_id, professional_area_id) do nothing;

-- Marcar competencias como binarias (no requieren nivel)
update competencies
set requires_level = false
where name in (
  'Derecho Civil',
  'Derecho Penal',
  'Derecho Corporativo / Mercantil',
  'Derecho Laboral',
  'Derecho Familiar',
  'Derecho Fiscal',
  'Derecho Constitucional',
  'Derecho Internacional',
  'Juicio de Amparo',
  'Cumplimiento Normativo (Compliance)',
  'Propiedad Intelectual'
);

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

