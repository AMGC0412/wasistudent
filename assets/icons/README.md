# WasiStudent

Plataforma de alquiler de cuartos verificada para estudiantes, egresados y trabajadores en Cusco.

## Contexto del proyecto

Esto surge por la experiencia de buscar alojamiento en Cusco y encontrarse con que las fotos no coinciden, los precios cambian sin aviso y casi nunca hay un contrato de por medio. La idea es simple: que el inquilino sepa lo que va a encontrar y que el dueño tenga un respaldo legal sin tanto papeleo.

Por ahora estamos en fase de prototipo, construyendo la interfaz y probando el flujo de usuario.

## Propuesta base

- **Verificación in situ**: Ir a los lugares para tomar fotos reales y evaluar condiciones básicas (ventilación, espacio, etc.).
- **Contrato digital**: Con validez legal (Código Civil y Ley 30201) para evitar que te suban el precio o te pidan salir de golpe.
- **Reputación bidireccional**: Se califican tanto el propietario como el inquilino, para que no sea necesario pedir un garante tradicional.

## Stack técnico (MVP)

- **Frontend (UI/Prototipo)**: Flutter.
- **Backend (Planificado)**: Node.js / Python + PostgreSQL (con Supabase).
- **IA/NLP (Planificado)**: OpenAI GPT-4o-mini para asistir en el match entre oferta y demanda.
- **APIs (Planificadas)**: WhatsApp Business API, Google Maps y APIs peruanas (DNI/SUNARP).

## Equipo

- Adriel Mithuar Guevara Cusi
- Will Edson Mayta Ttito

---

## Notas técnicas del desarrollo (Mockup)

**Estado actual**  
El mockup usa mapa visual estático dibujado con CustomPaint (ver `lib/screens/explore_map_screen.dart`). No requiere pins PNG ni API key de ningún proveedor de mapas.

**Cuándo migrar a un mapa real**  
Cuando se quiera tener un mapa real con calles, navegación, etc., se puede integrar cualquier proveedor:

**Opción 1: Google Maps**  
Agregar `google_maps_flutter: ^2.6.1` al `pubspec.yaml`.  
Reemplazar el widget `_MapCanvas` por `GoogleMap(...)`.  
Configurar API key en:  
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

**Opción 2: Mapbox**  
Agregar `mapbox_gl: ^0.16.0` al `pubspec.yaml`.  
Similar setup con API key de Mapbox.

**Opción 3: OpenStreetMap (gratis)**  
Agregar `flutter_map: ^6.0.0` al `pubspec.yaml`.  
No requiere API key (usa tiles de OpenStreetMap públicos).

**Generar pins personalizados (opcional)**  
Si se quieren pins con el precio dibujado encima:

```dart
// Usar canvas personalizado + convertir a BitmapDescriptor
// Ver: https://pub.dev/packages/google_maps_flutter#custom-markers
```
