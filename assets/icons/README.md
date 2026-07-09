Wasistudent 🏠🎓
Plataforma de alquiler de cuartos verificada para estudiantes, egresados y trabajadores en Cusco.

🎯 El Problema
88% de alquileres se hacen sin contrato escrito (subidas de precio, desalojos).
81% de anuncios en clasificados tienen fotos falsas o engaño (estafas de S/150 - S/840).
Condiciones inhumanas (cuartos 3x3m, sin ventana) que deterioran el rendimiento académico y laboral.
💡 Propuesta de Valor
"Personalizar lo que desees, de acuerdo a tu presupuesto"

Verificación in situ: Fotos reales y rating de habitabilidad.
Seguridad Legal: Contrato digital amparado en Código Civil y Ley 30201.
Score de confianza: Reputación bidireccional (propietario e inquilino) para eliminar la barrera del garante tradicional.
🛠️ Tech Stack (MVP)
Frontend (UI/Prototipo): Flutter 🐦
Backend (Planificado): Node.js / Python + PostgreSQL (Supabase)
IA/NLP (Planificado): OpenAI GPT-4o-mini (Agente de match)
APIs (Planificadas): WhatsApp Business API, Google Maps, APIs peruanas (DNI/SUNARP)
👥 Equipo
Adriel Mithuar Guevara Cusi
Will Edson Mayta Ttito
📱 Notas Técnicas del Mockup (Desarrollo Frontend)
Assets de WasiStudent
Esta carpeta contiene íconos e imágenes personalizadas de la app.

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