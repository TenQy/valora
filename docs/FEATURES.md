# FEATURES.md

# Funcionalidades de Valora

## Descripción general

Valora es una plataforma mobile-first diseñada para estimar el valor profesional de una persona dentro del mercado laboral. La aplicación permite analizar información como área profesional, competencias, experiencia, idiomas, proyectos y perfil general del usuario para generar resultados orientativos sobre salario estimado, compatibilidad laboral y recomendaciones de mejora.

Aunque Valora será presentada como una plataforma general para distintas áreas profesionales, la primera versión tendrá mayor profundidad en áreas donde las competencias son más fáciles de medir mediante herramientas, tecnologías, experiencia y entregables, como Tecnología, Diseño, Marketing, Arquitectura e Ingenierías.

La arquitectura del sistema permitirá agregar nuevas áreas profesionales en el futuro sin rehacer completamente la estructura principal de la aplicación.

---

## Áreas profesionales consideradas

La aplicación contempla inicialmente las siguientes áreas:

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

En la primera versión, el análisis más completo se realizará para Tecnología. Las demás áreas funcionarán mediante catálogos, competencias generales y reglas base para demostrar la capacidad de expansión de la plataforma.

---

## Concepto de competencias

Para evitar limitar el sistema únicamente al área tecnológica, Valora utilizará el concepto de **competencias** como elemento principal para representar conocimientos, herramientas, habilidades y especialidades profesionales.

Una competencia representa aquello que una persona sabe utilizar, conoce o es capaz de desempeñar dentro de su área profesional.

Las competencias podrán incluir:

* Lenguajes de programación
* Frameworks
* Herramientas profesionales
* Conocimientos técnicos
* Habilidades laborales
* Metodologías
* Especialidades de un área

Ejemplos:

### Tecnología

* Flutter
* React
* Python
* Docker
* PostgreSQL

### Diseño

* Figma
* Adobe Illustrator
* Branding
* UX/UI

### Marketing

* SEO
* Google Ads
* Meta Ads
* Copywriting

### Derecho

* Derecho Mercantil
* Litigación
* Contratos
* Propiedad Intelectual

### Salud

* Atención Clínica
* Diagnóstico
* Investigación Médica
* Gestión Hospitalaria

Las certificaciones serán manejadas como una entidad independiente dentro del perfil profesional, ya que representan validaciones externas de conocimientos o competencias adquiridas por el usuario.

---

# Pantallas principales

## 1. Splash Screen

### Función

Mostrar la pantalla inicial de carga de la aplicación mientras se valida el estado de sesión del usuario.

### Contenido

* Logo de Valora
* Nombre de la aplicación
* Indicador de carga
* Revisión de sesión activa

### Comportamiento esperado

* Si el usuario tiene sesión activa, será redirigido al Dashboard.
* Si el usuario no tiene sesión activa, será redirigido a la pantalla de Bienvenida.

---

## 2. Pantalla de Bienvenida

### Función

Presentar brevemente la aplicación antes de que el usuario inicie sesión o se registre.

### Contenido

* Logo de Valora
* Frase principal
* Descripción breve de la aplicación
* Botón para iniciar sesión
* Botón para registrarse
* Opción de iniciar sesión con Google

### Objetivo

Dar contexto al usuario sobre el propósito de Valora antes de acceder al sistema.

---

## 3. Auth Screen

### Función

Permitir la autenticación de usuarios mediante login, registro y acceso con Google.

### Modo Login

Contiene:

* Correo electrónico
* Contraseña
* Recuperación de contraseña
* Login con Google
* Validación de campos
* Mensajes de error

### Modo Registro

Contiene:

* Nombre
* Correo electrónico
* Contraseña
* Confirmación de contraseña
* Registro con Google
* Validación de campos
* Mensajes de error

### Objetivo

Permitir que el usuario cree una cuenta o acceda a una cuenta existente de forma segura.

---

## 4. Dashboard

### Función

Mostrar un resumen general del perfil profesional del usuario y servir como centro principal de navegación.

### Contenido

* Valor profesional estimado
* Compatibilidad laboral principal
* Porcentaje de perfil completado
* Resumen de competencias
* Resumen de proyectos registrados
* Recomendaciones rápidas
* Historial reciente de resultados
* Accesos rápidos a otras secciones

### Comportamiento dinámico

La estructura general del Dashboard será la misma para todos los usuarios, pero algunos bloques podrán adaptarse según el área profesional seleccionada.

Ejemplos:

### Tecnología

* Competencias técnicas principales
* Tecnologías destacadas
* Puestos compatibles relacionados con software

### Diseño

* Herramientas dominadas
* Áreas creativas destacadas
* Tipos de proyectos visuales

### Marketing

* Competencias de marketing dominadas
* Canales o herramientas relevantes
* Posibles roles compatibles

### Objetivo

Permitir que el usuario entienda rápidamente su estado profesional dentro de la plataforma.

---

## 5. Perfil

### Función

Mostrar la información profesional registrada por el usuario.

### Contenido

* Nombre
* Área profesional
* Carrera, profesión o especialidad
* Nivel profesional
* Años de experiencia, si aplica
* Bio corta
* Competencias registradas
* Certificaciones
* Idiomas
* Proyectos registrados
* Resultados recientes

### Acciones

* Editar perfil
* Cerrar sesión

### Objetivo

Permitir que el usuario consulte su información profesional y acceda a la edición de sus datos.

---

## 6. Editar Perfil

### Función

Permitir que el usuario modifique su información profesional.

### Información general

Contiene:

* Área profesional
* Carrera, profesión o especialidad
* Nivel profesional
* Años de experiencia, opcional
* Bio corta

### Nivel profesional

El sistema permitirá seleccionar un nivel profesional para evitar depender únicamente de los años de experiencia.

Opciones sugeridas:

* Estudiante
* Practicante
* Junior
* Semi Senior
* Senior
* Especialista

### Competencias

Contiene:

* Agregar competencias
* Eliminar competencias
* Seleccionar competencias desde catálogos
* Mostrar competencias como badges o listas

### Certificaciones

Contiene:

* Agregar certificaciones
* Editar certificaciones
* Eliminar certificaciones

Datos sugeridos:

* Nombre de la certificación
* Institución emisora
* Fecha de obtención
* Fecha de expiración (opcional)

### Idiomas

Contiene:

* Idioma
* Nivel del idioma

Niveles sugeridos:

* A1
* A2
* B1
* B2
* C1
* C2
* Nativo

### Proyectos

Contiene:

* Agregar proyectos
* Editar proyectos
* Eliminar proyectos
* Asociar competencias o tecnologías utilizadas

### Objetivo

Permitir que el usuario mantenga actualizado su perfil para generar resultados más útiles.

---

## 7. Resultados

### Función

Mostrar el análisis profesional generado a partir del perfil del usuario.

### Salario estimado

Contiene:

* Rango salarial estimado
* Nivel profesional detectado
* Área profesional evaluada
* Factores que influyeron en la estimación
* Competencias más relevantes

### Compatibilidad laboral

Contiene:

* Puestos compatibles
* Porcentaje de compatibilidad
* Rango salarial estimado por puesto
* Competencias que coinciden
* Competencias faltantes

Ejemplo:

* Desarrollador Frontend

  * Compatibilidad: 85%
  * Salario estimado: $25,000 - $35,000 MXN

* Flutter Developer

  * Compatibilidad: 92%
  * Salario estimado: $28,000 - $40,000 MXN

### Recomendaciones

Contiene:

* Competencias sugeridas
* Herramientas recomendadas
* Puestos laborales sugeridos
* Mejoras para aumentar el valor profesional
* Recomendaciones según el área seleccionada

### Visualización

La primera versión mostrará resultados mediante:

* Cards
* Texto descriptivo
* Indicadores de porcentaje
* Secciones organizadas

Las gráficas simples podrán agregarse posteriormente como mejora visual.

### Mejora futura

En versiones posteriores, la aplicación podría integrarse con plataformas de empleo para mostrar vacantes reales compatibles con el perfil del usuario.

Ejemplos:

* LinkedIn
* OCC
* Indeed
* Computrabajo

Esta integración permitiría notificar al usuario cuando se detecten oportunidades laborales relacionadas con su perfil, sin necesidad de revisar manualmente cada plataforma.

---

## 8. Valor de Proyecto

### Función

Calcular un valor aproximado para proyectos profesionales, principalmente en áreas donde los entregables pueden estimarse con mayor claridad.

### Alcance inicial

Esta funcionalidad estará enfocada principalmente en Tecnología.

También podrá aplicarse parcialmente a áreas como:

* Diseño
* Marketing
* Arquitectura
* Ingenierías

Para áreas como Salud, Educación, Derecho, Finanzas o Administración, esta función podrá ocultarse o adaptarse en versiones futuras.

### Formulario

Contiene:

* Tipo de proyecto
* Área profesional
* Complejidad
* Competencias o herramientas utilizadas
* Tiempo estimado
* Plataformas involucradas
* Alcance del proyecto
* Nivel de experiencia requerido

### Resultado

Contiene:

* Rango de precio estimado
* Nivel de complejidad
* Factores que influyeron en el cálculo
* Recomendaciones para mejorar el valor del proyecto
* Advertencia de que el resultado es orientativo

### Ejemplos de proyectos en Tecnología

* Aplicación móvil
* Sitio web
* Sistema administrativo
* API
* Dashboard
* Sistema con base de datos
* Aplicación multiplataforma

### Objetivo

Ayudar al usuario a obtener una referencia inicial sobre el valor económico de un proyecto profesional.

---

# Funcionalidades principales del MVP

## Autenticación

* Registro con correo y contraseña
* Login con correo y contraseña
* Login con Google
* Recuperación de contraseña
* Validaciones básicas
* Manejo de sesión

## Perfil profesional

* Crear perfil
* Editar perfil
* Seleccionar área profesional
* Registrar nivel profesional
* Registrar competencias
* Registrar idiomas
* Registrar proyectos

## Estimación salarial

* Calcular rango salarial aproximado
* Considerar área profesional
* Considerar nivel profesional
* Considerar competencias
* Considerar idiomas
* Considerar experiencia

## Compatibilidad laboral

* Mostrar puestos compatibles
* Mostrar porcentaje de compatibilidad
* Mostrar rango salarial por puesto
* Mostrar competencias coincidentes
* Mostrar competencias faltantes

## Valor de proyecto

* Registrar características de un proyecto
* Calcular rango de valor aproximado
* Mostrar factores influyentes
* Mostrar recomendaciones

## Dashboard

* Mostrar resumen del perfil
* Mostrar valor profesional estimado
* Mostrar compatibilidad principal
* Mostrar perfil completado
* Mostrar recomendaciones rápidas
* Mostrar historial reciente

## Historial

El sistema guardará únicamente los resultados generados.

Tipos de resultados:

* Estimación salarial
* Compatibilidad laboral
* Valoración de proyecto

No se guardarán snapshots completos del perfil en la primera versión para mantener la base de datos más simple.

---

# Funcionalidades futuras

## Integración con plataformas de empleo

La aplicación podría conectarse en el futuro con fuentes externas de vacantes para mostrar oportunidades reales relacionadas con el perfil del usuario.

Posibles plataformas:

* LinkedIn
* OCC
* Indeed
* Computrabajo

Funcionalidades posibles:

* Buscar vacantes compatibles
* Mostrar enlaces a empleos reales
* Enviar notificaciones de oportunidades
* Comparar requisitos de vacantes contra competencias del usuario

## Gráficas avanzadas

* Evolución del valor profesional
* Comparación entre estimaciones
* Competencias más influyentes
* Áreas de mejora

## Recomendaciones con IA

* Análisis más personalizado
* Explicación de resultados
* Sugerencias de rutas de aprendizaje
* Mejora de perfil profesional

## Expansión por área profesional

* Formularios más específicos por área
* Reglas de estimación más precisas
* Catálogos personalizados
* Recomendaciones especializadas

---

# Restricciones de la primera versión

* Los resultados serán orientativos, no definitivos.
* La primera versión tendrá mayor precisión en Tecnología.
* No se implementarán modelos complejos para las 10 áreas desde el inicio.
* Algunas áreas tendrán análisis más general.
* La función de Valor de Proyecto no estará disponible para todas las áreas en la primera versión.
* La integración con plataformas reales de empleo será considerada como mejora futura.
* Las gráficas avanzadas podrán agregarse después del MVP.

---

# Resumen del alcance

Valora permitirá que el usuario cree un perfil profesional, registre sus competencias, idiomas, experiencia y proyectos, y obtenga resultados orientativos sobre su valor profesional, compatibilidad laboral y valor aproximado de proyectos.

La aplicación será presentada como una plataforma general para distintas áreas profesionales, pero su primera versión tendrá mayor profundidad en Tecnología y áreas similares donde las competencias y proyectos pueden evaluarse con mayor claridad.
