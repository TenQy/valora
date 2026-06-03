# UI_GUIDELINES.md — Valora

> Documento de referencia visual para el proyecto Valora. Diseñado para ser consumido por agentes (Codex, Claude Code) y desarrolladores al implementar componentes en Flutter, Flutter Web y React + Tailwind.

---

## 1. Identidad visual

**Nombre:** Valora  
**Concepto:** Plataforma profesional que revela el valor real de una persona en el mercado laboral.  
**Tono visual:** Serio, confiable, moderno. Sin playfulness. Sin colores brillantes decorativos.  
**Plataforma principal:** Mobile-first (Flutter). También Flutter Web y landing en React + Tailwind.

### Principios de diseño

- **Jerarquía antes que decoración.** Cada elemento existe para comunicar algo, no para llenar espacio.
- **El verde tiene significado.** Solo aparece cuando hay un dato de valor económico o de compatibilidad. No es un color decorativo.
- **Capas de profundidad.** Los fondos oscuros no son un solo negro. Son capas que crean sensación de profundidad.
- **Tipografía como jerarquía.** Los números importantes usan serif. El resto usa sans-serif. Nunca al revés.

---

## 2. Paleta de colores

Todos los colores deben estar centralizados en un único archivo `app_colors.dart` en Flutter y en `tailwind.config.js` en la landing. **Nunca usar hex directamente en widgets o componentes.**

### Fondos

| Token | Valor | Uso |
|---|---|---|
| `bgBase` | `#080808` | AppBar, BottomNav — la capa más profunda |
| `bgPage` | `#0d0d0d` | Fondo general de la app |
| `bgSurface` | `#141414` | Cards, paneles, sidebars |
| `bgElevated` | `#1a1a1a` | Dropdowns, modales, tooltips |
| `bgInput` | `#0f0f0f` | Campos de texto, áreas de código |

> **Regla:** AppBar y BottomNav usan `bgBase`. El contenido usa `bgPage`. Las cards usan `bgSurface`. Nunca usar el mismo fondo para nav y contenido.

### Texto

| Token | Valor | Uso |
|---|---|---|
| `textPrimary` | `#f5f5f5` | Títulos, valores numéricos importantes, nombres |
| `textSecondary` | `#c8c8c8` | Cuerpo de texto, descripciones, subtítulos |
| `textMuted` | `#666666` | Labels, metadata, fechas, hints |
| `textPlaceholder` | `#3a3a3a` | Placeholder en inputs |

### Bordes

| Token | Valor | Uso |
|---|---|---|
| `borderSubtle` | `#1a1a1a` | Separadores internos, divisores de cards |
| `borderDefault` | `#2a2a2a` | Bordes de cards e inputs en reposo |
| `borderStrong` | `#555555` | Input con foco, elemento seleccionado |

### Plata — UI primaria

| Token | Valor | Uso |
|---|---|---|
| `silver` | `#e8e8e8` | Botón primario, step activo, nav indicator |
| `silverHover` | `#ffffff` | Estado hover/pressed del botón primario |
| `silverMuted` | `#9a9a9a` | Botón secundario, labels activos de nav, tags de demanda |
| `silverSubtle` | `rgba(232,232,232,0.07)` | Fondo de chips neutros, fila en hover |

### Verde — accent semántico

| Token | Valor | Uso |
|---|---|---|
| `green` | `#4ade80` | Salario estimado, porcentaje de match, boost económico |
| `greenMuted` | `#2ecc6e` | Símbolo `$`, valores verdes secundarios |
| `greenDim` | `rgba(74,222,128,0.12)` | Fondo de badges de match y salario |
| `greenBorder` | `rgba(74,222,128,0.22)` | Borde de badges verdes |

### Feedback del sistema

| Token | Valor | Uso |
|---|---|---|
| `colorSuccess` | `#4ade80` | Confirmación, perfil completo (mismo que `green`) |
| `colorError` | `#ef4444` | Error de validación, campo requerido |
| `colorWarning` | `#eab308` | Perfil incompleto, alerta |
| `colorInfo` | `#3b82f6` | Tips, sugerencias, notificaciones neutras |

---

## 3. Uso correcto del color verde

El verde es el color más importante de Valora. Su poder viene de usarlo con restricción. Si aparece en todos lados, deja de significar algo.

### ✅ Verde SÍ — datos de valor económico y compatibilidad

- Salario estimado: `$74,000`, `$28,000 – $40,000 MXN`
- Boost por idiomas o certificaciones: `+$8,400`
- Potencial máximo: `$92k`
- Porcentaje de match con un puesto: `92%`, `85%`
- Barra de progreso de compatibilidad laboral
- Dot del logo en AppBar (guiño semántico a la marca)

### ❌ Verde NO — métricas, scores y texto general

- Índice técnico (`83/100`) → usar `textPrimary`
- Portfolio score (`71/100`) → usar `textPrimary`
- Labels de demanda ("Alta demanda", "Muy valorado") → usar `silverMuted`
- Nombres de competencias → usar `silverMuted` o `textSecondary`
- Barras de nivel de skills → usar gradiente plata (`silverMuted` → `silver`)
- Títulos de sección → usar `textPrimary`
- Texto descriptivo o de cuerpo → usar `textSecondary`

### Regla de oro

> El verde responde a la pregunta: **¿esto representa dinero o compatibilidad directa con un empleo?** Si la respuesta es sí, puede ser verde. Si no, no lo es.

---

## 4. Tipografía

### Fuentes

| Fuente | Rol | Google Fonts |
|---|---|---|
| `Cormorant Garamond` | Display / números grandes | Sí |
| `Inter` | Body, labels, botones, UI general | Sí |
| `JetBrains Mono` | Datos técnicos, porcentajes, hex, skills | Sí |

> En Flutter, importar las tres fuentes en `pubspec.yaml`. En la landing, importar desde Google Fonts en `index.html` o via `@import` en CSS.

### Escala tipográfica

| Uso | Fuente | Tamaño | Weight | Color token |
|---|---|---|---|---|
| Salario principal (`$74,000`) | Cormorant Garamond | 52px | 300 | `green` |
| Scores grandes (`83/100`, `$92k`) | Cormorant Garamond | 28px | 300 | `textPrimary` o `green` (ver regla §3) |
| Título de pantalla (H1) | Cormorant Garamond | 28–32px | 300 | `textPrimary` |
| Nombre del usuario | Inter | 16px | 400 | `textSecondary` |
| Subtítulo / descripción | Inter | 14px | 300 | `textSecondary` |
| Label de sección | Inter | 11px | 400 | `textMuted` · UPPERCASE · letter-spacing 0.2em |
| Texto de cuerpo | Inter | 13–14px | 300 | `textSecondary` |
| Botón primario | Inter | 14px | 500 | `#080808` (sobre fondo plata) |
| Nombre de skill/competencia | JetBrains Mono | 12px | 400 | `silverMuted` |
| Porcentaje de match | JetBrains Mono | 12px | 500 | `green` |
| Placeholder de input | Inter | 14px | 300 | `textPlaceholder` |
| Hint / metadata | Inter | 11px | 300 | `textMuted` |

### Reglas tipográficas

- `Cormorant Garamond` **solo** para números destacados y H1. No usarlo en párrafos ni labels.
- Nunca usar tamaños adyacentes juntos (ej. 13px y 14px en la misma card). Saltar al menos 2px entre niveles.
- `letter-spacing: 0.2em` en labels uppercase para que respiren.
- Line-height recomendado: `1.6` para cuerpo, `1.2` para títulos grandes.

---

## 5. Espaciado y bordes

### Sistema de espaciado (múltiplos de 4)

| Token | Valor | Uso típico |
|---|---|---|
| `space4` | 4px | Gap entre elementos muy pequeños (dot + texto) |
| `space8` | 8px | Gap entre chips, padding interno de badges |
| `space12` | 12px | Gap entre elementos dentro de una card |
| `space16` | 16px | Padding interno de cards pequeñas, gap entre cards |
| `space20` | 20px | Padding estándar de cards |
| `space24` | 24px | Padding horizontal de pantalla en mobile |
| `space28` | 28px | Padding interno de cards grandes / salary card |
| `space32` | 32px | Padding de secciones |
| `space48` | 48px | Separación entre secciones |

> **Padding horizontal global en mobile:** `24px` a cada lado. Nunca menos de `20px`.

### Border radius

| Token | Valor | Uso |
|---|---|---|
| `radiusXS` | 4px | Botones primarios, badges rectangulares |
| `radiusSM` | 6px | Inputs, chips de competencias |
| `radiusMD` | 10px | Cards pequeñas, score items |
| `radiusLG` | 14px | Cards principales, salary card |
| `radiusXL` | 20px | Badges pill, chips de idioma |
| `radiusFull` | 999px | Avatares, indicadores circulares |

### Bordes

- Cards en reposo: `1px solid borderDefault (#2a2a2a)`
- Input en reposo: `1px solid borderDefault (#2a2a2a)`
- Input con foco: `1px solid borderStrong (#555555)`
- Badge verde: `1px solid greenBorder (rgba(74,222,128,0.22))`
- Badge plata: `1px solid borderDefault (#2a2a2a)`

### Sombras

Las sombras deben ser sutiles y oscuras, nunca coloreadas.

```
cardShadow:    0 20px 60px rgba(0,0,0,0.5)
elevatedShadow: 0 32px 80px rgba(0,0,0,0.6)
greenGlow:     0 0 12px rgba(74,222,128,0.35)   /* solo en thumb de barra salarial */
```

---

## 6. Componentes principales

### 6.1 Botones

#### Primario (plata)
Acción principal de cada pantalla. Navegar, confirmar, continuar.

```dart
// Flutter
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.silver,       // #e8e8e8
    foregroundColor: AppColors.bgBase,       // #080808
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    textStyle: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.06 * 14),
  ),
  child: Text('Continuar'),
)
```

#### Secundario (outline)
Acción alternativa. Cancelar, volver, ver más.

```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    foregroundColor: AppColors.silverMuted,
    side: BorderSide(color: AppColors.borderDefault),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 13),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  child: Text('Cancelar'),
)
```

#### Ghost
Acción terciaria. Links, "ver detalles", acciones destructivas suaves.

```dart
TextButton(
  style: TextButton.styleFrom(
    foregroundColor: AppColors.textMuted,
  ),
  child: Text('Ver más', style: TextStyle(decoration: TextDecoration.underline)),
)
```

#### Verde (accent — solo para CTA de resultados)
Únicamente en el botón principal de la pantalla de Resultados o Valor de Proyecto.

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.greenDim,
    foregroundColor: AppColors.green,
    side: BorderSide(color: AppColors.greenBorder),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  child: Text('Ver estimación salarial'),
)
// NOTA: este botón verde es la excepción, no la regla.
// Solo en pantallas donde el resultado principal ES el salario.
```

---

### 6.2 Inputs

```dart
TextField(
  style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter', fontSize: 14),
  decoration: InputDecoration(
    hintText: 'Correo electrónico',
    hintStyle: TextStyle(color: AppColors.textPlaceholder),
    filled: true,
    fillColor: AppColors.bgInput,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.borderDefault),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.borderDefault),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.borderStrong),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: AppColors.colorError),
    ),
  ),
)
```

---

### 6.3 Cards

#### Card base (surface)

```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.bgSurface,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: AppColors.borderDefault),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 60, offset: Offset(0, 20))],
  ),
  padding: EdgeInsets.all(24),
  child: Column(...),
)
```

> No usar el widget `Card` nativo de Flutter directamente. Usar `Container` con decoración personalizada para tener control total sobre color, radio y borde.

#### Card de resultado / salary card

Igual que card base pero con padding `28px` y un radial gradient sutil en la esquina superior derecha:

```dart
decoration: BoxDecoration(
  color: AppColors.bgSurface,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: AppColors.borderDefault),
  // El glow verde se logra con un Stack + Positioned con un Container
  // con gradiente radial rgba(74,222,128,0.04) en la esquina
),
```

---

### 6.4 Badges

#### Badge verde (match, salario, boost)

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: AppColors.greenDim,
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: AppColors.greenBorder),
  ),
  child: Text(
    '92% match',
    style: TextStyle(
      fontFamily: 'JetBrains Mono',
      fontSize: 11,
      color: AppColors.green,
      letterSpacing: 0.04 * 11,
    ),
  ),
)
```

#### Badge plata (categorías, estado, nivel)

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  decoration: BoxDecoration(
    color: AppColors.silverSubtle,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.borderDefault),
  ),
  child: Text(
    'Senior',
    style: TextStyle(
      fontFamily: 'Inter',
      fontSize: 11,
      color: AppColors.silverMuted,
      letterSpacing: 0.1 * 11,
    ),
  ),
)
```

---

### 6.5 Chips de competencias

Los chips representan competencias, herramientas o tecnologías del usuario.

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: AppColors.silverSubtle,
    borderRadius: BorderRadius.circular(6),
    border: Border.all(color: AppColors.borderDefault),
  ),
  child: Text(
    'React',
    style: TextStyle(
      fontFamily: 'JetBrains Mono',
      fontSize: 12,
      color: AppColors.silverMuted,
    ),
  ),
)
```

**Chips de idioma** — variante con bandera y nivel:

```dart
// Misma estructura pero color ligeramente diferente para distinguirlos
// border: Border.all(color: AppColors.borderStrong)
// Ejemplo: "🇺🇸 English · B2"
```

---

### 6.6 Cards de resultados (puestos compatibles)

Cada puesto compatible se muestra en una row dentro de una card:

```
[Logo empresa]  [Título del puesto]     [Badge match %]
                [Empresa · Modalidad]   [Rango salarial]
```

- Match ≥ 80%: badge verde (`green` + `greenDim` + `greenBorder`)
- Match < 80%: badge plata (`silverMuted` + `silverSubtle` + `borderDefault`)
- Rango salarial: `textMuted`, fuente `JetBrains Mono`, 11px

---

### 6.7 Indicadores de porcentaje / barras

#### Barra de compatibilidad / match

```dart
// Track
Container(
  height: 3,
  decoration: BoxDecoration(
    color: AppColors.borderSubtle,
    borderRadius: BorderRadius.circular(2),
  ),
  child: FractionallySizedBox(
    alignment: Alignment.centerLeft,
    widthFactor: 0.92, // porcentaje
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x4D4ade80), AppColors.green], // greenDim → green
        ),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  ),
)
```

#### Barra de nivel de skill (desglose)

Misma estructura pero con gradiente plata:

```dart
gradient: LinearGradient(
  colors: [AppColors.silverSubtle, AppColors.silverMuted],
)
// No usar verde aquí. El nivel de una skill no es un dato monetario.
```

#### Score item (cuadrícula 2x2 en Resultados)

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: AppColors.bgInput,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.borderSubtle),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Índice técnico', style: labelStyle),      // Inter 10px UPPERCASE textMuted
      Text('83/100', style: scoreStyleSilver),        // Cormorant 26px textPrimary
      Text('Top 22% del rol', style: hintStyle),      // Inter 11px textMuted
    ],
  ),
)
// Score en verde SOLO si es dato de dinero: "+$8.4k", "$92k potencial"
// Score en textPrimary si es métrica: "83/100", "71/100"
```

---

### 6.8 Navbar / Bottom Navigation

```dart
BottomNavigationBar(
  backgroundColor: AppColors.bgBase,      // #080808 — más oscuro que bgPage
  selectedItemColor: AppColors.silverMuted,
  unselectedItemColor: Color(0xFF333333),
  selectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 10, letterSpacing: 0.06),
  unselectedLabelStyle: TextStyle(fontFamily: 'Inter', fontSize: 10),
  type: BottomNavigationBarType.fixed,
  items: [
    BottomNavigationBarItem(icon: ..., label: 'Inicio'),
    BottomNavigationBarItem(icon: ..., label: 'Perfil'),
    BottomNavigationBarItem(icon: ..., label: 'Resultados'),
    BottomNavigationBarItem(icon: ..., label: 'Proyectos'),
  ],
)
```

**Indicador de tab activo:** punto circular plata (`silver`, 4px) debajo del ícono activo. No usar underline ni cambio de color de fondo de tab.

**AppBar:**

```dart
AppBar(
  backgroundColor: AppColors.bgBase,
  elevation: 0,
  titleTextStyle: TextStyle(
    fontFamily: 'Cormorant Garamond',
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  ),
  // Logo: nombre "Valora" + dot verde de 6px a la izquierda
)
```

---

## 7. Guía por pantalla

### 7.1 Splash Screen

- Fondo: `bgBase` (`#080808`)
- Logo centrado: nombre "Valora" en Cormorant Garamond 32px `textPrimary`
- Dot verde junto al logo (guiño semántico)
- Indicador de carga: CircularProgressIndicator con color `silverMuted`, strokeWidth 1
- Sin texto adicional
- Duración mínima: 1.5s aunque la sesión cargue antes (evitar flash)

---

### 7.2 Pantalla de Bienvenida

- Fondo: `bgPage`
- Logo + tagline en la mitad superior
- Tagline: Cormorant Garamond italic, 22px, `textSecondary`
- Descripción breve: Inter 14px, `textMuted`, centrado, max 2 líneas
- Botón "Crear cuenta": primario plata, ancho completo
- Botón "Iniciar sesión": secundario outline, ancho completo
- Botón "Continuar con Google": outline con ícono Google, `borderDefault`, texto `textSecondary`
- Espaciado entre botones: `space12`
- Los tres botones al fondo de la pantalla con padding bottom de `space32`

---

### 7.3 Auth — Login y Registro

- Fondo: `bgPage`
- Título de pantalla: Cormorant Garamond 28px `textPrimary` ("Bienvenido de nuevo" / "Crea tu cuenta")
- Subtítulo: Inter 13px `textMuted`
- Inputs: ver §6.2
- Mensajes de error: Inter 12px `colorError`, aparecen debajo del input con `space4` de margen
- Enlace "¿Olvidaste tu contraseña?": Inter 12px `textMuted`, alineado a la derecha del input de contraseña
- Botón principal: primario plata, ancho completo
- Separador "o": línea `borderDefault` a ambos lados, texto Inter 12px `textMuted`
- Botón Google: outline con ícono, ancho completo
- Toggle Login/Registro: Inter 13px `textMuted`, enlace activo en `silver`

---

### 7.4 Dashboard

- Fondo: `bgPage`
- AppBar con saludo: "Hola, [Nombre]" — Inter 14px `textMuted` + nombre en `textPrimary`
- **Bloque de valor profesional** (card principal):
  - Fondo `bgSurface`, radio `radiusLG`
  - Eyebrow: Inter 11px UPPERCASE `textMuted`
  - Valor estimado central: Cormorant Garamond 44px `green`
  - Subtexto: Inter 12px `textMuted`
- **Bloque de compatibilidad principal**: card con el puesto de mayor match. Badge verde con el porcentaje.
- **Porcentaje de perfil completado**: barra de progreso plata. Si < 60%: mostrar badge warning `colorWarning`.
- **Resumen de competencias**: chips `JetBrains Mono` en `silverSubtle`
- **Recomendaciones rápidas**: máx. 2 cards pequeñas con ícono + texto corto. Ícono en `silverMuted`.
- **Historial reciente**: lista compacta de últimos 3 resultados. Fecha en `textMuted`, tipo en `textSecondary`, valor en `green` si es salarial.

---

### 7.5 Perfil

- Fondo: `bgPage`
- Header: nombre en Inter 18px `textPrimary`, área profesional en Inter 13px `textMuted`
- Nivel profesional + años de experiencia como badges plata
- Bio: Inter 13px `textSecondary`, máx. 3 líneas con "ver más"
- Secciones con label uppercase `textMuted`: COMPETENCIAS, IDIOMAS, CERTIFICACIONES, PROYECTOS
- Separador entre secciones: `borderSubtle`
- Botón "Editar perfil": secundario outline, alineado arriba a la derecha del header
- Competencias como chips `JetBrains Mono`
- Idiomas como chips con nivel (ej. "🇺🇸 English · B2"), borde `borderStrong`
- Proyectos como cards pequeñas con título + stack de competencias usadas

---

### 7.6 Editar Perfil

- Fondo: `bgPage`
- Formulario en secciones separadas por `space32`
- Cada sección con label uppercase `textMuted` como encabezado
- Inputs: ver §6.2
- Selectores (área profesional, nivel): mismo estilo que input con ícono de flecha en `textMuted`
- Agregar competencias: campo de búsqueda + chips resultantes. Al seleccionar, el chip aparece en el área de competencias activas con ícono de eliminar.
- Agregar idioma: selector de idioma + selector de nivel. Aparece como chip con bandera.
- Certificaciones: lista expandible. Cada certificación como card pequeña con nombre, institución y fechas.
- Proyectos: lista con botón "Agregar proyecto" al final. Cada proyecto como card editable.
- Botón "Guardar cambios": primario plata, fijo en el fondo de la pantalla (FAB-style o sticky footer)
- No usar FAB flotante verde para guardar — reservar el verde para datos de valor.

---

### 7.7 Resultados

Esta es la pantalla más importante de Valora. El verde aparece aquí con mayor presencia que en cualquier otra pantalla — pero siempre justificado.

#### Bloque de salario estimado
- Card principal con `bgSurface` y glow verde sutil en esquina
- Eyebrow: Inter 11px UPPERCASE `textMuted`
- Nombre + rol: Inter 15px `textSecondary`
- Valor central: Cormorant Garamond 52px `green` — este es el número más importante de la app
- Símbolo `$`: Cormorant Garamond 28px `greenMuted`
- Label "Valor central estimado · [moneda]": Inter 11px UPPERCASE `textMuted`
- Barra de rango: gradiente `greenDim → green`, thumb con `greenGlow`
- Labels mín/máx: JetBrains Mono 11px `textMuted`

#### Score grid (2x2)
- Índice técnico: Cormorant 26px `textPrimary` — NO verde
- Boost por idiomas (`+$8.4k`): Cormorant 26px `green` — SÍ verde (es dinero)
- Portfolio score: Cormorant 26px `textPrimary` — NO verde
- Potencial máximo (`$92k`): Cormorant 26px `green` — SÍ verde (es dinero)

#### Compatibilidad laboral
- Lista de puestos compatibles: ver §6.6
- Match ≥ 80%: badge verde
- Match < 80%: badge plata
- Competencias coincidentes: chips verdes `greenDim`
- Competencias faltantes: chips con borde `colorWarning`, texto `colorWarning`

#### Recomendaciones
- Cards pequeñas con sugerencia de competencia o acción
- Sin verde — son sugerencias, no datos de valor confirmado
- Ícono en `silverMuted`, texto en `textSecondary`

---

### 7.8 Valor de Proyecto

- Fondo: `bgPage`
- Formulario multi-paso o sección larga con scroll
- Mismas reglas de inputs que §6.2
- Selectores de tipo de proyecto, complejidad y plataformas: styled dropdowns
- **Resultado:**
  - Mismo patrón visual que salary card pero con título diferente
  - Rango de precio: Cormorant Garamond 48px `green`
  - Nivel de complejidad: badge plata
  - Factores influyentes: lista con ícono `silverMuted` + texto `textSecondary`
  - Advertencia "resultado orientativo": Inter 11px `textMuted`, fondo `bgElevated`, borde `borderDefault`

---

## 8. Reglas para Flutter

### 8.1 Archivo de colores centralizado

Crear `lib/core/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Fondos
  static const Color bgBase      = Color(0xFF080808);
  static const Color bgPage      = Color(0xFF0D0D0D);
  static const Color bgSurface   = Color(0xFF141414);
  static const Color bgElevated  = Color(0xFF1A1A1A);
  static const Color bgInput     = Color(0xFF0F0F0F);

  // Texto
  static const Color textPrimary     = Color(0xFFF5F5F5);
  static const Color textSecondary   = Color(0xFFC8C8C8);
  static const Color textMuted       = Color(0xFF666666);
  static const Color textPlaceholder = Color(0xFF3A3A3A);

  // Bordes
  static const Color borderSubtle  = Color(0xFF1A1A1A);
  static const Color borderDefault = Color(0xFF2A2A2A);
  static const Color borderStrong  = Color(0xFF555555);

  // Plata
  static const Color silver        = Color(0xFFE8E8E8);
  static const Color silverHover   = Color(0xFFFFFFFF);
  static const Color silverMuted   = Color(0xFF9A9A9A);
  static const Color silverSubtle  = Color(0x12E8E8E8); // rgba(232,232,232,0.07)

  // Verde
  static const Color green         = Color(0xFF4ADE80);
  static const Color greenMuted    = Color(0xFF2ECC6E);
  static const Color greenDim      = Color(0x1F4ADE80); // rgba(74,222,128,0.12)
  static const Color greenBorder   = Color(0x384ADE80); // rgba(74,222,128,0.22)

  // Feedback
  static const Color colorSuccess  = Color(0xFF4ADE80);
  static const Color colorError    = Color(0xFFEF4444);
  static const Color colorWarning  = Color(0xFFEAB308);
  static const Color colorInfo     = Color(0xFF3B82F6);
}
```

### 8.2 ThemeData centralizado

Crear `lib/core/theme/app_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgPage,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bgBase,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Cormorant Garamond',
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: AppColors.silverMuted),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgBase,
      selectedItemColor: AppColors.silverMuted,
      unselectedItemColor: Color(0xFF333333),
      elevation: 0,
    ),
    colorScheme: ColorScheme.dark(
      surface: AppColors.bgSurface,
      primary: AppColors.silver,
      secondary: AppColors.green,
      error: AppColors.colorError,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgInput,
      hintStyle: TextStyle(color: AppColors.textPlaceholder, fontFamily: 'Inter'),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: AppColors.borderDefault),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: AppColors.borderDefault),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: AppColors.borderStrong),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: AppColors.colorError),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: 'Cormorant Garamond', fontWeight: FontWeight.w300, color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300, color: AppColors.textSecondary),
      bodyMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300, color: AppColors.textSecondary),
      labelSmall: TextStyle(fontFamily: 'Inter', color: AppColors.textMuted, letterSpacing: 2.8),
    ),
    fontFamily: 'Inter',
  );
}
```

### 8.3 Widgets reutilizables recomendados

Crear en `lib/shared/widgets/`:

```
app_card.dart          → Container con bgSurface + border + radius
salary_display.dart    → Número grande Cormorant + label + barra de rango
match_badge.dart       → Badge verde/plata según porcentaje
skill_chip.dart        → Chip JetBrains Mono con opción de eliminar
language_chip.dart     → Chip con bandera + nivel
score_item.dart        → Cuadro 1/4 del grid de scores (label + valor + sub)
section_label.dart     → Label uppercase Inter 11px textMuted
job_row.dart           → Fila de puesto compatible con logo + match + salario
progress_bar.dart      → Barra reutilizable con soporte verde y plata
result_card.dart       → Card de resultado con eyebrow + título + contenido
```

### 8.4 Reglas de implementación

- **Nunca** escribir un color hex directamente en un widget. Siempre `AppColors.tokenName`.
- **Nunca** usar el widget `Card` nativo. Usar `Container` con `BoxDecoration`.
- **Nunca** usar `Colors.white`, `Colors.black`, `Colors.grey`. Siempre tokens de `AppColors`.
- **Nunca** hardcodear `fontSize`, `fontFamily` o `fontWeight` fuera del theme o de una constante de estilo nombrada.
- Definir estilos de texto reutilizables en `lib/core/theme/app_text_styles.dart`.
- Todo el padding de pantalla debe usar `space24` (24px horizontal).

---

## 9. Reglas para landing React + Tailwind

### 9.1 Configuración de Tailwind

En `tailwind.config.js`, extender los colores con los tokens de Valora:

```js
module.exports = {
  theme: {
    extend: {
      colors: {
        'bg-base':     '#080808',
        'bg-page':     '#0d0d0d',
        'bg-surface':  '#141414',
        'bg-elevated': '#1a1a1a',
        'bg-input':    '#0f0f0f',
        'text-primary':     '#f5f5f5',
        'text-secondary':   '#c8c8c8',
        'text-muted':       '#666666',
        'border-subtle':    '#1a1a1a',
        'border-default':   '#2a2a2a',
        'border-strong':    '#555555',
        'silver':           '#e8e8e8',
        'silver-muted':     '#9a9a9a',
        'green-accent':     '#4ade80',
        'green-muted':      '#2ecc6e',
      },
      fontFamily: {
        serif:  ['Cormorant Garamond', 'Georgia', 'serif'],
        sans:   ['Inter', 'system-ui', 'sans-serif'],
        mono:   ['JetBrains Mono', 'monospace'],
      },
    },
  },
}
```

### 9.2 Clases de uso frecuente

```html
<!-- Card base -->
<div class="bg-bg-surface border border-border-default rounded-[14px] p-6">

<!-- Título grande con serif -->
<h1 class="font-serif font-light text-5xl text-text-primary">

<!-- Label de sección -->
<p class="font-sans text-[11px] uppercase tracking-[0.2em] text-text-muted">

<!-- Salario en verde -->
<span class="font-serif font-light text-[52px] text-green-accent">

<!-- Badge verde -->
<span class="bg-[rgba(74,222,128,0.12)] border border-[rgba(74,222,128,0.22)] text-green-accent font-mono text-[11px] px-2 py-1 rounded">

<!-- Botón primario plata -->
<button class="bg-silver text-bg-base font-sans font-medium text-sm tracking-wide px-6 py-3 rounded">

<!-- Input -->
<input class="bg-bg-input border border-border-default focus:border-border-strong rounded-md px-4 py-3 text-text-secondary text-sm outline-none w-full">
```

### 9.3 Reglas landing

- La landing puede ser ligeramente más expresiva que la app (más espacio, textos más grandes) pero debe compartir los mismos tokens de color.
- El hero debe mostrar la salary card del mockup como elemento visual central — es el producto principal.
- Evitar animaciones complejas. Máximo: fade-in suave al hacer scroll y la animación de float en la card demo.

---

## 10. Buenas prácticas visuales

- **Capas de fondo:** AppBar y BottomNav siempre en `bgBase`. El contenido siempre en `bgPage`. Las cards siempre en `bgSurface`. Esta jerarquía de capas no debe romperse.
- **Respira entre secciones:** mínimo `space32` entre bloques distintos de contenido.
- **Verde con propósito:** antes de poner algo en verde, preguntarse "¿esto representa dinero o compatibilidad directa?" Si no, usar plata o texto.
- **Cormorant solo en números destacados:** nunca en párrafos, labels, botones ni texto de interfaz.
- **JetBrains Mono solo en datos técnicos:** porcentajes, nombres de skills, valores numéricos tipo código. No en texto corriente.
- **Bordes casi invisibles en reposo:** `borderDefault` (#2a2a2a) es muy sutil. No compensar añadiendo más borde o más color — eso es parte del diseño.
- **Consistencia en border-radius:** no mezclar radios sin razón. Botones son `radiusXS (4px)`. Cards son `radiusLG (14px)`. Chips son `radiusSM (6px)` o `radiusXL (20px)` para pills.

---

## 11. Errores a evitar

| ❌ Error | ✅ Corrección |
|---|---|
| Usar verde en índice técnico o portfolio score | Usar `textPrimary` — no es dato monetario |
| Usar verde en labels de demanda ("Alta demanda") | Usar `silverMuted` — es métrica de mercado, no dinero |
| Usar el widget `Card` nativo de Flutter | Usar `Container` con `BoxDecoration` personalizado |
| Hardcodear `Color(0xFF4ADE80)` en un widget | Usar `AppColors.green` |
| Poner `Cormorant Garamond` en texto de cuerpo | Reservar serif solo para números grandes y H1 |
| AppBar con el mismo fondo que el contenido | AppBar siempre en `bgBase`, contenido en `bgPage` |
| Dos tamaños de fuente muy cercanos (13px y 14px) | Saltar al menos 2px entre niveles jerárquicos |
| Badge verde en etiquetas de estado general | Verde solo para match % y valores monetarios |
| Usar sombras de color (ej. sombra verde) | Solo `greenGlow` en el thumb de la barra salarial |
| FAB verde para guardar cambios | Botón primario plata sticky al fondo — el verde no es de acción |
| Más de 3 colores distintos visibles en una sola card | Máximo: negro/superficie + plata + verde. Nunca los tres a full intensidad |
| Verde en pantallas que no son Resultados o Dashboard | El verde debe aparecer principalmente en resultados y datos del Dashboard |

---

## Apéndice — Árbol de archivos sugerido (Flutter)

```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart
│       ├── app_theme.dart
│       └── app_text_styles.dart
├── shared/
│   └── widgets/
│       ├── app_card.dart
│       ├── salary_display.dart
│       ├── match_badge.dart
│       ├── skill_chip.dart
│       ├── language_chip.dart
│       ├── score_item.dart
│       ├── section_label.dart
│       ├── job_row.dart
│       ├── progress_bar.dart
│       └── result_card.dart
└── features/
    ├── auth/
    ├── dashboard/
    ├── profile/
    ├── results/
    └── project_value/
```

---
