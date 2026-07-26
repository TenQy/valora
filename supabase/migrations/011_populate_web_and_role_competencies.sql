-- Completar el vacío en Desarrollo Web, QA, Game Dev, IoT y SysAdmin
DO $$
DECLARE
  tech_area_id uuid;
  comp_record record;
BEGIN
  -- Obtener el ID del área de Tecnología
  SELECT id INTO tech_area_id FROM professional_areas WHERE name = 'Tecnología';

  -- Crear tabla temporal
  CREATE TEMP TABLE tmp_competencies (
    name text,
    description text,
    category text
  ) ON COMMIT DROP;

  -- Llenar la tabla temporal con Desarrollo Web puro y profesiones agregadas
  INSERT INTO tmp_competencies (name, description, category) VALUES
    -- DESARROLLO WEB (Core y Build Tools)
    ('HTML', 'Lenguaje de marcado estándar para documentos en el navegador web.', 'language'),
    ('CSS', 'Lenguaje de diseño gráfico para definir y crear la presentación de un documento estructurado.', 'language'),
    ('JavaScript', 'Lenguaje de programación interpretado, dialecto del estándar ECMAScript.', 'language'),
    ('Sass', 'Lenguaje de hoja de estilos en cascada preprocesado.', 'tool'),
    ('LESS', 'Preprocesador de CSS dinámico.', 'tool'),
    ('Webpack', 'Empaquetador de módulos estáticos para aplicaciones modernas de JavaScript.', 'tool'),
    ('Vite', 'Herramienta de compilación rápida para desarrollo web frontend moderno.', 'tool'),
    ('Rollup', 'Empaquetador de módulos para JavaScript que compila piezas pequeñas de código.', 'tool'),
    ('Babel', 'Compilador de JavaScript que permite usar código de próxima generación.', 'tool'),
    ('PWA', 'Progressive Web Apps: Aplicaciones web que se comportan como nativas.', 'domain_knowledge'),
    ('WebSockets', 'Tecnología avanzada que hace posible abrir una sesión interactiva entre navegador y servidor.', 'domain_knowledge'),
    ('WebGL', 'API de JavaScript para renderizar gráficos 3D y 2D interactivos.', 'domain_knowledge'),
    ('DOM', 'Modelo de Objetos del Documento, interfaz de programación para HTML y XML.', 'domain_knowledge'),
    
    -- QA Y TESTING
    ('Selenium', 'Entorno de pruebas de software para aplicaciones web.', 'tool'),
    ('Cypress', 'Herramienta de pruebas end-to-end de próxima generación para aplicaciones web.', 'tool'),
    ('Playwright', 'Framework de Node.js para automatización web multiplataforma (Microsoft).', 'tool'),
    ('Jest', 'Framework de pruebas de JavaScript con enfoque en la simplicidad (Facebook).', 'framework'),
    ('Mocha', 'Framework de pruebas de JavaScript rico en funciones que se ejecuta en Node.js.', 'framework'),
    ('JUnit', 'Framework para realizar pruebas unitarias en Java.', 'framework'),
    ('Appium', 'Herramienta de automatización de código abierto para aplicaciones móviles nativas.', 'tool'),
    ('Cucumber', 'Herramienta que apoya el Desarrollo Guiado por el Comportamiento (BDD).', 'tool'),
    
    -- DESARROLLO DE VIDEOJUEGOS
    ('Unity', 'Motor de videojuego multiplataforma por Unity Technologies.', 'tool'),
    ('Unreal Engine', 'Motor de juego desarrollado por Epic Games, conocido por sus gráficos.', 'tool'),
    ('Godot Engine', 'Motor de videojuegos 2D y 3D de código abierto bajo licencia MIT.', 'tool'),
    
    -- SYSADMIN / SERVIDORES
    ('Nginx', 'Servidor web, proxy inverso, proxy de correo y caché HTTP ligero.', 'tool'),
    ('Apache HTTP Server', 'Software de servidor web gratuito y de código abierto.', 'tool'),
    ('HAProxy', 'Software libre de alta disponibilidad y balanceador de carga.', 'tool'),
    ('PowerShell', 'Framework de automatización de tareas y gestión de configuración (Microsoft).', 'tool'),
    
    -- IoT / EMBEDDED
    ('C', 'Lenguaje de programación de propósito general, base para sistemas operativos y embebidos.', 'language'),
    ('Arduino', 'Plataforma de creación de electrónica de código abierto basada en hardware fácil de usar.', 'framework'),
    ('Raspberry Pi', 'Ordenador de placa reducida (SBC) de bajo coste.', 'tool'),
    ('MQTT', 'Protocolo de red ligero de mensajería máquina a máquina (IoT).', 'domain_knowledge'),
    ('FreeRTOS', 'Sistema operativo en tiempo real para microcontroladores.', 'framework'),
    
    -- BLOCKCHAIN / CRYPTO
    ('Ethereum', 'Plataforma de software descentralizada para contratos inteligentes.', 'domain_knowledge'),
    ('Bitcoin', 'Moneda digital descentralizada y su protocolo subyacente.', 'domain_knowledge'),
    ('Truffle', 'Entorno de desarrollo, marco de pruebas y conducto de activos para Ethereum.', 'tool'),
    ('Hardhat', 'Entorno de desarrollo para profesionales de Ethereum.', 'tool'),
    
    -- PRODUCT MANAGER TÉCNICO / SCRUM MASTER (Herramientas y Conceptos)
    ('Confluence', 'Software de colaboración de equipos corporativos (Atlassian).', 'tool'),
    ('Trello', 'Aplicación basada en web para la gestión de proyectos.', 'tool'),
    ('User Stories', 'Descripciones cortas de requisitos desde la perspectiva del usuario final.', 'domain_knowledge'),
    ('Sprint Planning', 'Evento ágil para definir el trabajo del próximo sprint.', 'domain_knowledge');

  -- Insertar competencias
  INSERT INTO competencies (name, description, category)
  SELECT name, description, category FROM tmp_competencies
  ON CONFLICT (name) DO NOTHING;

  -- Vincular a Tecnología
  FOR comp_record IN SELECT id FROM competencies WHERE name IN (SELECT name FROM tmp_competencies) LOOP
    INSERT INTO competency_areas (competency_id, professional_area_id)
    VALUES (comp_record.id, tech_area_id)
    ON CONFLICT (competency_id, professional_area_id) DO NOTHING;
  END LOOP;

END $$;
