# Historial de Cambios

Todos los cambios notables en este proyecto se documentarán en este archivo.

## [1.1.0+1782867387] - 2026-06-30

### 🛠️ SDK y Dependencias

- **Android SDK actualizado**: Kotlin 2.0.0, Java 17, AGP 8.6.0, Gradle 8.7
- `flutter_markdown` (discontinuado) reemplazado por `flutter_markdown_plus`
- `google_mobile_ads` removido (código no utilizado)
- SDK constraint en `pubspec.yaml` actualizado a `>=3.10.0-0`

### 🐛 Correcciones

- Pull-to-refresh ahora fuerza recarga de datos (no devolvía caché)
- Hero animations ahora funcionan correctamente entre listas y detalle
- Diálogo de carga reemplazado por SnackBar loading para mejor UX
- `defaultColor` ahora persiste correctamente al reiniciar la app
- Errores silenciados de `_launchUrl` ahora muestran feedback al usuario

### ⚡ Performance

- `NetworkImage` reemplazado por `CachedNetworkImage` en toda la app (caché de imágenes)
- `MainApp.stateSet()` anti-patrón reemplazado por `ValueNotifier<ThemeMode>`
- `withOpacity()` migrado a `.withValues(alpha:)` (43 ocurrencias)

### 📱 UI/UX

- Skeletons de carga mejorados con indicadores más claros
- Estados de error ahora muestran el mensaje real de la excepción
- Migración de `RadioListTile` a `RadioGroup` (nueva API Flutter 3.32+)

### 🔧 Calidad de Código

- `analysis_options.yaml` con strict-casts, strict-inference, strict-raw-types
- 5 imports sin uso eliminados
- Variables `final` donde aplica
- `catch` clauses tipadas con `on Exception`
- `flutter analyze` — **0 issues**

---

## [1.0.0+1760752330] - 2025-10-17

### 🎨 Refactorización completa de UI/UX

- **HomePage**, **TabNewsPage**, **NewsCard**, **FavoritePage** y **SettingsPage** completamente rediseñadas.
- Se añadieron **animaciones profesionales** y transiciones suaves en toda la app.
- Diseño **moderno, limpio y consistente**, con enfoque en la experiencia del usuario.

### 🏗️ Arquitectura mejorada

- Implementación del **patrón Singleton** en los servicios.
- **Sistema de caché** optimizado para mejorar el rendimiento general.
- Nuevo manejo de errores más **robusto y seguro** en toda la aplicación.

### 🚀 Nuevas funcionalidades

- **Pull to refresh** para recargar noticias fácilmente.
- **Swipe to delete** en secciones interactivas.
- **Hero animations** entre pantallas para una navegación más fluida.
- Nueva **página “Acerca de”** con información del proyecto.
- Estados de **carga y error mejorados** con indicadores visuales más claros.

### ⚡ Optimización de performance

- **Carga paralela de servicios** para mejorar la velocidad de inicio.
- **Caché persistente** de noticias y detalles para una experiencia más rápida.
- Uso del **Singleton pattern en Dio** para reducir instancias y mejorar eficiencia.

---

## [0.4.3+1728097348] - 2024-10-04

### Añadido

- **Lectura de Archivos Markdown**: Se agregó la funcionalidad para leer los archivos de **Términos y Condiciones** y **Política de Privacidad** directamente desde la aplicación.
- **Nuevas Opciones**: Se incorporaron dos nuevas opciones en la sección de información:
  - Enlace al **Repositorio** del proyecto en GitHub.
  - Opción para **Donar** y apoyar el desarrollo continuo de la app.

## [0.4.2] - 2024-09-20

### Añadido

- **Anuncios**: Agregado un banner de anuncios en la pantalla de inicio para recaudar fondos y apoyar el desarrollo continuo de la app.

## [0.3.0] - 2024-08-26

### Añadido

- **Nuevo Canal de Noticias**: Ahora puedes acceder al contenido del Periódico El Hoy, proporcionando una fuente adicional de información actualizada.

### Mejorado

- **Eliminación de Dependencia**: Se ha removido el paquete WebView para optimizar el rendimiento y reducir el tamaño de la aplicación.
- **Optimización general**: Se han implementado diversas mejoras bajo el capó para optimizar el rendimiento y la estabilidad de la aplicación.

## [0.2.0] - 2024-08-16

### Mejorado

- Se ha reemplazado el WebView con una nueva y mejorada pantalla para leer los detalles de las noticias.

### Corregido

- Corrección de errores ortográficos.

## [0.1.0] - 2024-08-09

### Añadido

- **Modo Oscuro**: Implementación del modo oscuro para una mejor experiencia de lectura en condiciones de baja luz.
- **Notificaciones Push**: Integración de notificaciones push para alertar a los usuarios sobre las últimas noticias y actualizaciones importantes.
- **Nuevo Diseño de Interfaz**: Actualización del diseño de la interfaz para una navegación más intuitiva y amigable.

### Mejorado

- **Velocidad de Carga**: Mejora en la velocidad de carga de artículos y noticias.
- **Accesibilidad**: Mejoras en la accesibilidad para usuarios con necesidades especiales, incluyendo soporte para lectores de pantalla.

### Corregido

- **Error en el Guardado de Favoritos**: Solucionado un problema donde algunos artículos no se guardaban correctamente en la sección de favoritos.
- **Problemas de Compatibilidad**: Resolución de problemas de compatibilidad con dispositivos Android más antiguos.

### Notas

- Esta versión incluye mejoras importantes en la experiencia del usuario y la estabilidad de la aplicación. Se recomienda a todos los usuarios que actualicen a la última versión para disfrutar de las nuevas funcionalidades y mejoras.
