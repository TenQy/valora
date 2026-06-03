# API_CONTRACT.md

# Contrato de API de Valora

## Descripción general

Este documento define los endpoints y operaciones principales que utilizará Valora para comunicarse entre la aplicación Flutter, Supabase y las Edge Functions.

La aplicación usará Supabase directamente para operaciones simples de lectura y escritura, mientras que la lógica de negocio más importante será manejada mediante Supabase Edge Functions.

---

# Tipos de comunicación

## Comunicación directa con Supabase

Se usará para operaciones CRUD simples:

* Consultar catálogos
* Crear perfil
* Editar perfil
* Registrar competencias
* Registrar certificaciones
* Registrar idiomas
* Registrar proyectos
* Consultar historial

## Supabase Edge Functions

Se usarán para operaciones con lógica de negocio:

* Estimación salarial
* Compatibilidad laboral
* Valoración de proyecto

---

# Autenticación

Todas las operaciones privadas requieren usuario autenticado mediante Supabase Auth.

Métodos de autenticación:

* Correo y contraseña
* Google OAuth

El token de sesión debe enviarse en las peticiones a Edge Functions.

---

# Endpoints / Operaciones principales

## 1. Obtener áreas profesionales

```http
GET /professional-areas
```

### Descripción

Obtiene las áreas profesionales disponibles en la plataforma.

### Respuesta esperada

```json
[
  {
    "id": "uuid",
    "name": "Tecnología",
    "description": "Área relacionada con software, datos, redes y sistemas."
  }
]
```

---

## 2. Obtener competencias

```http
GET /competencies
```

### Descripción

Obtiene las competencias disponibles.

Puede filtrarse por área profesional.

### Query params

```txt
professional_area_id
```

### Respuesta esperada

```json
[
  {
    "id": "uuid",
    "name": "Flutter",
    "category": "Framework",
    "description": "Framework para desarrollo multiplataforma."
  }
]
```

---

## 3. Obtener idiomas

```http
GET /languages
```

### Descripción

Obtiene los idiomas disponibles.

### Respuesta esperada

```json
[
  {
    "id": "uuid",
    "name": "Inglés"
  }
]
```

---

## 4. Obtener niveles de idioma

```http
GET /language-levels
```

### Descripción

Obtiene los niveles de idioma disponibles.

### Respuesta esperada

```json
[
  {
    "id": "uuid",
    "name": "B2",
    "description": "Intermedio alto"
  }
]
```

---

## 5. Obtener roles laborales

```http
GET /job-roles
```

### Descripción

Obtiene roles laborales disponibles.

Puede filtrarse por área profesional.

### Query params

```txt
professional_area_id
```

### Respuesta esperada

```json
[
  {
    "id": "uuid",
    "name": "Desarrollador Frontend",
    "professional_area_id": "uuid",
    "min_salary": 25000,
    "max_salary": 35000,
    "currency": "MXN"
  }
]
```

---

# Perfil profesional

## 6. Crear perfil

```http
POST /profiles
```

### Descripción

Crea el perfil profesional del usuario autenticado.

### Body

```json
{
  "full_name": "Juan Pérez",
  "professional_area_id": "uuid",
  "career": "Ingeniería en Sistemas Computacionales",
  "professional_level": "Practicante",
  "years_experience": 0,
  "bio": "Estudiante enfocado en desarrollo móvil y frontend."
}
```

### Respuesta esperada

```json
{
  "id": "uuid",
  "user_id": "uuid",
  "full_name": "Juan Pérez",
  "professional_area_id": "uuid",
  "career": "Ingeniería en Sistemas Computacionales",
  "professional_level": "Practicante",
  "years_experience": 0,
  "bio": "Estudiante enfocado en desarrollo móvil y frontend."
}
```

---

## 7. Obtener perfil

```http
GET /profiles/me
```

### Descripción

Obtiene el perfil profesional del usuario autenticado.

---

## 8. Actualizar perfil

```http
PUT /profiles/me
```

### Descripción

Actualiza el perfil profesional del usuario autenticado.

### Body

```json
{
  "career": "Ingeniería en Sistemas Computacionales",
  "professional_level": "Junior",
  "years_experience": 1,
  "bio": "Desarrollador frontend y móvil."
}
```

---

# Competencias del usuario

## 9. Agregar competencia al perfil

```http
POST /user-competencies
```

### Body

```json
{
  "competency_id": "uuid",
  "level": "Intermedio"
}
```

---

## 10. Obtener competencias del usuario

```http
GET /user-competencies
```

---

## 11. Eliminar competencia del usuario

```http
DELETE /user-competencies/{id}
```

---

# Certificaciones

## 12. Crear certificación

```http
POST /certifications
```

### Body

```json
{
  "name": "AWS Cloud Practitioner",
  "issuer": "Amazon Web Services",
  "issue_date": "2026-01-15",
  "credential_url": "https://example.com/certificate"
}
```

---

## 13. Obtener certificaciones

```http
GET /certifications
```

---

## 14. Actualizar certificación

```http
PUT /certifications/{id}
```

---

## 15. Eliminar certificación

```http
DELETE /certifications/{id}
```

---

# Idiomas

## 16. Agregar idioma al perfil

```http
POST /user-languages
```

### Body

```json
{
  "language_id": "uuid",
  "language_level_id": "uuid"
}
```

---

## 17. Obtener idiomas del usuario

```http
GET /user-languages
```

---

## 18. Eliminar idioma del usuario

```http
DELETE /user-languages/{id}
```

---

# Proyectos

## 19. Crear proyecto

```http
POST /projects
```

### Body

```json
{
  "professional_area_id": "uuid",
  "name": "Sistema de inventario",
  "description": "Aplicación para administrar ventas, productos e inventario.",
  "project_type": "Aplicación web",
  "complexity": "Media",
  "estimated_time": "2 meses",
  "platforms": ["Web", "Android"]
}
```

---

## 20. Obtener proyectos del usuario

```http
GET /projects
```

---

## 21. Actualizar proyecto

```http
PUT /projects/{id}
```

---

## 22. Eliminar proyecto

```http
DELETE /projects/{id}
```

---

## 23. Asociar competencia a proyecto

```http
POST /project-competencies
```

### Body

```json
{
  "project_id": "uuid",
  "competency_id": "uuid"
}
```

---

# Edge Functions

# 24. Estimación salarial

```http
POST /estimate-salary
```

### Descripción

Calcula un rango salarial aproximado con base en el perfil profesional del usuario.

### Body

```json
{
  "profile_id": "uuid"
}
```

### Respuesta esperada

```json
{
  "estimated_min_salary": 25000,
  "estimated_max_salary": 35000,
  "currency": "MXN",
  "professional_level": "Junior",
  "summary": "El perfil muestra buena compatibilidad con roles iniciales de desarrollo frontend.",
  "influential_factors": [
    "React",
    "Flutter",
    "Inglés B2",
    "1 año de experiencia"
  ]
}
```

---

# 25. Compatibilidad laboral

```http
POST /job-match
```

### Descripción

Calcula los roles laborales compatibles con el perfil del usuario.

### Body

```json
{
  "profile_id": "uuid"
}
```

### Respuesta esperada

```json
[
  {
    "job_role_id": "uuid",
    "job_role_name": "Desarrollador Frontend",
    "match_percentage": 85,
    "estimated_min_salary": 25000,
    "estimated_max_salary": 35000,
    "currency": "MXN",
    "matched_competencies": ["React", "JavaScript", "Git"],
    "missing_competencies": ["Testing", "TypeScript"],
    "summary": "El usuario tiene buena base para roles frontend."
  }
]
```

---

# 26. Valor de proyecto

```http
POST /project-value
```

### Descripción

Calcula el valor aproximado de un proyecto profesional.

### Body

```json
{
  "project_id": "uuid"
}
```

### Respuesta esperada

```json
{
  "estimated_min_value": 8000,
  "estimated_max_value": 15000,
  "currency": "MXN",
  "complexity_result": "Media",
  "summary": "El proyecto tiene complejidad media por incluir autenticación, base de datos y panel administrativo.",
  "recommendations": [
    "Definir claramente el alcance antes de cotizar.",
    "Separar funcionalidades básicas y avanzadas.",
    "Considerar costos de mantenimiento."
  ]
}
```

---

# Historial

## 27. Obtener historial de estimaciones salariales

```http
GET /salary-estimations
```

---

## 28. Obtener historial de compatibilidad laboral

```http
GET /job-matches
```

---

## 29. Obtener historial de valoraciones de proyecto

```http
GET /project-estimations
```

---

# Manejo de errores

## Formato general de error

```json
{
  "error": true,
  "message": "Descripción del error",
  "code": "ERROR_CODE"
}
```

## Códigos sugeridos

```txt
UNAUTHORIZED
PROFILE_NOT_FOUND
INVALID_INPUT
RESOURCE_NOT_FOUND
ESTIMATION_FAILED
DATABASE_ERROR
```

---

# Reglas generales

## Seguridad

* Ningún usuario puede consultar datos privados de otro usuario.
* Las operaciones privadas requieren sesión activa.
* Las Edge Functions deben validar el usuario autenticado.
* Las tablas privadas deben protegerse con Row Level Security.

## Catálogos

Los catálogos serán de solo lectura para usuarios normales.

Catálogos principales:

* professional_areas
* competencies
* competency_areas
* languages
* language_levels
* job_roles

## Resultados

Los resultados generados deben guardarse como historial simple.

Tablas de historial:

* salary_estimations
* job_matches
* project_estimations

No se guardarán snapshots completos del perfil en la primera versión.

---

# Notas de implementación

## Supabase directo vs Edge Functions

Las operaciones CRUD simples podrán hacerse directamente desde Flutter usando el cliente de Supabase.

Las operaciones de cálculo deben pasar por Edge Functions para evitar duplicar lógica en el frontend.

## Nombres reales en Supabase

Aunque este documento usa rutas tipo API para facilitar la comprensión, varias operaciones podrán implementarse directamente como consultas a tablas de Supabase.

Ejemplo:

```txt
GET /competencies
```

puede equivaler a consultar directamente la tabla:

```txt
competencies
```

desde Flutter.

## Prioridad del MVP

Endpoints y operaciones prioritarias:

1. Auth
2. Perfil
3. Competencias
4. Idiomas
5. Estimación salarial
6. Compatibilidad laboral
7. Valor de proyecto
8. Historial
