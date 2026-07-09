# Changelog WasiStudent

## v6.0.0 — 2026-06-19

### Eliminado
- **Toda referencia a Airbnb/anti-Airbnb** eliminada del código, contratos,
  widgets y documentación. La app se enfoca en verificación, contratos y
  transparencia — no en competir con plataformas de hospedaje turístico.
- `docs/legal/anti-airbnb-decision.md` eliminado.
- `docs/roadmap/university-dashboard.md` eliminado (dashboard universitario
  fuera de alcance).
- Carpeta `docs/` eliminada (sin contenido).

### Cambiado
- **Cláusula 4 del contrato reescrita**: de "Compromiso anti-Airbnb" a
  **"Transparencia total de servicios incluidos"** (Ley N° 29571 Art. 18,
  Código de Protección y Defensa del Consumidor). Ahora protege contra
  cobros ocultos por servicios no declarados, con descuento del 5% del
  arrendamiento por día de interrupción de servicios >24h.
- **Cláusula 2 simplificada**: eliminada mención a Airbnb/Booking/Expedia.
  Ahora se enfoca en duración mínima 6 meses y causales del Art. 1704.
- `contract_default_badge.dart`: `airbnbConversion` reemplazado por
  `hiddenServiceFees` ("Cobró servicios extra").
- `committed_to_students_badge.dart`: reescrito el docstring. Ahora el badge
  se otorga por 2 ciclos exitosos + Trust Score ≥80, sin mencionar Airbnb.
- README.md: problemas resueltos actualizados (sin Airbnb, con
  transparencia de servicios como problema #4).
- `pubspec.yaml`: versión subida a 6.0.0+6, agregada carpeta `assets/icons/`.

### Agregado
- **Google Maps real en `explore_map_screen.dart`**: reemplazado el
  placeholder CustomPaint por `GoogleMap` real con marcadores en las
  coordenadas reales de los 12 cuartos mock (Ttiobamba, Saphi, Av. de la
  Cultura, San Jerónimo, etc.). Soporta modo oscuro con `_darkMapStyle`.
  Instrucciones para configurar API key en `assets/icons/README.md`.
- **Panel de propietaria completo** (6 pantallas en `lib/screens/owner/`):
  - `OwnerDashboardScreen`: resumen con ingresos, cuartos activos,
    solicitudes pendientes, accesos rápidos.
  - `OwnerRoomsListScreen`: lista de cuartos publicados con stats.
  - `OwnerRoomFormScreen`: formulario para publicar cuarto (título,
    descripción, precio, distrito, tipo, permisos).
  - `OwnerRequestsScreen`: solicitudes recibidas con trust score del
    estudiante, botones aceptar/rechazar.
  - `OwnerContractsScreen`: contratos activos e históricos.
  - `OwnerPaymentsScreen`: ingresos mensuales, suscripción, historial.
- **Sistema de roles con `RoleProvider`**: el usuario puede activar el rol
  propietaria desde Ajustes (con diálogo de requisitos) y cambiar entre
  rol estudiante/propietaria. El `HomeScreen` muestra automáticamente el
  `OwnerDashboardScreen` cuando el rol activo es propietaria.
- **Sección "Rol de usuario" en `SettingsScreen`**: con accesos directos
  a las pantallas del panel propietaria, switch de rol, y opción de
  desactivar cuenta de propietaria.
- Rutas nuevas en `routes.dart`: `/owner`, `/owner/rooms`, `/owner/rooms/new`,
  `/owner/requests`, `/owner/contracts`, `/owner/payments`.
- `assets/icons/README.md`: instrucciones para activar Google Maps en
  Android, Web e iOS, y para generar pins personalizados.

### Matching 6 dimensiones (sin cambios respecto a v5)
Pesos por defecto: Ubicación 25%, Presupuesto 20%, Hábitos 20%,
Servicios 15%, Preferencias 10%, Reputación 10%. Ajustables por usuario
desde el card "Ajusta tus prioridades de búsqueda" en el home.

### Trust Score 4 factores (sin cambios respecto a v5)
Identidad 30%, Contratos cumplidos 30%, Reseñas 25%, Antigüedad 15%.

---

## v5.0.0 — 2026-06-19 (anterior)

- 5 cláusulas específicas de protección estudiantil.
- Widget `VerificationChecklistCard` (12 puntos, 7 indispensables + 5
  complementarios).
- `GuaranteeBanner` (acuerdo opcional).
- Matching 6 dimensiones con pesos ajustables.
- Trust Score 4 factores.
- 12 habitaciones mock con barrios reales de Cusco.
- README/manifest/index.html corregidos.
- `api_config.dart` aclarado como contrato mock.
- TODOs en providers para futura integración HTTP.
- Widgets: `committed_to_students_badge`, `contract_default_badge`,
  `guarantee_badge`, `verified_badge` (nivel 2 renombrado).
