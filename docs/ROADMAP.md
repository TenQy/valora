# ROADMAP.md

# Roadmap de Desarrollo - Valora

## Descripción general

Este roadmap define las fases principales de desarrollo de Valora.

El proyecto se desarrollará de forma incremental, comenzando por las funcionalidades esenciales del MVP y posteriormente incorporando características complementarias y despliegue final.

La primera versión prioriza la funcionalidad sobre la complejidad técnica, permitiendo validar el concepto antes de expandir el sistema.

---

# MVP

Las siguientes funcionalidades forman parte del producto mínimo viable:

* Splash Screen
* Pantalla de Bienvenida
* Registro e Inicio de Sesión
* Login con Google
* Perfil Profesional
* Competencias
* Idiomas
* Estimación Salarial
* Compatibilidad Laboral
* Dashboard
* Historial

---

# Funcionalidades posteriores

Las siguientes características se desarrollarán después del MVP:

* Certificaciones
* Proyectos
* Valor de Proyecto

---

# Entrega final

La entrega final incluirá:

* Landing pública
* Flutter Web
* APK descargable
* Despliegue
* Presentación del proyecto

---

# Fase 1 - Diseño UI/UX

## Objetivo

Definir la experiencia visual y navegación de la aplicación.

## Actividades

* Diseñar identidad visual
* Definir paleta de colores
* Definir componentes reutilizables
* Diseñar pantallas principales
* Diseñar flujo de navegación
* Crear prototipos visuales

## Resultado esperado

Diseño base aprobado para desarrollo.

---

# Fase 2 - Base de Datos y Seeds

## Objetivo

Construir la estructura principal de datos del sistema.

## Actividades

* Crear tablas principales
* Crear relaciones
* Configurar Supabase
* Implementar RLS
* Crear seeds iniciales
* Poblar áreas profesionales
* Poblar competencias
* Poblar idiomas
* Poblar roles laborales

## Resultado esperado

Base de datos funcional y lista para integrarse con Flutter.

---

# Fase 3 - Autenticación

## Objetivo

Permitir acceso seguro a la aplicación.

## Actividades

* Configurar Supabase Auth
* Implementar login
* Implementar registro
* Implementar recuperación de contraseña
* Implementar Google OAuth
* Implementar persistencia de sesión

## Resultado esperado

Usuarios autenticados correctamente.

---

# Fase 4 - Perfil Profesional

## Objetivo

Permitir que el usuario registre información profesional.

## Actividades

* Crear pantalla Perfil
* Crear pantalla Editar Perfil
* Registrar información general
* Registrar competencias
* Registrar idiomas
* Mostrar perfil profesional
* Actualizar información

## Resultado esperado

Perfil profesional funcional y persistente.

---

# Fase 5 - Estimación Salarial

## Objetivo

Generar una estimación salarial basada en el perfil del usuario.

## Actividades

* Diseñar lógica de estimación
* Crear Edge Function
* Procesar competencias
* Procesar idiomas
* Procesar experiencia
* Guardar resultados

## Resultado esperado

Estimación salarial funcional.

---

# Fase 6 - Compatibilidad Laboral

## Objetivo

Identificar roles laborales compatibles con el perfil del usuario.

## Actividades

* Diseñar lógica de compatibilidad
* Comparar competencias
* Comparar experiencia
* Comparar área profesional
* Calcular porcentaje de compatibilidad
* Generar recomendaciones

## Resultado esperado

Resultados de compatibilidad funcionales.

---

# Fase 7 - Dashboard e Historial

## Objetivo

Centralizar la información principal del usuario.

## Actividades

* Crear Dashboard
* Mostrar salario estimado
* Mostrar compatibilidad principal
* Mostrar perfil completado
* Mostrar recomendaciones rápidas
* Implementar historial de resultados

## Resultado esperado

Dashboard funcional conectado al resto del sistema.

---

# Fase 8 - Certificaciones

## Objetivo

Permitir registrar certificaciones profesionales.

## Actividades

* Crear módulo de certificaciones
* Registrar certificaciones
* Editar certificaciones
* Eliminar certificaciones
* Integrar certificaciones al perfil

## Resultado esperado

Gestión de certificaciones funcional.

---

# Fase 9 - Proyectos

## Objetivo

Permitir registrar proyectos profesionales.

## Actividades

* Crear módulo de proyectos
* Registrar proyectos
* Editar proyectos
* Eliminar proyectos
* Asociar competencias a proyectos

## Resultado esperado

Gestión de proyectos funcional.

---

# Fase 10 - Valor de Proyecto

## Objetivo

Estimar el valor aproximado de proyectos profesionales.

## Actividades

* Crear formulario de valoración
* Crear Edge Function
* Evaluar complejidad
* Evaluar competencias utilizadas
* Evaluar tiempo estimado
* Generar valoración

## Resultado esperado

Valoración de proyectos funcional.

---

# Fase 11 - Landing

## Objetivo

Crear una página pública para presentar Valora.

## Actividades

* Crear landing en React
* Explicar funcionalidades
* Mostrar beneficios
* Mostrar flujo de uso
* Crear acceso a Flutter Web
* Crear acceso a descarga APK

## Resultado esperado

Landing pública funcional.

---

# Fase 12 - Flutter Web

## Objetivo

Adaptar la aplicación para navegador.

## Actividades

* Configurar Flutter Web
* Ajustar navegación
* Ajustar diseño responsive
* Realizar pruebas funcionales
* Optimizar rendimiento básico

## Resultado esperado

Aplicación funcional desde navegador.

---

# Fase 13 - Deploy y Presentación

## Objetivo

Publicar el proyecto y preparar la presentación final.

## Actividades

* Configurar AWS EC2
* Configurar Nginx
* Desplegar landing
* Desplegar Flutter Web
* Publicar APK
* Realizar pruebas finales
* Preparar demostración

## Resultado esperado

Proyecto desplegado y listo para presentación.

---

# Prioridades

## Prioridad Alta

* Auth
* Perfil
* Competencias
* Idiomas
* Estimación salarial
* Compatibilidad laboral
* Dashboard
* Historial

## Prioridad Media

* Certificaciones
* Proyectos
* Valor de Proyecto

## Prioridad Baja

* Mejoras visuales
* Optimizaciones
* Integraciones externas
* Dominio personalizado

---

# Mejoras Futuras

* Integración con plataformas de empleo
* Notificaciones de vacantes
* Comparaciones históricas
* Recomendaciones avanzadas
* IA para análisis profesional
* Evidencias de certificaciones
* Reglas especializadas por área profesional
