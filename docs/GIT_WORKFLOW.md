# GIT_WORKFLOW.md

# Flujo de Trabajo Git - Valora

## Objetivo

Mantener el proyecto organizado y evitar conflictos durante el desarrollo.

---

# Herramientas

* GitHub
* GitHub Desktop

---

# Ramas

## Rama principal

```txt
main
```

Contiene la versión estable del proyecto.

No se debe trabajar directamente en esta rama.

---

## Ramas de trabajo

Cada desarrollador trabajará en su propia rama.

Ejemplos:

```txt
feature/auth
feature/profile
feature/dashboard
feature/results
feature/project-value
```

---

# Flujo de trabajo

## 1. Actualizar proyecto

Antes de comenzar a trabajar:

```txt
Fetch Origin
Pull Origin
```

desde GitHub Desktop.

---

## 2. Crear rama

Crear una rama para la funcionalidad que se va a desarrollar.

Ejemplo:

```txt
feature/auth
```

---

## 3. Realizar cambios

Desarrollar la funcionalidad asignada.

---

## 4. Realizar commit

Utilizar mensajes claros y descriptivos.

Ejemplos:

```txt
feat: crear login
feat: agregar dashboard
fix: corregir validacion
docs: actualizar roadmap
```

---

## 5. Publicar rama

Enviar cambios al repositorio.

```txt
Push Origin
```

---

## 6. Crear Pull Request

Cuando la funcionalidad esté terminada.

---

# Convención de commits

## feat

Nueva funcionalidad.

Ejemplo:

```txt
feat: crear pantalla perfil
```

---

## fix

Corrección de errores.

Ejemplo:

```txt
fix: corregir login google
```

---

## docs

Cambios en documentación.

Ejemplo:

```txt
docs: actualizar database
```

---

## refactor

Mejoras internas sin cambiar funcionalidad.

Ejemplo:

```txt
refactor: reorganizar auth
```

---

## style

Cambios visuales o de formato.

Ejemplo:

```txt
style: mejorar dashboard
```

---

## chore

Configuración o mantenimiento.

Ejemplo:

```txt
chore: actualizar dependencias
```

---

# Reglas

* No trabajar directamente en `main`.
* Mantener ramas pequeñas y enfocadas en una sola funcionalidad.
* Utilizar commits descriptivos.
* Actualizar la rama antes de comenzar a trabajar.
* Crear Pull Request antes de integrar cambios.
