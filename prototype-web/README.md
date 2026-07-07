# WasiStudent — Versión Web (HTML + CSS + JS + PHP)

Estructura del proyecto:

```
wasistudent_web/
├── index.html              # HTML structure (solo markup)
├── css/
│   └── style.css           # Todos los estilos
├── js/
│   ├── config.js           # Configuracion, state, seed data, DB layer
│   ├── icons.js            # Libreria de iconos SVG
│   ├── api.js              # Capa de datos (localStorage o PHP API)
│   ├── navigation.js       # Sistema de navegacion entre pantallas
│   ├── components/
│   │   └── roomCard.js     # Componente reutilizable: tarjeta de cuarto
│   ├── screens/
│   │   ├── auth.js         # Login / registro
│   │   ├── home.js         # Home con cuartos
│   │   ├── explore.js      # Explorar con filtros
│   │   ├── map.js          # Mapa visual
│   │   ├── discover.js     # Descubrir
│   │   ├── messages.js     # Mensajes
│   │   ├── profile.js      # Perfil
│   │   ├── detail.js       # Detalle del cuarto + verificacion
│   │   ├── contract.js     # Flujo de contrato (3 pasos)
│   │   ├── survey.js       # Encuesta post-firma
│   │   ├── owner.js        # Panel propietaria
│   │   ├── settings.js     # Ajustes
│   │   ├── trust.js        # Trust Score
│   │   ├── reviews.js      # Reseñas
│   │   ├── favorites.js    # Favoritos
│   │   └── payments.js     # Pagos
│   └── app.js              # Entry point (inicializa todo)
├── php/
│   ├── db.php              # Conexion MySQL + helpers CRUD
│   ├── auth.php            # Login / registro API
│   ├── rooms.php           # CRUD cuartos API
│   ├── contracts.php       # CRUD contratos API
│   ├── reviews.php         # CRUD reseñas API
│   ├── favorites.php       # Favoritos API
│   └── requests.php        # Solicitudes API
└── sql/
    └── schema.sql          # Esquema de base de datos MySQL
```

## Como ejecutar

### Opcion 1: Sin backend (localStorage)
1. Abre `index.html` en cualquier navegador
2. Funciona con localStorage (no requiere servidor)

### Opcion 2: Con backend PHP + MySQL
1. Instala XAMPP/WAMP/MAMP
2. Crea la base de datos: `mysql -u root < sql/schema.sql`
3. Configura credenciales en `php/db.php`
4. Cambia `USE_LOCAL: true` a `false` en `js/config.js`
5. Coloca el proyecto en `htdocs/wasistudent`
6. Abre `http://localhost/wasistudent`

## Funcionalidades

- Auth (login/registro) con persistencia
- Home con cuartos verificados
- Explorar con busqueda y filtros
- Mapa visual de Cusco
- Detalle del cuarto con verificacion (12 puntos)
- Garantia WasiStudent
- Contrato digital (5 clausulas con base legal)
- Encuesta post-firma con resultados
- Panel de propietaria completo
- Publicar cuartos
- Solicitudes (aceptar/rechazar)
- Contratos e ingresos
- Trust Score con anillo animado
- Reseñas
- Favoritos
- Pagos
- Settings con switch de rol
