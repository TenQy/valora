# Checklist de Requerimientos - Tarea Semana 12

Este documento lista **todos** los requerimientos extraídos textualmente de la presentación de la semana 12. Se detalla exactamente cómo se aplican en la arquitectura actual de la aplicación **Valora**. Los elementos marcados en amarillo (🟡) son aquellos que se integrarán próximamente para aumentar la calificación.

## Programación móvil (Diapositiva 2)
- Plataformas operativas. **(✅ Aplica):** Se usa para compilar la aplicación nativamente en Android (APK) y Web.
- Lenguajes de programación. **(✅ Aplica):** Se usa Dart para el frontend y TypeScript para el backend.
- Herramientas de desarrollo. **(✅ Aplica):** Se usa VS Code, Flutter SDK y Supabase CLI para el desarrollo local.
- Acelerometro. **(❌ No aplica)**
- Giroscopio. **(❌ No aplica)**
- Magnetometro. **(❌ No aplica)**
- Sensor de proximidad. **(❌ No aplica)**
- Sensor de luz. **(❌ No aplica)**
- Camara. **(🟡 Pendiente):** Se usa internamente el hardware de la cámara frontal (cámara de profundidad) para habilitar el reconocimiento facial de seguridad (FaceID).
- GPS. **(❌ No aplica)**
- Podometro. **(❌ No aplica)**
- Detector de huella. **(🟡 Pendiente):** Se usa como una capa de seguridad opcional en el perfil para proteger los datos financieros al entrar a la app.
- Bluetooth. **(❌ No aplica)**
- Red inalámbrica. **(✅ Aplica):** Se usa para mantener la conexión a internet indispensable para sincronizar la app con la nube.
- Near Field Comunication. **(❌ No aplica)**

## Tipos de datos y expresiones (Diapositiva 3)
- Numéricos **(✅ Aplica):** Se usan variables enteras para años de experiencia y decimales para calcular los sueldos.
- Lógicos. **(✅ Aplica):** Se usan variables booleanas para controlar si se muestran u ocultan pantallas de carga.
- Caracteres. **(✅ Aplica):** Se usan internamente para reemplazar caracteres especiales como acentos en el buscador.
- Cadenas de caracteres. **(✅ Aplica):** Se usan para almacenar textos como nombres, correos y descripciones biográficas.
- Arreglos. **(✅ Aplica):** Se usan listas dinámicas para gestionar catálogos enteros de competencias e idiomas.
- Aritméticas. **(✅ Aplica):** Se usan fórmulas en la nube para sumar bonos y calcular el salario estimado del usuario.
- Lógicas **(✅ Aplica):** Se usan expresiones condicionales para mostrar botones solo si una lista tiene elementos.
- Operadores. **(✅ Aplica):** Se usan operadores de asignación y operadores matemáticos (+, *, /) en el código del motor salarial.
- Precedencia. **(✅ Aplica):** Se usan agrupaciones con paréntesis en las matemáticas para aplicar los topes salariales correctamente.
- Aritméticos **(✅ Aplica):** Se usan para incrementar porcentajes en el cálculo, como el bono por bilingüismo.
- Lógicos. **(✅ Aplica):** Se usan operadores AND y OR para aplicar múltiples filtros simultáneos en las búsquedas.
- Relacionales. **(✅ Aplica):** Se usan comparadores de "mayor que" o "menor que" para validar que la experiencia no exceda los límites lógicos.
- Operandos. **(✅ Aplica):** Se usan como las variables de entrada que alimentan todas las fórmulas del cálculo salarial.

## Entornos de desarrollo de aplicaciones móviles (Diapositiva 4)
- Vistas. **(✅ Aplica):** Se usan pantallas programadas en Flutter para construir la interfaz visual interactiva.
- Controles. **(✅ Aplica):** Se usan botones, campos de texto y casillas de selección nativas de Material Design.
- Emuladores. **(✅ Aplica):** Se usa el emulador de Android (Pixel) para compilar y probar visualmente la aplicación.
- Conectividad y sincronización. **(✅ Aplica):** Se usa una conexión bidireccional a la API REST de Supabase para mantener los perfiles actualizados.
- Actualización. **(✅ Aplica):** Se usan estados reactivos para repintar la interfaz gráfica en tiempo real sin tener que recargar la app.
- Versiones de SDK. **(✅ Aplica):** Se usa el archivo `pubspec.yaml` para asegurar versiones consistentes del SDK de Flutter en todo momento.

## Estructura de proyectos móviles (Diapositiva 5)
- Vistas. **(✅ Aplica):** Se usan directorios modulares dedicados (features) para separar visualmente cada pantalla del código de lógica.
- Servicios. **(✅ Aplica):** Se usa el patrón Repositorio para encapsular las consultas hacia la base de datos en clases independientes.
- Proveedores de contenidos. **(✅ Aplica):** Se usa PostgreSQL en la nube como la gran fuente de verdad que alimenta toda la app.
- Almacenamiento de datos. **(✅ Aplica):** Se usa el ecosistema Supabase para garantizar tablas de bases de datos seguras y normalizadas.
- Directorios. **(✅ Aplica):** Se usa una organización jerárquica de carpetas (`core`, `features`, `shared`) para un código escalable y limpio.
- Librerias. **(✅ Aplica):** Se usan paquetes instalados de forma externa para extender funcionalidades como iconos y animaciones.
- Notificaciones. **(🟡 Pendiente):** Se usan para emitir alertas locales recordando al usuario que actualice su perfil profesional.
- Seguridad. **(✅ Aplica):** Se usan políticas RLS (Row Level Security) en el servidor para evitar accesos no autorizados a cuentas ajenas.
- Depuración. **(✅ Aplica):** Se usa el inspector visual de Flutter DevTools y logs de consola para rastrear errores en tiempo de ejecución.
- Publicación. **(❌ No aplica)**

## Interfaz de usuario (Diapositiva 6)
- Disposición. **(✅ Aplica):** Se usan contenedores flexibles (Rows, Columns) para asegurar que la app se adapte a cualquier tamaño de pantalla.
- Controles basicos. **(✅ Aplica):** Se usan iconos semánticos, textos legibles y botones grandes de llamado a la acción.
- Controles de selección. **(✅ Aplica):** Se usan modales dinámicos para que el usuario elija su nivel de idioma o competencias con casillas.
- Controles personalizados. **(✅ Aplica):** Se usan componentes creados desde cero, como el buscador flotante `ValoraSearchableDropdown`, para una experiencia premium.
- Navegación. **(✅ Aplica):** Se usa el enrutador nativo de Flutter para empujar pantallas nuevas o reemplazar vistas previas sin romper el flujo.
- Estilos y temas. **(✅ Aplica):** Se usa un archivo maestro central de colores y estilos (Dark Mode) que unifica el diseño en toda la aplicación.
- Menus. **(✅ Aplica):** Se usan ventanas emergentes inferiores (BottomSheets) que fungen como menús altamente accesibles a una mano.
- Widget. **(✅ Aplica):** Se usa una arquitectura donde cada elemento de la pantalla es un widget reutilizable e independiente.
- Personalizacion. **(✅ Aplica):** Se usa para cambiar visualmente las opciones que se ofrecen según el perfil que seleccione el usuario.

## Desarrollo de Aplicaciones Móviles (Diapositiva 7)
- Acceso de base de datos. **(✅ Aplica):** Se usa el cliente nativo de Supabase para ejecutar operaciones asíncronas de lectura y escritura.
- Manejo de archivos. **(🟡 Pendiente):** Se usa para guardar localmente en el dispositivo las preferencias temporales del usuario invitado.
- Tratamiento de XML. **(🟡 Pendiente):** Se usa indirectamente cuando el celular procesa y graba de forma nativa los archivos de memoria caché del usuario invitado.
- Acceso a servicios. **(✅ Aplica):** Se usa la tecnología de funciones Serverless (Edge Functions) para procesar cálculos sin gastar batería del móvil.
- Reconocimiento UML. **(🟡 Pendiente):** Se usan diagramas visuales en los documentos formales para trazar las relaciones de base de datos.
- Técnicas de depuración. **(✅ Aplica):** Se usan puntos de quiebre (breakpoints) en VS Code para inspeccionar variables que devuelven resultados nulos.

## Servicios y notificaciones en aplicaciones móviles (Diapositiva 8)
- Proovedores de contenido. **(✅ Aplica):** Se usa el backend para devolver resúmenes JSON consolidados y repintar la información financiera en pantalla.
- Acceso a servicios web. **(✅ Aplica):** Se usa conexión cifrada a endpoints remotos enviando identificadores de sesión seguros (JWT).
- Tareas en segundo plano. **(✅ Aplica):** Se usan pantallas de carga sin bloquear el celular mientras los algoritmos pesados operan remotamente.
- Notificaciones. **(🟡 Pendiente):** Se usan para avisar de novedades en la aplicación y programar recordatorios periódicos automáticos.

## Gestion de sensores (Diapositiva 9)
- Habilitación. **(🟡 Pendiente):** Se usa pidiendo permiso al celular para acceder al sistema biométrico de huella digital.
- Calibración. **(🟡 Pendiente):** Se usa la librería criptográfica nativa (Keychain) del sistema operativo móvil para calibrar el lector de huellas.
- Obtención de información. **(🟡 Pendiente):** Se usa al capturar el resultado lógico de validación una vez que el usuario coloca su huella en el equipo.
- Procesamiento de información. **(🟡 Pendiente):** Se usa procesando la lectura correcta para desbloquear el dashboard y permitir ver los datos privados.
- Reconocimiento facial. **(🟡 Pendiente):** Se usa como vía alternativa para permitir el inicio de sesión sin contraseñas usando cámaras de profundidad (FaceID).
- Reconocimiento dactilar. **(🟡 Pendiente):** Se usa integrando la petición nativa del teléfono para proteger los salarios antes de revelarlos en pantalla.
- Geolocalización. **(❌ No aplica)**
