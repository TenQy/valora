# Plan de Tareas Pre-Despliegue

Este documento detalla las tareas a realizar antes de generar el APK final y desplegar el proyecto. 

## Tareas 

### 1. Actualización de Documentación y Stack 
- [x] Actualizar `AGENTS.md` y `ROADMAP.md` para reflejar el uso de Astro (Landing) y Vercel (Despliegue).
- [x] Crear este archivo `docs/PRE_DEPLOY_TASKS.md`.

### 2. Onboarding y Tutorial para Nuevos Usuarios 
- [x] Diseñar y programar una pantalla introductoria para nuevos usuarios (`tutorial_screen.dart`).
- [x] Exigir un llenado mínimo de datos (Área, un par de competencias) antes de habilitar el botón de "Calcular Valor".

### 3. Mejora de UX en Selección de Áreas y Competencias 
- [ ] Ajustar la UX para que al seleccionar un Área Laboral (ej. Medicina), los selectores de competencias y herramientas se filtren o prioricen automáticamente.

### 4. Overhaul Visual y Diseño Premium 
- [ ] Mejorar la calidad visual general del diseño (`core/theme/` y `shared/widgets/`).
- [ ] Implementar micro-animaciones, mejores sombras, degradados sutiles y consistencia absoluta.

### 5. Robustez de API y Manejo de Errores 
- [ ] Implementar timeouts en llamadas a Supabase Edge Functions.
- [ ] Agregar fallbacks y un manejo de errores robusto y amigable para el usuario.
- [ ] Añadir feedback visual claro (loaders consistentes).

### 6. Poblado Total de la Base de Datos 
- [ ] Generar scripts SQL para las áreas laborales restantes.
- [ ] Generar las competencias asociadas a cada área.
- [ ] Insertar en Supabase.

### 7. QA y Pruebas Generales
- [ ] Recorrido completo de la aplicación evaluando cada función.
- [ ] Registrar en un documento temporal bugs o mejoras identificadas.
