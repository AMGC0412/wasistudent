# Assets de WasiStudent

Esta carpeta contiene íconos e imágenes personalizadas de la app.

## Estado actual

El mockup usa **mapa visual estático** dibujado con `CustomPaint`
(ver `lib/screens/explore_map_screen.dart`). No requiere pins PNG ni
API key de ningún proveedor de mapas.

## Cuándo migrar a un mapa real

Cuando se quiera tener un mapa real con calles, navegación, etc., se
puede integrar cualquier proveedor:

### Opción 1: Google Maps
- Agregar `google_maps_flutter: ^2.6.1` al `pubspec.yaml`.
- Reemplazar el widget `_MapCanvas` por `GoogleMap(...)`.
- Configurar API key en:
  - Android: `android/app/src/main/AndroidManifest.xml`
    ```xml
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="TU_API_KEY" />
    ```
  - Web: `web/index.html` antes de `</head>`
    ```html
    <script src="https://maps.googleapis.com/maps/api/js?key=TU_API_KEY"></script>
    ```

### Opción 2: Mapbox
- Agregar `mapbox_gl: ^0.16.0` al `pubspec.yaml`.
- Similar setup con API key de Mapbox.

### Opción 3: OpenStreetMap (gratis)
- Agregar `flutter_map: ^6.0.0` al `pubspec.yaml`.
- No requiere API key (usa tiles de OpenStreetMap públicos).

## Generar pins personalizados (opcional)

Si se quieren pins con el precio dibujado encima:

```dart
// Usar canvas personalizado + convertir a BitmapDescriptor
// Ver: https://pub.dev/packages/google_maps_flutter#custom-markers
```

