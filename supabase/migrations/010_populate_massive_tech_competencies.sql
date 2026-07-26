-- Poblar absolutamente todas las competencias de tecnología posibles
-- Usamos un bloque anónimo para facilitar la inserción masiva y su vinculación

DO $$
DECLARE
  tech_area_id uuid;
  comp_record record;
BEGIN
  -- Obtener el ID del área de Tecnología
  SELECT id INTO tech_area_id FROM professional_areas WHERE name = 'Tecnología';

  -- Crear tabla temporal para insertar datos rápidamente
  CREATE TEMP TABLE tmp_competencies (
    name text,
    description text,
    category text
  ) ON COMMIT DROP;

  -- Llenar la tabla temporal con TODA la base de conocimiento tecnológica
  INSERT INTO tmp_competencies (name, description, category) VALUES
    -- LENGUAJES
    ('Objective-C', 'Lenguaje principal clásico para desarrollo en macOS e iOS.', 'language'),
    ('Lua', 'Lenguaje de script ligero usado en embebidos y videojuegos.', 'language'),
    ('R', 'Lenguaje y entorno para computación estadística y gráficos.', 'language'),
    ('MATLAB', 'Plataforma de cálculo numérico para ingenieros y científicos.', 'language'),
    ('Julia', 'Lenguaje de alto nivel para computación técnica de alto rendimiento.', 'language'),
    ('Shell Script', 'Scripting de línea de comandos (Bash, Zsh).', 'language'),
    ('F#', 'Lenguaje funcional enfocado en la plataforma .NET.', 'language'),
    ('Clojure', 'Dialecto moderno de Lisp para la JVM.', 'language'),
    ('Elixir', 'Lenguaje funcional y concurrente sobre la máquina virtual de Erlang.', 'language'),
    ('Erlang', 'Lenguaje diseñado para construir sistemas escalables en tiempo real.', 'language'),
    ('Groovy', 'Lenguaje dinámico para la plataforma Java.', 'language'),
    ('Solidity', 'Lenguaje orientado a objetos para escribir contratos inteligentes.', 'language'),
    ('WebAssembly (Wasm)', 'Formato de instrucciones binario para navegadores web.', 'language'),
    ('Assembly', 'Lenguaje de programación de muy bajo nivel.', 'language'),
    ('COBOL', 'Lenguaje diseñado para el desarrollo de negocios.', 'language'),
    
    -- FRAMEWORKS Y LIBRERIAS (FRONTEND)
    ('Ember.js', 'Framework de JavaScript para aplicaciones web ambiciosas.', 'framework'),
    ('Backbone.js', 'Librería de JavaScript ligera que provee estructura.', 'framework'),
    ('Solid.js', 'Librería declarativa y reactiva para interfaces.', 'framework'),
    ('Qwik', 'Framework para reanudabilidad instantánea (instant-on).', 'framework'),
    ('Three.js', 'Librería JavaScript 3D para WebGL.', 'framework'),
    ('D3.js', 'Librería para manipular documentos basados en datos.', 'framework'),
    ('RxJS', 'Librería para programación reactiva usando Observables.', 'framework'),
    ('Redux', 'Contenedor de estado predecible para aplicaciones JS.', 'framework'),
    ('Zustand', 'Solución de gestión de estado pequeña, rápida y escalable.', 'framework'),
    ('Bootstrap', 'Framework CSS clásico para desarrollo responsivo.', 'framework'),
    ('Material-UI (MUI)', 'Librería de componentes React basada en Material Design.', 'framework'),
    
    -- FRAMEWORKS (BACKEND Y FULLSTACK)
    ('Meteor', 'Plataforma para construir apps web y móviles en JavaScript puro.', 'framework'),
    ('NestJS', 'Framework Node.js para aplicaciones eficientes y escalables.', 'framework'),
    ('Fastify', 'Framework web rápido y de bajo overhead para Node.js.', 'framework'),
    ('AdonisJS', 'Framework web completo para Node.js estilo Laravel.', 'framework'),
    ('ASP.NET Core', 'Framework web open source y multiplataforma de Microsoft.', 'framework'),
    ('FastAPI', 'Framework web moderno y rápido para construir APIs con Python.', 'framework'),
    ('Flask', 'Micro framework web escrito en Python.', 'framework'),
    ('Symfony', 'Conjunto de componentes PHP y framework web.', 'framework'),
    ('CodeIgniter', 'Framework PHP con footprint muy pequeño.', 'framework'),
    ('Sinatra', 'DSL para crear aplicaciones web rápidamente en Ruby.', 'framework'),
    ('Phoenix', 'Framework web productivo construido en Elixir.', 'framework'),
    ('Play Framework', 'Framework web de alta velocidad para Java y Scala.', 'framework'),
    ('Quarkus', 'Framework Java nativo para Kubernetes diseñado para GraalVM.', 'framework'),
    ('Gin', 'Framework web HTTP escrito en Go (Golang).', 'framework'),
    ('Fiber', 'Framework web estilo Express escrito en Go.', 'framework'),
    
    -- DESARROLLO MOVIL Y DESKTOP
    ('React Native', 'Framework para crear aplicaciones nativas usando React.', 'framework'),
    ('Ionic', 'Toolkit de UI móvil open source multiplataforma.', 'framework'),
    ('Capacitor', 'Runtime nativo multiplataforma creado por Ionic.', 'tool'),
    ('Xamarin', 'Plataforma open source de Microsoft para construir apps móviles.', 'framework'),
    ('Electron', 'Framework para construir apps de escritorio usando tecnologías web.', 'framework'),
    ('Tauri', 'Herramienta para construir aplicaciones de escritorio más rápidas, seguras y ligeras.', 'framework'),
    
    -- BASES DE DATOS (RELACIONAL, NOSQL, GRAPH, TIME-SERIES)
    ('SQLite', 'Motor de base de datos relacional ligero y embebido.', 'database'),
    ('CockroachDB', 'Base de datos SQL distribuida de nube nativa.', 'database'),
    ('MariaDB', 'Fork de MySQL impulsado por la comunidad.', 'database'),
    ('Neo4j', 'Base de datos orientada a grafos nativa.', 'database'),
    ('Cassandra', 'Base de datos NoSQL distribuida altamente escalable.', 'database'),
    ('Supabase', 'Alternativa open source a Firebase.', 'database'),
    ('InfluxDB', 'Base de datos de series temporales (Time-Series).', 'database'),
    ('TimescaleDB', 'Base de datos de series de tiempo escalable basada en PostgreSQL.', 'database'),
    
    -- MESSAGE BROKERS Y STREAMING
    ('Kafka', 'Plataforma de transmisión de eventos distribuidos de código abierto.', 'tool'),
    ('RabbitMQ', 'Intermediario de mensajes open source (Message Broker).', 'tool'),
    ('Amazon SQS', 'Servicio de colas de mensajes totalmente administrado.', 'tool'),
    ('Google Pub/Sub', 'Servicio de mensajería asíncrono para escalar sistemas.', 'tool'),
    
    -- CLOUD Y SERVELESS
    ('GCP (Google Cloud Platform)', 'Suite de servicios de computación en la nube de Google.', 'tool'),
    ('Azure', 'Plataforma de computación en la nube de Microsoft.', 'tool'),
    ('DigitalOcean', 'Plataforma de nube simplificada para desarrolladores.', 'tool'),
    ('Vercel', 'Plataforma cloud para frontend y frameworks sin servidor.', 'tool'),
    ('Netlify', 'Plataforma para despliegues automáticos web.', 'tool'),
    ('Cloudflare Workers', 'Plataforma de computación sin servidor (Edge).', 'tool'),
    ('AWS Lambda', 'Servicio informático sin servidor impulsado por eventos.', 'tool'),
    
    -- CONTENEDORES Y ORQUESTACION
    ('Docker Swarm', 'Herramienta nativa de orquestación (clustering) para Docker.', 'tool'),
    ('OpenShift', 'Plataforma de contenedores Kubernetes empresarial de Red Hat.', 'tool'),
    ('Helm', 'El administrador de paquetes para Kubernetes.', 'tool'),
    ('Istio', 'Service mesh abierto que provee manera uniforme de asegurar, conectar y monitorear microservicios.', 'tool'),
    
    -- CI/CD Y HERRAMIENTAS DE DEVOPS
    ('CircleCI', 'Plataforma de CI/CD para automatizar compilación y pruebas.', 'tool'),
    ('Travis CI', 'Servicio de integración continua distribuido.', 'tool'),
    ('ArgoCD', 'Herramienta de entrega continua declarativa GitOps para Kubernetes.', 'tool'),
    ('SonarQube', 'Plataforma de revisión automática de código para detectar bugs y code smells.', 'tool'),
    ('Datadog', 'Servicio de monitoreo y análisis para equipos de TI.', 'tool'),
    ('New Relic', 'Plataforma de observabilidad de pila completa.', 'tool'),
    ('Grafana', 'Software de análisis métrico y visualización de código abierto.', 'tool'),
    ('Prometheus', 'Sistema de monitoreo y alertas de código abierto.', 'tool'),
    
    -- INGENIERIA DE DATOS E IA
    ('Apache Spark', 'Motor analítico unificado para procesamiento de datos a gran escala.', 'tool'),
    ('Hadoop', 'Framework para procesamiento distribuido de grandes conjuntos de datos.', 'tool'),
    ('Airflow', 'Plataforma para crear, programar y monitorizar flujos de trabajo.', 'tool'),
    ('Snowflake', 'Almacén de datos basado en la nube (Data Warehouse).', 'tool'),
    ('TensorFlow', 'Plataforma de código abierto de extremo a extremo para el aprendizaje automático.', 'framework'),
    ('PyTorch', 'Framework de machine learning open source optimizado (Facebook).', 'framework'),
    ('Scikit-Learn', 'Librería de machine learning simple y eficiente para Python.', 'framework'),
    ('Pandas', 'Librería de análisis y manipulación de datos en Python.', 'tool'),
    ('OpenCV', 'Librería de visión por computadora de código abierto.', 'framework'),
    ('Hugging Face', 'Comunidad y plataforma de IA enfocada en Machine Learning y NLP.', 'tool'),
    ('LangChain', 'Framework para desarrollar aplicaciones impulsadas por modelos de lenguaje.', 'framework'),
    
    -- CONCEPTOS Y ARQUITECTURAS DE SOFTWARE
    ('Scrum', 'Framework de trabajo ágil iterativo e incremental.', 'domain_knowledge'),
    ('Kanban', 'Método para gestionar el trabajo equilibrando demandas con capacidad.', 'domain_knowledge'),
    ('OOP (Orientación a Objetos)', 'Paradigma de programación basado en el concepto de "objetos".', 'domain_knowledge'),
    ('FP (Programación Funcional)', 'Paradigma que trata la computación como la evaluación de funciones matemáticas.', 'domain_knowledge'),
    ('SOLID', 'Cinco principios de diseño orientado a objetos.', 'domain_knowledge'),
    ('Clean Architecture', 'Patrón arquitectónico que separa las preocupaciones (separation of concerns).', 'domain_knowledge'),
    ('Arquitectura Hexagonal', 'Patrón de diseño de software (Ports and Adapters).', 'domain_knowledge'),
    ('Event Sourcing', 'Capturar todos los cambios de estado de una app como secuencias de eventos.', 'domain_knowledge'),
    ('OAuth 2.0', 'Estándar industrial para autorización de acceso.', 'domain_knowledge'),
    ('JWT', 'JSON Web Token, estándar para transmisión de información segura.', 'domain_knowledge'),
    ('gRPC', 'Framework RPC universal de código abierto de alto rendimiento.', 'domain_knowledge'),
    ('Web3', 'Concepto de una nueva iteración de la World Wide Web basada en blockchain.', 'domain_knowledge'),
    
    -- HERRAMIENTAS DE DESARROLLADOR E IDEs
    ('VS Code', 'Editor de código fuente desarrollado por Microsoft.', 'tool'),
    ('IntelliJ IDEA', 'IDE para Java y desarrollo de software general.', 'tool'),
    ('WebStorm', 'El entorno de desarrollo integrado de JavaScript más inteligente.', 'tool'),
    ('PyCharm', 'El IDE para desarrollo profesional en Python.', 'tool'),
    ('Vim', 'Editor de texto altamente configurable y eficiente.', 'tool'),
    ('Postman', 'Plataforma de colaboración para desarrollo de APIs.', 'tool'),
    ('Swagger (OpenAPI)', 'Conjunto de herramientas construidas alrededor de la especificación OpenAPI.', 'tool');

  -- Insertar competencias en la tabla real
  INSERT INTO competencies (name, description, category)
  SELECT name, description, category FROM tmp_competencies
  ON CONFLICT (name) DO NOTHING;

  -- Vincular las nuevas competencias directamente al área de Tecnología
  FOR comp_record IN SELECT id FROM competencies WHERE name IN (SELECT name FROM tmp_competencies) LOOP
    INSERT INTO competency_areas (competency_id, professional_area_id)
    VALUES (comp_record.id, tech_area_id)
    ON CONFLICT (competency_id, professional_area_id) DO NOTHING;
  END LOOP;

END $$;
