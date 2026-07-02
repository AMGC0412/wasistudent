# WasiStudent

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.24+-02569B?style=for-the-badge&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.5+-0175C2?style=for-the-badge&logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/Versi%C3%B3n-4.0.0-1A535C?style=for-the-badge" alt="Versión">
</p>

## Descripción

**WasiStudent** ("wasi" en quechua significa **casa**) es una aplicación móvil
multiplataforma que resuelve el problema de búsqueda de vivienda estudiantil
en Cusco. La plataforma verifica cada cuarto en persona, ofrece contratos
digitales con cláusulas de protección estudiantil, calcula un Puntaje de
Confianza que reemplaza al garante formal, y empareja al estudiante con
habitaciones según 6 dimensiones ponderadas.

### Misión

_Conectar a estudiantes foráneos de la UNSAAC, UAC y Continental Cusco con
vivienda verificada, contractualmente protegida y accesible — eliminando
el engaño, la vulnerabilidad legal y los cobros ocultos que sufren cada
semestre los 8,650 estudiantes foráneos que llegan a Cusco._

### Problemas que resuelve

1. **Engaño sistemático** (91% de estudiantes): verificación en persona con
   fotos reales, precios confirmados y distancias medidas con GPS.
2. **Vulnerabilidad legal** (88% sin contrato): contrato digital con 5
   cláusulas de protección estudiantil firmadas en 15 minutos.
3. **Condiciones inhumanas** (67%): checklist de verificación de 12 puntos
   (7 indispensables + 5 complementarios).
4. **Cobros ocultos por servicios** (73%): transparencia total de servicios
   incluidos en el contrato, con penalización por interrupciones.
5. **Impacto académico** (64%): reducir la búsqueda de 1-3 semanas a
   menos de 72 horas.
6. **Exclusión por condición** (58%): Puntaje de Confianza que reemplaza
   al garante + emparejamiento inclusivo.

## Capturas de Pantalla

| Inicio | Explorar | Detalle del cuarto |
|:---:|:---:|:---:|
| *[Placeholder - Pantalla de inicio con acceso a prioridades]* | *[Placeholder - Lista de cuartos filtrados]* | *[Placeholder - Detalle con verificación, garantía y cláusulas]* |

| Mapa | Perfil | Contrato |
|:---:|:---:|:---:|
| *[Placeholder - Mapa con pins en Cusco]* | *[Placeholder - Perfil con TrustRing]* | *[Placeholder - Flujo de contrato con 5 cláusulas]* |

## Características

- 🏠 **Home personalizado**: dashboard con accesos directos a prioridades de búsqueda, cuartos "Para ti", verificados recientemente y últimos agregados.
- 🗺️ **Mapa interactivo**: exploración geolocalizada de cuartos en los barrios cusqueños (Ttiobamba, Saphi, Av. de la Cultura, San Jerónimo, San Sebastián, Santiago, Wanchaq, San Blas, Poroy, Centro Histórico).
- 🔍 **Exploración avanzada**: filtros por distrito, ordenamiento por match/precio/distancia/confianza, comparación lado a lado.
- ✅ **Verificación en persona (12 puntos)**: 7 indispensables (agua, electricidad, baño, cocina, cerradura, estructura, ventilación) + 5 complementarios (Wi-Fi, agua caliente, baño propio, escritorio, iluminación natural). Visualizado en `VerificationChecklistCard`.
- 🛡️ **Garantía WasiStudent**: acuerdo opcional propietario-inquilino que respalda al estudiante si el cuarto no coincide con lo verificado o si la propietaria incumple el contrato.
- 📄 **Contratos digitales (5 cláusulas)**: precio fijo (Art. 1680), duración mínima 6 meses (Ley 30201), devolución de depósito en 15 días (Art. 1679), transparencia total de servicios (Ley 29571 Art. 18), preaviso 30 días (Art. 1687).
- 🎯 **Matching 6 dimensiones**: Ubicación 25%, Presupuesto 20%, Hábitos 20%, Servicios 15%, Preferencias 10%, Reputación 10%. Pesos ajustables por el usuario desde el home.
- 🔐 **Puntaje de Confianza (4 factores)**: Identidad 30%, Contratos cumplidos 30%, Reseñas 25%, Antigüedad 15%. Reemplaza al garante formal.
- 👤 **Perfil de usuario**: TrustRing animado, insignias, historial de contratos y reseñas.
- 💬 **Chat con propietarias**: comunicación directa dentro de la app.
- 💳 **Pagos**: cronograma mensual, métodos peruanos (Yape, Plin, transferencia, efectivo, BIM), recordatorios de vencimiento.
- 🌙 **Modo oscuro** + accesibilidad + diseño responsivo.
- 🔔 **Notificaciones push** in-app.

## Stack Tecnológico

| Tecnología | Uso |
|---|---|
| **Flutter** | Framework de desarrollo multiplataforma (Android, iOS, Web, Windows) |
| **Dart** | Lenguaje de programación principal |
| **Provider** | Gestión de estado reactivo (`provider: ^6.1.2`) |
| **GoRouter** | Navegación declarativa (`go_router: ^14.2.0`) |
| **Hive** | Almacenamiento local persistente (`hive: ^2.2.3`) |
| **Geolocator** | Servicios de geolocalización (`geolocator: ^12.0.0`) |
| **Cached Network Image** | Caché de imágenes remotas |
| **Shimmer** | Skeleton loaders |
| **FL Chart** | Gráficos (radar de compatibilidad, barras) |
| **Photo View** | Visor de fotos con zoom |
| **Flutter Local Notifications** | Notificaciones locales |

> **Nota sobre backend**: el archivo `lib/config/api_config.dart` define el
> contrato de endpoints REST (auth, rooms, contracts, payments, etc.) que se
> usarán cuando el backend esté listo. Mientras tanto, los providers cargan
> datos desde `getMockX()` directamente. Cuando se integre el backend, solo
> se necesita agregar `dio` o `http` al `pubspec.yaml` y reemplazar las
> llamadas mock por llamadas HTTP.

## Requisitos Previos

- **Flutter SDK**: >= 3.24.0
- **Dart SDK**: >= 3.5.0
- **Android Studio** o **VS Code** con extensiones de Flutter
- **Android SDK**: minSdkVersion 21
- **Xcode**: >= 15.0 (para desarrollo iOS)
- **CocoaPods**: >= 1.14.0 (para desarrollo iOS)

## Instalación

### 1. Clonar el repositorio

```bash
git clone https://github.com/wasistudent/wasistudent_app.git
cd wasistudent_app
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Generar código (si aplica)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Ejecutar la aplicación

```bash
# En modo debug
flutter run

# En un dispositivo específico
flutter devices
flutter run -d <device_id>
```

### 5. Compilar para producción

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Estructura del Proyecto

```
wasistudent_app/
├── android/                    # Configuración nativa de Android (generada por flutter create)
├── web/                        # Configuración para web (PWA)
├── windows/                    # Configuración nativa de Windows
├── lib/                        # Código fuente Dart
│   ├── main.dart               # Punto de entrada + MultiProvider
│   ├── app.dart                # Configuración del widget principal
│   ├── config/                 # Configuraciones y constantes
│   │   ├── api_config.dart     # Contrato de API (mock por ahora)
│   │   ├── constants.dart      # Constantes globales
│   │   ├── routes.dart         # Rutas con GoRouter
│   │   └── theme.dart          # Tema WasiColors, WasiRadius, etc.
│   ├── models/                 # Modelos de datos (User, Room, etc.)
│   ├── providers/              # Providers de estado (Room, Auth, etc.)
│   ├── repositories/           # Capa de datos (futura integración HTTP)
│   ├── services/               # Lógica de negocio
│   │   ├── matching_service.dart       # Matching 6 dimensiones
│   │   ├── trust_score_service.dart    # Trust Score 4 factores
│   │   ├── payment_service.dart        # Cronograma de pagos
│   │   ├── location_service.dart       # Geolocalización
│   │   └── notification_service.dart   # Notificaciones
│   ├── screens/                # Pantallas de la app (24 pantallas)
│   │   ├── home_screen.dart            # Dashboard con acceso a prioridades
│   │   ├── explore_screen.dart         # Lista de cuartos filtrados
│   │   ├── explore_map_screen.dart     # Mapa con pins
│   │   ├── discover_screen.dart        # Modo swipe tipo Tinder
│   │   ├── room_detail_screen.dart     # Detalle con checklist + garantía
│   │   ├── contract_flow_screen.dart   # Contrato con 5 cláusulas legales
│   │   ├── trust_score_screen.dart     # TrustRing + 4 dimensiones
│   │   ├── preferences_screen.dart     # 5 tabs (Presupuesto, Ubicación, etc.)
│   │   ├── comparison_screen.dart      # Comparar 2 cuartos lado a lado
│   │   ├── payments_screen.dart        # Cronograma de pagos
│   │   ├── reviews_screen.dart         # Reseñas de cuartos
│   │   ├── roommate_matching_screen.dart # Compatibilidad de compañeros
│   │   └── ...                         # 12 pantallas más
│   ├── utils/                  # Utilidades (validators, format_helpers, distance)
│   └── widgets/                # Widgets reutilizables
│       ├── verification_checklist_card.dart  # 12 puntos verificables
│       ├── guarantee_banner.dart              # Garantía opcional
│       ├── verified_badge.dart                # Niveles de verificación
│       ├── matching_badge.dart                # % match con código de color
│       ├── walking_time_badge.dart            # GPS tiempo a pie
│       ├── compatibility_radar.dart           # Gráfico radar 6D
│       ├── trust_ring.dart                    # Anillo de confianza animado
│       └── ...                                # 12 widgets más
├── test/                       # Tests unitarios y de widgets
├── pubspec.yaml                # Dependencias y configuración del proyecto
├── analysis_options.yaml       # Reglas de linting
└── README.md                   # Este archivo
```

## Variables de Entorno

Crear un archivo `.env` en la raíz del proyecto (cuando el backend esté listo):

```env
API_BASE_URL=https://api.wasistudent.app
WS_URL=wss://api.wasistudent.app/ws
MAPS_API_KEY=tu_api_key_aqui
```

Mientras se usa mock data, no se requiere `.env`.

## Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ejecutar tests de integración
flutter test integration_test/
```

## Hoja de ruta

- [x] App del estudiante (24 pantallas)
- [x] Panel básico de propietaria (gestión de cuartos y solicitudes)
- [x] Switch de rol en ajustes (estudiante ↔ propietaria)
- [ ] Integración backend real (auth, payments, chat)
- [ ] Verificación en campo con verificadores reales

## Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Realiza tus cambios y haz commit (`git commit -m 'feat: agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## Equipo

**Will Edson Mayta Ttito** & **Adriel Mithuar Guevara Cusi**
UNSAAC — Universidad Nacional de San Antonio Abad del Cusco

## Licencia

Este proyecto es privado y confiable. Todos los derechos reservados.

---

<p align="center">
  WasiStudent — Tu wasi te espera. 🏠
</p>
