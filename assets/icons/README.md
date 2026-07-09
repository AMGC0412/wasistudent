# WasiStudent

Alquilar un cuarto en Cusco es un dolor de cabeza. Y no lo digo por los precios, sino porque te topas con fotos que no son, contratos que no existen y dueños que suben el precio porque sí. Eso es lo que queremos arreglar con esto.

## ¿Qué está pasando aquí?

La mayoría de alquileres se hacen de palabra. Luego vienen los problemas: te piden que te vayas de un día para otro o te suben el alquiler sin aviso. Además, las páginas de clasificados están llenas de anuncios falsos; ya varios conocidos han perdido entre 150 y 800 soles por depósitos que nunca devolvieron. Y ni hablar de los cuartos: algunos parecen armarios, sin ventanas, y eso afecta a cualquiera que quiera estudiar o trabajar tranquilo.

## Nuestra idea

Queremos que puedas buscar un lugar **viendo fotos reales** (vamos al sitio a verificarlas) y con un **contrato digital** que sí tenga validez legal (amparado en el Código Civil y la Ley 30201). Además, tanto el que alquila como el que arrienda podrán calificarse mutuamente, para que no te pidan un garante que no tienes.

## Estado actual del código (MVP)

Esto recién empieza. Por ahora estamos armando el prototipo visual:

- **Frontend (lo que ves)**: Flutter.
- **Backend (lo que mueve los datos)**: estamos viendo si va con Node o Python, pero la base de datos será PostgreSQL con Supabase.
- **Extras planeados**: queremos meterle un poquito de IA (con OpenAI) para que ayude a hacer match entre lo que buscas y lo que ofrecen, y conectar con WhatsApp y Google Maps cuando esté más avanzado.

## Sobre el mapa que ves en el mockup

Por ahora, el mapa no es real. Está dibujado con `CustomPaint` dentro de Flutter, así que no necesitas ninguna API key de Google ni de nadie para que se vea. Es solo una maqueta estática.

Cuando queramos poner un mapa de verdad, tenemos varias opciones:
- **Google Maps**: la clásica, pero toca poner la API key en el manifest de Android y en el HTML de web.
- **Mapbox**: similar a Google, con su propia key.
- **OpenStreetMap (Flutter Map)**: si no queremos gastar ni un sol en API keys, esta opción es totalmente gratuita y funciona bien.

Por ahora, con el dibujo estático nos sirve para mostrar la interfaz.

## Equipo

- Adriel Mithuar Guevara Cusi
- Will Edson Mayta Ttito

Estado actual
El mockup usa mapa visual estático dibujado con CustomPaint(ver lib/screens/explore_map_screen.dart). No requiere pins PNG niAPI key de ningún proveedor de mapas.

Cuándo migrar a un mapa real
Cuando se quiera tener un mapa real con calles, navegación, etc., sepuede integrar cualquier proveedor:

Opción 1: Google Maps
Agregar google_maps_flutter: ^2.6.1 al pubspec.yaml.
Reemplazar el widget _MapCanvas por GoogleMap(...).
Configurar API key en:
Android: android/app/src/main/AndroidManifest.xml
<meta-data    android:name="com.google.android.geo.API_KEY"    android:value="TU_API_KEY" />
Web: web/index.html antes de </head>
<script src="https://maps.googleapis.com/maps/api/js?key=TU_API_KEY"></script>
Opción 2: Mapbox
Agregar mapbox_gl: ^0.16.0 al pubspec.yaml.
Similar setup con API key de Mapbox.
Opción 3: OpenStreetMap (gratis)
Agregar flutter_map: ^6.0.0 al pubspec.yaml.
No requiere API key (usa tiles de OpenStreetMap públicos).
Generar pins personalizados (opcional)
Si se quieren pins con el precio dibujado encima:

// Usar canvas personalizado + convertir a BitmapDescriptor// Ver: https://pub.dev/packages/google_maps_flutter#custom-markers
