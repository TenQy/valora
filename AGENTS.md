# AGENTS.md

# Valora - Contexto para Agentes de IA

## Descripción

Valora es una plataforma mobile-first para estimar el valor profesional de una persona mediante el análisis de competencias, idiomas, experiencia, certificaciones y proyectos.

La aplicación genera:

* Estimación salarial
* Compatibilidad laboral
* Recomendaciones profesionales
* Valoración aproximada de proyectos

La primera versión tiene mayor profundidad en el área de Tecnología, aunque la arquitectura permite soportar múltiples áreas profesionales.

---

# Stack Tecnológico

## Aplicación

* Flutter
* Dart
* Flutter Web
* Android APK

## Landing

* React
* Tailwind CSS

## Backend y Base de Datos

* Supabase Auth
* Supabase PostgreSQL
* Supabase Edge Functions
* TypeScript

## Infraestructura

* AWS EC2
* Ubuntu
* Nginx

---

# Arquitectura General

```txt
Landing React
    ↓
Flutter Web / APK
    ↓
Supabase Auth
    ↓
Supabase PostgreSQL
    ↓
Supabase Edge Functions
```

## Edge Functions principales

```txt
estimate-salary
job-match
project-value
```

---

# Módulos Principales

```txt
auth
splash
onboarding
dashboard
profile
results
project_value
```

---

# Base de Datos

Tablas principales:

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

# MVP

Funcionalidades obligatorias:

* Splash Screen
* Pantalla de Bienvenida
* Login
* Registro
* Login con Google
* Perfil Profesional
* Competencias
* Idiomas
* Estimación Salarial
* Compatibilidad Laboral
* Dashboard
* Historial

---

# Reglas para Agentes

## Arquitectura

* No modificar la arquitectura principal sin aprobación.
* No reemplazar Supabase por otra solución.
* No crear un backend adicional sin autorización.
* Seguir la estructura definida en ARCHITECTURE.md.

## Base de Datos

* No crear tablas nuevas sin aprobación.
* No duplicar entidades existentes.
* Utilizar `competencies` como concepto principal de habilidades.
* Mantener certificaciones separadas de competencias.
* Seguir DATABASE.md como fuente de verdad.

## API

* Respetar API_CONTRACT.md.
* No crear endpoints innecesarios.
* Utilizar Edge Functions únicamente para lógica de negocio.

## Flutter

* Mantener organización por features.
* Utilizar widgets reutilizables en `shared/widgets`.
* Mantener configuración global en `core/`.
* Priorizar código simple y mantenible.

---

# Convenciones

## Git

Ramas:

```txt
feature/*
fix/*
docs/*
```

Commits:

```txt
feat:
fix:
docs:
refactor:
style:
chore:
```

## Código

Archivos:

```txt
profile_screen.dart
profile_service.dart
profile_model.dart
```

Clases:

```txt
ProfileScreen
ProfileService
UserProfile
```

Variables y funciones:

```txt
getUserProfile()
updateProfile()
selectedCompetencies
```

---

# Prioridades

Al generar código, priorizar:

1. Mantenibilidad
2. Simplicidad
3. Consistencia
4. Escalabilidad
5. Rendimiento

Evitar sobreingeniería.

---

# Documentación de Referencia

Consultar en este orden:

```txt
DATABASE.md
ARCHITECTURE.md
API_CONTRACT.md
FEATURES.md
ROADMAP.md
GIT_WORKFLOW.md
```

---

# Objetivo

Generar código, documentación y propuestas que respeten la arquitectura existente, mantengan el proyecto simple y permitan completar el MVP de Valora de forma funcional y demostrable.
