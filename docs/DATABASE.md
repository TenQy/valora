# DATABASE.md

# Base de Datos de Valora

## Descripción general

Valora utilizará una base de datos relacional en Supabase PostgreSQL.

La base de datos almacenará información relacionada con usuarios, perfiles profesionales, áreas laborales, competencias, certificaciones, idiomas, proyectos, estimaciones salariales, compatibilidad laboral y valoración de proyectos.

El sistema estará conectado con Supabase Auth, por lo que la autenticación de usuarios será gestionada mediante correo, contraseña y login con Google.

Cada usuario tendrá un perfil profesional asociado a su cuenta autenticada.

---

# Objetivo de la base de datos

La base de datos tiene como objetivo permitir que Valora pueda:

* Registrar usuarios autenticados.
* Almacenar perfiles profesionales.
* Relacionar usuarios con áreas profesionales.
* Registrar competencias por usuario.
* Registrar certificaciones.
* Registrar idiomas y niveles.
* Registrar proyectos profesionales.
* Guardar resultados de estimaciones salariales.
* Guardar resultados de compatibilidad laboral.
* Guardar valoraciones de proyectos.
* Mantener catálogos base mediante seeds.

---

# Relación con Supabase Auth

Supabase Auth manejará la autenticación de usuarios.

La tabla `profiles` estará relacionada con `auth.users`.

Cada usuario autenticado tendrá un registro asociado en `profiles`.

Relación general:

```txt
auth.users
   │
   └── profiles
```

---

# Tablas principales

## 1. profiles

Almacena la información principal del perfil profesional del usuario.

### Campos sugeridos

```txt
id
user_id
full_name
professional_area_id
career
professional_level
years_experience
bio
created_at
updated_at
```

### Descripción de campos

| Campo                | Descripción                       |
| -------------------- | --------------------------------- |
| id                   | Identificador interno del perfil  |
| user_id              | Relación con Supabase Auth        |
| full_name            | Nombre del usuario                |
| professional_area_id | Área profesional seleccionada     |
| career               | Carrera, profesión o especialidad |
| professional_level   | Nivel profesional del usuario     |
| years_experience     | Años de experiencia, opcional     |
| bio                  | Descripción breve del perfil      |
| created_at           | Fecha de creación                 |
| updated_at           | Fecha de última actualización     |

### Niveles profesionales sugeridos

* Estudiante
* Practicante
* Junior
* Semi Senior
* Senior
* Especialista

---

## 2. professional_areas

Catálogo de áreas profesionales disponibles en la aplicación.

Esta tabla será poblada mediante seeds.

### Campos sugeridos

```txt
id
name
description
is_active
created_at
```

### Seeds iniciales

* Tecnología
* Diseño
* Marketing
* Administración
* Finanzas
* Arquitectura
* Ingenierías
* Salud
* Educación
* Derecho

---

## 3. competencies

Catálogo de competencias disponibles.

Una competencia representa conocimientos, herramientas, habilidades, metodologías o especialidades profesionales que pueden aplicar a una o varias áreas.

Las competencias no pertenecen directamente a una sola área profesional, ya que algunas pueden ser útiles en distintos perfiles.

Ejemplos:

* Figma puede aplicar a Diseño, Tecnología y Marketing.
* Excel puede aplicar a Finanzas, Administración, Marketing e Ingenierías.
* Python puede aplicar a Tecnología, Finanzas, Ingeniería y Ciencia de Datos.

### Campos sugeridos

```txt
id
name
description
category
is_active
created_at
```

### Ejemplos

#### Tecnología

* Flutter
* React
* Python
* Node.js
* PostgreSQL
* Docker

#### Diseño

* Figma
* Adobe Illustrator
* Branding
* UX/UI

#### Marketing

* SEO
* Google Ads
* Meta Ads
* Copywriting

#### Derecho

* Derecho mercantil
* Contratos
* Litigación
* Propiedad intelectual

---

## 4. competency_areas

Relaciona competencias con una o varias áreas profesionales.

Esta tabla permite que una misma competencia pueda aparecer en distintas áreas sin duplicar registros.

### Campos sugeridos

```txt
id
competency_id
professional_area_id
created_at
```

### Ejemplos

Figma -> Diseño
Figma -> Tecnología
Figma -> Marketing

Excel -> Administración
Excel -> Finanzas
Excel -> Marketing
Excel -> Ingenierías

Python -> Tecnología
Python -> Finanzas
Python -> Ingenierías

### Objetivo 

Permitir perfiles profesionales híbridos y evitar que las competencias queden limitadas a una sola área.

---

## 5. user_competencies

Relaciona usuarios con competencias seleccionadas.

### Campos sugeridos

```txt
id
profile_id
competency_id
level
created_at
updated_at
```

### Nivel de competencia

El campo `level` permitirá indicar el dominio del usuario sobre una competencia.

Valores sugeridos:

* Básico
* Intermedio
* Avanzado

### Nota

El nivel de competencia servirá como referencia general. No se evaluará de la misma forma en todas las áreas profesionales.

Por ejemplo, una competencia técnica como `JavaScript` puede medirse de forma más directa que una competencia profesional como `Contratos` o `Gestión hospitalaria`.

---

## 6. certifications

Almacena certificaciones registradas por los usuarios.

A diferencia de las competencias, las certificaciones representan validaciones externas emitidas por instituciones, empresas u organismos.

### Campos sugeridos

```txt
id
profile_id
name
issuer
issue_date
credential_url
created_at
updated_at
```

### Descripción de campos

| Campo          | Descripción                       |
| -------------- | --------------------------------- |
| id             | Identificador de la certificación |
| profile_id     | Perfil al que pertenece           |
| name           | Nombre de la certificación        |
| issuer         | Institución o empresa emisora     |
| issue_date     | Fecha de obtención                |
| credential_url | Enlace opcional a la credencial   |
| created_at     | Fecha de creación                 |
| updated_at     | Fecha de última actualización     |

### Nota

En la primera versión no se almacenarán archivos PDF de certificaciones para evitar mayor complejidad y uso de almacenamiento.

Como mejora futura, se podrá permitir la carga de archivos o evidencias.

---

## 7. languages

Catálogo de idiomas disponibles.

Esta tabla será poblada mediante seeds.

### Campos sugeridos

```txt
id
name
is_active
created_at
```

### Seeds iniciales

* Español
* Inglés
* Francés
* Alemán
* Portugués
* Italiano
* Japonés
* Coreano
* Chino mandarín

---

## 8. language_levels

Catálogo de niveles de idioma.

Esta tabla será poblada mediante seeds.

### Campos sugeridos

```txt
id
name
description
created_at
```

### Seeds iniciales

* A1
* A2
* B1
* B2
* C1
* C2
* Nativo

---

## 9. user_languages

Relaciona usuarios con idiomas y niveles.

### Campos sugeridos

```txt
id
profile_id
language_id
language_level_id
created_at
updated_at
```

---

## 10. projects

Almacena proyectos registrados por los usuarios.

Los proyectos serán opcionales y podrán estar disponibles principalmente para áreas donde los entregables profesionales se puedan medir con mayor claridad.

### Campos sugeridos

```txt
id
profile_id
professional_area_id
name
description
project_type
complexity
estimated_time
platforms
created_at
updated_at
```

### Áreas donde aplica principalmente

* Tecnología
* Diseño
* Marketing
* Arquitectura
* Ingenierías

### Nota

Para áreas como Salud, Educación, Derecho, Finanzas o Administración, los proyectos podrán ocultarse, adaptarse o dejarse como mejora futura.

---

## 11. project_competencies

Relaciona proyectos con competencias utilizadas.

Esto permite que una competencia pueda influir en el valor profesional del usuario aunque no esté registrada directamente como competencia principal del perfil.

### Campos sugeridos

```txt
id
project_id
competency_id
created_at
```

### Ejemplo

Un usuario puede registrar un proyecto donde utilizó `Tailwind CSS`, aunque no lo haya agregado directamente como competencia principal.

Esto ayuda a representar mejor lo que el usuario ha aplicado en proyectos reales.

---

## 12. job_roles

Catálogo de roles laborales disponibles.

Esta tabla será poblada mediante seeds para evitar que los usuarios creen roles no evaluables por el sistema.

### Campos sugeridos

```txt
id
professional_area_id
name
description
min_salary
max_salary
currency
is_active
created_at
```

### Ejemplos por área

#### Tecnología

* Desarrollador Frontend
* Desarrollador Backend
* Desarrollador Full Stack
* Analista de Datos
* Administrador de Bases de Datos
* Especialista en Redes
* QA Tester

#### Diseño

* Diseñador UX/UI
* Diseñador Gráfico
* Diseñador de Marca
* Ilustrador Digital

#### Marketing

* Especialista SEO
* Community Manager
* Analista de Marketing Digital
* Copywriter

#### Finanzas

* Analista Financiero
* Auxiliar Contable
* Asesor Financiero

#### Derecho

* Abogado Corporativo
* Abogado Mercantil
* Auxiliar Jurídico

---

# Tablas de resultados

## 13. salary_estimations

Guarda los resultados de estimaciones salariales generadas por el usuario.

### Campos sugeridos

```txt
id
profile_id
professional_area_id
estimated_min_salary
estimated_max_salary
currency
professional_level
summary
created_at
```

### Nota

La primera versión guardará únicamente el resultado final de la estimación, no un snapshot completo del perfil.

Esto permite mantener la base de datos más simple.

---

## 14. job_matches

Guarda resultados de compatibilidad laboral.

### Campos sugeridos

```txt
id
profile_id
job_role_id
match_percentage
estimated_min_salary
estimated_max_salary
currency
matched_competencies
missing_competencies
summary
created_at
```

### Descripción

Esta tabla permitirá mostrar puestos compatibles con el usuario, junto con el porcentaje de compatibilidad y un rango salarial estimado.

### Ejemplo

```txt
Desarrollador Frontend
Compatibilidad: 85%
Salario estimado: $25,000 - $35,000 MXN
```

---

## 15. project_estimations

Guarda resultados de valoración de proyectos.

### Campos sugeridos

```txt
id
project_id
profile_id
estimated_min_value
estimated_max_value
currency
complexity_result
summary
recommendations
created_at
```

### Descripción

Esta tabla almacena el resultado generado al estimar el valor aproximado de un proyecto.

La valoración de proyectos estará enfocada principalmente en Tecnología y podrá expandirse posteriormente a otras áreas compatibles.

---

# Seeds iniciales

Las seeds son datos predefinidos que se insertan en la base de datos antes de que los usuarios utilicen la aplicación.

## Seeds necesarias

### professional_areas

* Tecnología
* Diseño
* Marketing
* Administración
* Finanzas
* Arquitectura
* Ingenierías
* Salud
* Educación
* Derecho

### competencies

Competencias base disponibles en el sistema.

Las competencias no pertenecen directamente a una sola área profesional. Una competencia puede relacionarse con una o varias áreas mediante la tabla `competency_areas`.

Ejemplos:

#### Competencias técnicas

* Flutter
* React
* Angular
* Vue
* Python
* Java
* C#
* Node.js
* TypeScript
* PostgreSQL
* Docker
* Git

#### Competencias de diseño

* Figma
* Adobe Illustrator
* Adobe Photoshop
* Branding
* UX/UI
* Diseño editorial

#### Competencias de marketing

* SEO
* Google Ads
* Meta Ads
* Copywriting
* Email Marketing
* Analítica digital

### competency_areas

Relaciones entre competencias y áreas profesionales.

Esta seed permite definir en qué áreas puede aparecer o utilizarse una competencia.

Ejemplos:

```txt
Flutter -> Tecnología

React -> Tecnología

Python -> Tecnología
Python -> Finanzas
Python -> Ingenierías

Figma -> Diseño
Figma -> Tecnología
Figma -> Marketing

Excel -> Administración
Excel -> Finanzas
Excel -> Marketing
Excel -> Ingenierías

Adobe Illustrator -> Diseño
Adobe Illustrator -> Marketing
```

### job_roles

Roles laborales base por área profesional.

Ejemplos:

#### Tecnología

* Desarrollador Frontend
* Desarrollador Backend
* Desarrollador Full Stack
* QA Tester
* Analista de Datos
* Administrador de Bases de Datos
* Especialista en Redes

#### Diseño

* Diseñador UX/UI
* Diseñador Gráfico
* Diseñador de Marca

#### Marketing

* Especialista SEO
* Community Manager
* Analista de Marketing Digital

### project_types

Tipos de proyecto para áreas compatibles.

Ejemplos:

#### Tecnología

* Aplicación móvil
* Sitio web
* API
* Sistema administrativo
* Dashboard
* Aplicación web
* Sistema con base de datos

#### Diseño

* Identidad visual
* Diseño de interfaz
* Diseño editorial
* Branding

#### Marketing

* Campaña publicitaria
* Estrategia de contenido
* Campaña SEO
* Campaña en redes sociales

---

# Relaciones principales

## Usuario y perfil

```txt
auth.users 1 ─── 1 profiles
```

Cada usuario autenticado tendrá un perfil profesional.

## Perfil y área profesional

```txt
professional_areas 1 ─── N profiles
```

Cada perfil pertenece a un área profesional.

## Competencias y áreas profesionales

```txt
competencies 1 ─── N competency_areas
professional_areas 1 ─── N competency_areas
```

## Perfil y competencias

```txt
profiles 1 ─── N user_competencies
competencies 1 ─── N user_competencies
```

Un usuario puede tener muchas competencias y una competencia puede pertenecer a muchos usuarios.

## Perfil y certificaciones

```txt
profiles 1 ─── N certifications
```

Un usuario puede registrar varias certificaciones.

## Perfil e idiomas

```txt
profiles 1 ─── N user_languages
languages 1 ─── N user_languages
language_levels 1 ─── N user_languages
```

Un usuario puede registrar varios idiomas con su respectivo nivel.

## Perfil y proyectos

```txt
profiles 1 ─── N projects
```

Un usuario puede registrar varios proyectos.

## Proyectos y competencias

```txt
projects 1 ─── N project_competencies
competencies 1 ─── N project_competencies
```

Un proyecto puede estar relacionado con varias competencias.

## Perfil y estimaciones salariales

```txt
profiles 1 ─── N salary_estimations
```

Un usuario puede tener varias estimaciones salariales guardadas como historial.

## Perfil y compatibilidad laboral

```txt
profiles 1 ─── N job_matches
job_roles 1 ─── N job_matches
```

Un usuario puede tener varios resultados de compatibilidad laboral.

## Proyecto y valoración

```txt
projects 1 ─── N project_estimations
profiles 1 ─── N project_estimations
```

Un proyecto puede tener varias valoraciones guardadas como historial.

---

# Reglas de seguridad

La base de datos usará Row Level Security en Supabase.

## Reglas generales

* Cada usuario solo podrá ver su propio perfil.
* Cada usuario solo podrá editar su propio perfil.
* Cada usuario solo podrá ver, crear, editar o eliminar sus competencias registradas.
* Cada usuario solo podrá ver, crear, editar o eliminar sus certificaciones.
* Cada usuario solo podrá ver, crear, editar o eliminar sus idiomas.
* Cada usuario solo podrá ver, crear, editar o eliminar sus proyectos.
* Cada usuario solo podrá ver sus propias estimaciones.
* Los catálogos base podrán ser consultados por usuarios autenticados.
* Los catálogos base no podrán ser modificados por usuarios normales.

## Tablas protegidas por usuario

* profiles
* user_competencies
* certifications
* user_languages
* projects
* project_competencies
* salary_estimations
* job_matches
* project_estimations

## Tablas de solo lectura para usuarios normales

* professional_areas
* competencies
* languages
* language_levels
* job_roles

---

# Notas para implementación en Supabase

## Uso de UUID

Se recomienda usar UUID como identificador principal en las tablas principales.

## Fechas

Se recomienda utilizar:

```txt
created_at
updated_at
```

en tablas editables.

## Catálogos

Los catálogos deben poblarse mediante seeds.

Esto evita que los usuarios creen áreas, competencias o roles no evaluables por el sistema.

## Certificaciones

En la primera versión, las certificaciones se registrarán como texto.

No se almacenarán archivos PDF para evitar complejidad adicional y uso innecesario de almacenamiento.

## Historial

El historial guardará únicamente resultados finales.

No se guardarán snapshots completos del perfil en la primera versión.

## Expansión futura

La base de datos podrá ampliarse posteriormente para incluir:

* Evidencias de certificaciones.
* Integración con plataformas de empleo.
* Vacantes reales.
* Comparaciones históricas avanzadas.
* Reglas de estimación más específicas por área profesional.
* Catálogos más completos por área.
