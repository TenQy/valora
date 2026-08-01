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
