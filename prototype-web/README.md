# WasiStudent Web v5

Versión completamente reconstruida de la plataforma WasiStudent para alojamiento estudiantil confiable en Cusco, Perú.

## Arquitectura

```
wasistudent_web_v5/
├── index.html                  # Entry point con carga modular
├── css/
│   ├── style.css               # Importa todos los parciales
│   ├── tokens.css              # Design tokens (paleta terracota cusqueña)
│   ├── base.css                # Reset + utilidades + animaciones
│   ├── components.css          # Botones, cards, chips, inputs, modales
│   ├── layout.css              # Sidebar + bottom nav + responsive
│   └── screens.css             # Estilos de pantallas específicas
├── js/
│   ├── core/
│   │   ├── icons.js            # Set SVG sin dependencias
│   │   ├── store.js            # Persistencia local (localStorage + fallback)
│   │   ├── data.js             # Datos seed (6 habitaciones realistas)
│   │   ├── router.js           # SPA router simple
│   │   └── ui.js               # Helpers UI (toast, modal, render)
│   ├── services/
│   │   ├── auth.js             # Login, registro, sesión
│   │   └── onboarding.js       # Flujo de 7 pasos para nuevos usuarios
│   ├── components/
│   │   ├── roomCard.js         # Card de habitación reutilizable
│   │   ├── trustRing.js        # Anillo animado de Trust Score
│   │   ├── filters.js          # Sistema de filtros
│   │   ├── checklist.js        # 12 puntos de verificación
│   │   └── forms.js            # Helpers de formularios
│   ├── screens/
│   │   ├── auth.js             # Login / registro
│   │   ├── onboarding.js       # 7 pasos de onboarding
│   │   ├── home.js             # Dashboard estudiante
│   │   ├── discover.js         # Lista + mapa
│   │   ├── detail.js           # Detalle de habitación
│   │   ├── trust.js            # Trust Score dashboard
│   │   ├── contract.js         # Flujo de contrato con 5 cláusulas
│   │   ├── favorites.js        # Habitaciones favoritas
│   │   ├── messages.js         # Chat con propietarios
│   │   ├── payments.js         # Pagos e historial
│   │   ├── reviews.js          # Reseñas verificadas
│   │   ├── profile.js          # Perfil + verificaciones
│   │   ├── settings.js         # Configuración
│   │   ├── ownerDashboard.js   # Dashboard propietario
│   │   ├── ownerRooms.js       # CRUD habitaciones
│   │   ├── ownerRequests.js    # Solicitudes recibidas
│   │   ├── ownerContracts.js   # Contratos activos
│   │   └── ownerPayments.js    # Pagos recibidos
│   └── app.js                  # Bootstrap
├── php/                        # Backend PHP (futuro)
└── sql/                        # Schema SQL (futuro)
```

## Características principales

### Diseño
- **Paleta terracota cusqueña**: inspirada en adobe, verde andino, crema cálida
- **Layout responsive**: sidebar en desktop, bottom nav en móvil
- **Tipografía**: Inter (cuerpo) + Plus Jakarta Sans (display)
- **Animaciones**: transiciones suaves, skeletons, ripple effect

### Funcionalidades estudiante
- Onboarding de 7 pasos (rol, universidad, presupuesto, preferencias, estilo de vida)
- Descubrir habitaciones (lista + mapa)
- Detalle con galería, checklist de verificación, reseñas
- Trust Score con 4 factores
- Flujo de contrato con 5 cláusulas legales (Código Civil peruano)
- Chat con propietarios
- Pagos e historial
- Reseñas verificadas
- Favoritos
- Perfil con verificaciones

### Funcionalidades propietario
- Dashboard con KPIs (habitaciones, solicitudes, contratos, ingresos)
- CRUD de habitaciones
- Gestión de solicitudes (aprobar/rechazar)
- Lista de contratos activos
- Pagos recibidos

## Cómo usar

Opción 1 — Servidor local:
```bash
cd wasistudent_web_v5
python3 -m http.server 8080
# Abrir http://localhost:8080
```

Opción 2 — Abrir directamente:
Abrir `index.html` en el navegador (funciona con fallback en memoria).

### Usuarios demo
- **Estudiante**: estudiante@demo.com / demo123
- **Propietario**: propietario@demo.com / demo123

O usar los botones "Demo estudiante" / "Demo propietario" en la pantalla de login.

## Base legal

Las 5 cláusulas del contrato se basan en:
1. **Art. 1680 CC** — Precio fijo
2. **Ley 30201** — Duración mínima 6 meses
3. **Art. 1679 CC** — Devolución de depósito en 15 días
4. **Ley 29571** — Transparencia en servicios
5. **Art. 1687 CC** — Preaviso de 30 días
