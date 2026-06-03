# ARCHITECTURE.md

# Arquitectura de Valora

## Descripción general

Valora es una plataforma mobile-first orientada a estimar el valor profesional de usuarios de distintas áreas laborales, mostrando información como salario estimado, compatibilidad laboral, recomendaciones y valoración aproximada de proyectos.

La arquitectura del sistema está pensada para ser modular, escalable y sencilla de mantener durante el desarrollo académico del proyecto.

La primera versión estará enfocada principalmente en Tecnología, aunque la estructura permitirá agregar nuevas áreas profesionales mediante catálogos y reglas de evaluación.

---

# Tecnologías principales

## Landing Web

* React
* Tailwind CSS
* AWS EC2
* Nginx

## Aplicación

* Flutter
* Dart
* Flutter Web
* Android APK

## Backend

* Supabase Edge Functions
* TypeScript

## Base de datos

* Supabase PostgreSQL

## Autenticación

* Supabase Auth
* Google OAuth
* Correo y contraseña

## Control de versiones

* Git
* GitHub

## Infraestructura

* AWS EC2 Ubuntu
* Nginx
* DuckDNS o dominio personalizado
* HTTPS con Let's Encrypt como mejora recomendada

---

# Arquitectura general

```txt
Usuario
  │
  ▼
Landing Web
React + Tailwind
AWS EC2 + Nginx
  │
  ├── /app
  │     ▼
  │   Flutter Web
  │
  └── /downloads/valora.apk
        ▼
      APK Android
```

```txt
Flutter App
  │
  ├── Supabase Auth
  │     ├── Login
  │     ├── Registro
  │     └── Google OAuth
  │
  ├── Supabase PostgreSQL
  │     ├── Perfiles
  │     ├── Competencias
  │     ├── Certificaciones
  │     ├── Idiomas
  │     ├── Proyectos
  │     └── Historial
  │
  └── Supabase Edge Functions
        ├── Estimación salarial
        ├── Compatibilidad laboral
        └── Valor de proyecto
```

---

# Flujo de acceso del usuario

## Landing

La landing será la primera pantalla pública del sistema.

Su objetivo es explicar:

* Qué es Valora.
* Cómo funciona.
* Qué beneficios ofrece.
* Qué áreas profesionales contempla.
* Cómo ayuda al usuario a conocer su valor profesional.

Desde la landing el usuario podrá:

* Ingresar a la aplicación web.
* Descargar el APK de Android.

## Rutas principales

```txt
/
```

Landing principal.

```txt
/app
```

Aplicación Flutter Web.

```txt
/downloads/valora.apk
```

Descarga del APK de Android.

---

# Despliegue en AWS EC2

La instancia de AWS EC2 funcionará como servidor web mediante Nginx.

## Responsabilidades de AWS EC2

* Servir la landing web.
* Servir la aplicación Flutter Web.
* Alojar el archivo APK descargable.
* Servir archivos estáticos.
* Funcionar como entorno de demostración del proyecto.

## Estructura sugerida en servidor

```txt
/var/www/valora/
│
├── index.html
├── assets/
│
├── app/
│   ├── index.html
│   ├── assets/
│   └── flutter files
│
└── downloads/
    └── valora.apk
```

## Rutas sugeridas

```txt
https://valora.duckdns.org/
```

Landing.

```txt
https://valora.duckdns.org/app/
```

Aplicación Flutter Web.

```txt
https://valora.duckdns.org/downloads/valora.apk
```

APK descargable.

---

# Flujo de despliegue manual

## Landing React

```txt
1. Entrar por SSH a la instancia AWS.
2. Ir al repositorio del proyecto.
3. Descargar cambios con git pull.
4. Entrar a la carpeta landing.
5. Instalar dependencias si es necesario.
6. Generar build.
7. Copiar archivos generados a /var/www/valora.
8. Recargar Nginx.
```

Ejemplo:

```bash
cd ~/valora/landing
git pull
npm install
npm run build
sudo rm -rf /var/www/valora/*
sudo cp -r dist/* /var/www/valora/
sudo systemctl reload nginx
```

## Flutter Web

```txt
1. Entrar a la carpeta de la aplicación Flutter.
2. Descargar cambios.
3. Ejecutar build web usando base href /app/.
4. Copiar archivos generados a /var/www/valora/app.
5. Recargar Nginx.
```

Ejemplo:

```bash
cd ~/valora/app
git pull
flutter build web --base-href /app/
sudo rm -rf /var/www/valora/app/*
sudo cp -r build/web/* /var/www/valora/app/
sudo systemctl reload nginx
```

## APK Android

```txt
1. Generar APK desde Flutter.
2. Copiar APK a la carpeta downloads.
3. La landing tendrá un botón para descargarlo.
```

Ejemplo:

```bash
flutter build apk --release
sudo cp build/app/outputs/flutter-apk/app-release.apk /var/www/valora/downloads/valora.apk
```

---

# Arquitectura de la aplicación Flutter

La aplicación Flutter estará organizada por módulos o features.

## Estructura sugerida

```txt
lib/
│
├── main.dart
│
├── core/
│   ├── config/
│   ├── constants/
│   ├── errors/
│   ├── router/
│   ├── theme/
│   └── utils/
│
├── shared/
│   ├── widgets/
│   ├── models/
│   └── services/
│
└── features/
    ├── auth/
    ├── splash/
    ├── onboarding/
    ├── dashboard/
    ├── profile/
    ├── results/
    └── project_value/
```

---

# Responsabilidades por carpeta

## core/

Contiene configuración global de la aplicación.

Ejemplos:

* Configuración de Supabase.
* Constantes globales.
* Manejo de errores.
* Tema visual.
* Rutas principales.
* Utilidades generales.

## shared/

Contiene elementos reutilizables entre módulos.

Ejemplos:

* Cards.
* Botones.
* Inputs.
* Badges.
* Modelos compartidos.
* Servicios comunes.

## features/

Contiene los módulos principales de la aplicación.

Cada feature debe agrupar sus pantallas, widgets, modelos y lógica específica.

---

# Features principales

## auth/

Responsable de:

* Login.
* Registro.
* Login con Google.
* Recuperación de contraseña.
* Manejo de sesión.

## splash/

Responsable de:

* Mostrar pantalla inicial.
* Validar sesión activa.
* Redirigir al usuario.

## onboarding/

Responsable de:

* Mostrar pantalla de bienvenida.
* Explicar brevemente la aplicación.
* Redirigir a login o registro.

## dashboard/

Responsable de:

* Mostrar resumen profesional.
* Mostrar valor estimado.
* Mostrar compatibilidad principal.
* Mostrar perfil completado.
* Mostrar accesos rápidos.
* Mostrar historial reciente.

## profile/

Responsable de:

* Mostrar perfil profesional.
* Editar información general.
* Gestionar competencias.
* Gestionar certificaciones.
* Gestionar idiomas.
* Gestionar proyectos.
* Cerrar sesión.

## results/

Responsable de:

* Mostrar estimación salarial.
* Mostrar compatibilidad laboral.
* Mostrar recomendaciones.
* Mostrar puestos compatibles.
* Mostrar competencias coincidentes y faltantes.

## project_value/

Responsable de:

* Registrar información del proyecto.
* Enviar datos para valoración.
* Mostrar rango estimado.
* Mostrar factores influyentes.
* Mostrar recomendaciones.

---

# Comunicación con Supabase

La aplicación Flutter se comunicará directamente con Supabase para operaciones simples de lectura y escritura.

## Operaciones directas desde Flutter

* Crear perfil.
* Editar perfil.
* Consultar catálogos.
* Registrar competencias.
* Registrar certificaciones.
* Registrar idiomas.
* Registrar proyectos.
* Consultar historial.

## Operaciones mediante Edge Functions

Las operaciones que involucren lógica de negocio más compleja se manejarán mediante Supabase Edge Functions.

Ejemplos:

* Estimación salarial.
* Compatibilidad laboral.
* Valoración de proyecto.

---

# Flujo de datos

## Registro e inicio de sesión

```txt
Usuario
  │
  ▼
Flutter App
  │
  ▼
Supabase Auth
  │
  ▼
Sesión activa
  │
  ▼
Dashboard
```

## Creación de perfil

```txt
Usuario
  │
  ▼
Formulario de perfil
  │
  ▼
Flutter App
  │
  ▼
Supabase PostgreSQL
  │
  ▼
profiles
```

## Registro de competencias

```txt
Usuario
  │
  ▼
Editar Perfil
  │
  ▼
Seleccionar competencias
  │
  ▼
user_competencies
  │
  ▼
Supabase PostgreSQL
```

## Estimación salarial

```txt
Usuario
  │
  ▼
Resultados
  │
  ▼
Flutter App
  │
  ▼
Supabase Edge Function
  │
  ▼
Consulta perfil + competencias + idiomas + certificaciones
  │
  ▼
Genera estimación
  │
  ▼
salary_estimations
  │
  ▼
Flutter App muestra resultado
```

## Compatibilidad laboral

```txt
Usuario
  │
  ▼
Resultados
  │
  ▼
Flutter App
  │
  ▼
Supabase Edge Function
  │
  ▼
Consulta perfil + competencias + roles laborales
  │
  ▼
Calcula compatibilidad
  │
  ▼
job_matches
  │
  ▼
Flutter App muestra resultado
```

## Valor de proyecto

```txt
Usuario
  │
  ▼
Formulario de proyecto
  │
  ▼
Flutter App
  │
  ▼
Supabase Edge Function
  │
  ▼
Evalúa tipo, complejidad, competencias y tiempo
  │
  ▼
project_estimations
  │
  ▼
Flutter App muestra resultado
```

---

# Supabase Edge Functions

Las Edge Functions serán utilizadas para separar la lógica crítica de negocio del frontend.

## Funciones sugeridas

```txt
estimate-salary
job-match
project-value
```

## estimate-salary

Responsable de:

* Recibir el perfil del usuario.
* Consultar competencias.
* Consultar idiomas.
* Consultar certificaciones.
* Consultar área profesional.
* Calcular rango salarial aproximado.
* Guardar resultado en `salary_estimations`.

## job-match

Responsable de:

* Consultar roles laborales disponibles.
* Comparar competencias del usuario con roles laborales.
* Calcular porcentaje de compatibilidad.
* Identificar competencias coincidentes.
* Identificar competencias faltantes.
* Guardar resultados en `job_matches`.

## project-value

Responsable de:

* Recibir información de un proyecto.
* Evaluar tipo de proyecto.
* Evaluar complejidad.
* Evaluar competencias utilizadas.
* Evaluar tiempo estimado.
* Calcular rango de valor aproximado.
* Guardar resultado en `project_estimations`.

---

# Base de datos

La base de datos será administrada mediante Supabase PostgreSQL.

Las tablas principales estarán documentadas en `DATABASE.md`.

## Tablas principales

```txt
profiles
professional_areas
competencies
competency_areas
user_competencies
certifications
languages
language_levels
user_languages
projects
project_competencies
job_roles
salary_estimations
job_matches
project_estimations
```

---

# Seguridad

El sistema utilizará Row Level Security en Supabase.

## Reglas generales

* Cada usuario solo puede ver sus propios datos.
* Cada usuario solo puede editar sus propios datos.
* Los catálogos pueden ser consultados por usuarios autenticados.
* Los catálogos no pueden ser modificados por usuarios normales.
* Las funciones críticas deben validar el usuario autenticado antes de procesar resultados.

## Datos protegidos por usuario

* Perfil.
* Competencias registradas.
* Certificaciones.
* Idiomas.
* Proyectos.
* Estimaciones salariales.
* Compatibilidad laboral.
* Valoraciones de proyecto.

---

# Variables de entorno

El proyecto deberá utilizar variables de entorno para manejar claves y configuraciones sensibles.

## Flutter

Ejemplos:

```txt
SUPABASE_URL
SUPABASE_ANON_KEY
```

## Landing

Ejemplos:

```txt
VITE_APP_URL
VITE_DOWNLOAD_APK_URL
```

## Edge Functions

Ejemplos:

```txt
SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY
```

## Nota

No se deben subir archivos `.env` al repositorio.

Se recomienda incluir archivos de ejemplo como:

```txt
.env.example
```

---

# Repositorio

## Estructura sugerida del proyecto

```txt
valora/
│
├── app/
│   └── Flutter app
│
├── landing/
│   └── React + Tailwind landing
│
├── supabase/
│   ├── functions/
│   ├── migrations/
│   └── seeds/
│
├── docs/
│   ├── FEATURES.md
│   ├── DATABASE.md
│   ├── ARCHITECTURE.md
│   ├── API_CONTRACT.md
│   ├── ROADMAP.md
│   ├── GIT_WORKFLOW.md
│   └── UI_GUIDELINES.md
│
├── scripts/
│   └── deploy scripts
│
├── README.md
└── AGENTS.md
```

---

# Convenciones generales

## Nombres de carpetas

Usar nombres en minúsculas y snake_case cuando sea necesario.

Ejemplos:

```txt
project_value
user_profile
job_match
```

## Nombres de archivos Dart

Usar snake_case.

Ejemplos:

```txt
profile_screen.dart
profile_controller.dart
profile_service.dart
```

## Nombres de tablas

Usar plural y snake_case.

Ejemplos:

```txt
user_competencies
salary_estimations
project_estimations
```

## Nombres de funciones API

Usar kebab-case en endpoints y nombres descriptivos.

Ejemplos:

```txt
estimate-salary
job-match
project-value
```

---

# Decisiones arquitectónicas

## Uso de Supabase

Supabase se utilizará para:

* Autenticación.
* Base de datos PostgreSQL.
* Row Level Security.
* Edge Functions.
* Integración con Google OAuth.

## Uso de Edge Functions

Las Edge Functions se usarán únicamente para lógica de negocio importante.

Esto evita crear un backend completo adicional y reduce la complejidad del proyecto.

## Uso de AWS EC2

AWS EC2 se usará como servidor de despliegue para:

* Landing.
* Flutter Web.
* APK descargable.

## Uso de Flutter Web

Flutter Web permitirá que los usuarios prueben la aplicación sin descargar el APK.

Esto mejora la accesibilidad durante la exposición y permite mostrar la aplicación desde navegador.

## Uso de APK

El APK permitirá demostrar que la aplicación también puede ejecutarse como aplicación móvil Android.

---

# Alcance técnico de la primera versión

La primera versión debe priorizar:

* Autenticación.
* Perfil profesional.
* Competencias.
* Certificaciones.
* Idiomas.
* Proyectos.
* Estimación salarial.
* Compatibilidad laboral.
* Valoración de proyecto.
* Dashboard.
* Landing pública.
* Despliegue en AWS.

---

# Mejoras futuras

## CI/CD

Automatizar despliegues desde GitHub hacia AWS.

## Dominio personalizado

Usar dominio propio en lugar de subdominio gratuito.

## HTTPS

Configurar HTTPS con Let's Encrypt.

## Integración con vacantes reales

Conectar con fuentes externas de empleo para mostrar oportunidades reales.

## Evidencias de certificaciones

Permitir cargar archivos o enlaces verificables de certificaciones.

## Reglas avanzadas por área

Crear reglas más específicas para estimaciones según cada área profesional.

---

# Resumen

Valora utilizará una arquitectura basada en Flutter, React, Supabase y AWS.

La landing y la aplicación web serán servidas desde AWS EC2 mediante Nginx. La autenticación, base de datos y lógica crítica estarán centralizadas en Supabase.

La aplicación Flutter será responsable de la experiencia del usuario, mientras que Supabase Edge Functions manejará los cálculos principales de estimación salarial, compatibilidad laboral y valoración de proyectos.

Esta arquitectura permite desarrollar una primera versión funcional, mantener el proyecto organizado y dejar espacio para futuras mejoras sin crear una estructura innecesariamente compleja.
