/// Configuración de la API para WasiStudent
///
/// ## Estado actual: MOCK
///
/// **Este archivo define el CONTRATO de la API REST futura** — todos los
/// endpoints (auth, rooms, contracts, payments, etc.) están documentados
/// aquí para que cuando el backend esté listo, solo se necesite:
///
/// 1. Agregar `dio: ^5.x` o `http: ^1.x` al `pubspec.yaml`.
/// 2. Reemplazar las llamadas `getMockX()` en cada provider por
///    llamadas HTTP usando `ApiConfig.endpoint(...)`.
///
/// Mientras tanto, los providers cargan datos mock directamente desde
/// los modelos (`Room.getMockRooms()`, `User.getMockCurrentUser()`, etc.).
///
/// Esto es un patrón "contract-first": definimos primero el contrato
/// (este archivo) y luego implementamos el cliente que lo consume.
///
/// ## Buscar TODOs
///
/// Ejecuta `grep -rn "TODO: Reemplazar getMock" lib/` para encontrar
/// todos los puntos donde se deberá reemplazar mock por HTTP.
class ApiConfig {
  ApiConfig._();

  // ── Entorno actual ──
  static const Environment environment = Environment.development;

  // ── URLs base ──
  static const String _baseUrlDev = 'https://api-dev.wasistudent.app';
  static const String _baseUrlStaging = 'https://api-staging.wasistudent.app';
  static const String _baseUrlProd = 'https://api.wasistudent.app';

  static const String _baseWsDev = 'wss://ws-dev.wasistudent.app';
  static const String _baseWsStaging = 'wss://ws-staging.wasistudent.app';
  static const String _baseWsProd = 'wss://ws.wasistudent.app';

  /// URL base HTTP según el entorno
  static String get baseUrl {
    switch (environment) {
      case Environment.development:
        return _baseUrlDev;
      case Environment.staging:
        return _baseUrlStaging;
      case Environment.production:
        return _baseUrlProd;
    }
  }

  /// URL base WebSocket según el entorno
  static String get baseWsUrl {
    switch (environment) {
      case Environment.development:
        return _baseWsDev;
      case Environment.staging:
        return _baseWsStaging;
      case Environment.production:
        return _baseWsProd;
    }
  }

  // ── Timeouts ──
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 15);

  // En altitud, las conexiones pueden ser más lentas
  static const Duration connectTimeoutAltitude = Duration(seconds: 20);
  static const Duration receiveTimeoutAltitude = Duration(seconds: 45);

  // ── Headers por defecto ──
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-App-Version': '4.0.0',
    'X-Platform': 'flutter',
    'X-App-Name': 'wasistudent',
  };

  // ── Autenticación ──
  static const String authHeaderKey = 'Authorization';
  static const String authHeaderPrefix = 'Bearer';
  static const String refreshTokenKey = 'refresh_token';
  static const int accessTokenExpiryMinutes = 30;
  static const int refreshTokenExpiryDays = 30;

  // ── Paginación ──
  static const String pageParam = 'page';
  static const String pageSizeParam = 'page_size';
  static const int defaultPageSize = 20;

  // ── Versionado de API ──
  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // ──────────────────────────────────────────────
  //  ENDPOINTS
  // ──────────────────────────────────────────────

  /// Construye la URL completa para un endpoint
  static String endpoint(String path) => '$baseUrl$apiPrefix$path';

  // ── Autenticación ──
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefresh = '/auth/refresh';
  static const String authLogout = '/auth/logout';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String authVerifyEmail = '/auth/verify-email';
  static const String authResendVerification = '/auth/resend-verification';
  static const String authGoogleSignIn = '/auth/google';
  static const String authAppleSignIn = '/auth/apple';
  static const String authPhoneVerify = '/auth/verify-phone';

  // ── Usuario / Perfil ──
  static const String userProfile = '/user/profile';
  static const String userUpdateProfile = '/user/profile';
  static const String userUpdateAvatar = '/user/avatar';
  static const String userChangePassword = '/user/change-password';
  static const String userDeleteAccount = '/user/account';
  static const String userPreferences = '/user/preferences';
  static const String userLifestyleTags = '/user/lifestyle-tags';
  static const String userTrustScore = '/user/trust-score';
  static const String userVerification = '/user/verification';
  static const String userVerificationSubmit = '/user/verification/submit';
  static const String userDocuments = '/user/documents';

  // ── Habitaciones / Alojamientos ──
  static const String roomsList = '/rooms';
  static String roomDetail(String id) => '/rooms/$id';
  static String roomReviews(String id) => '/rooms/$id/reviews';
  static String roomPhotos(String id) => '/rooms/$id/photos';
  static String roomAvailability(String id) => '/rooms/$id/availability';
  static String roomPricing(String id) => '/rooms/$id/pricing';
  static const String roomsSearch = '/rooms/search';
  static const String roomsNearby = '/rooms/nearby';
  static const String roomsFeatured = '/rooms/featured';
  static const String roomsByUniversity = '/rooms/by-university';
  static const String roomsByDistrict = '/rooms/by-district';
  static const String roomsCompare = '/rooms/compare';
  static const String roomsFilters = '/rooms/filters';

  // ── Favoritos ──
  static const String favoritesList = '/favorites';
  static const String favoritesAdd = '/favorites/add';
  static const String favoritesRemove = '/favorites/remove';
  static String favoritesCheck(String roomId) => '/favorites/check/$roomId';

  // ── Reseñas ──
  static const String reviewsList = '/reviews';
  static String reviewDetail(String id) => '/reviews/$id';
  static const String reviewsCreate = '/reviews';
  static String reviewsByRoom(String roomId) => '/reviews/room/$roomId';
  static String reviewsByUser(String userId) => '/reviews/user/$userId';
  static const String reviewsSummary = '/reviews/summary';

  // ── Chat / Mensajes ──
  static const String chatsList = '/chats';
  static String chatDetail(String id) => '/chats/$id';
  static String chatMessages(String id) => '/chats/$id/messages';
  static const String chatsCreate = '/chats';
  static String chatMarkRead(String id) => '/chats/$id/read';
  static String chatTyping(String id) => '/chats/$id/typing';
  static const String chatsUnreadCount = '/chats/unread-count';
  static const String chatsBlock = '/chats/block';
  static const String chatsReport = '/chats/report';

  // ── Contratos ──
  static const String contractsList = '/contracts';
  static String contractDetail(String id) => '/contracts/$id';
  static const String contractsCreate = '/contracts';
  static String contractSign(String id) => '/contracts/$id/sign';
  static String contractCancel(String id) => '/contracts/$id/cancel';
  static String contractPdf(String id) => '/contracts/$id/pdf';
  static const String contractsActive = '/contracts/active';
  static const String contractsHistory = '/contracts/history';

  // ── Pagos ──
  static const String paymentsList = '/payments';
  static String paymentDetail(String id) => '/payments/$id';
  static const String paymentsCreate = '/payments';
  static String paymentConfirm(String id) => '/payments/$id/confirm';
  static String paymentReceipt(String id) => '/payments/$id/receipt';
  static const String paymentsHistory = '/payments/history';
  static const String paymentsSummary = '/payments/summary';
  static const String paymentsUpcoming = '/payments/upcoming';
  static const String paymentsOverdue = '/payments/overdue';
  static const String paymentMethods = '/payments/methods';
  static const String paymentMethodsAdd = '/payments/methods/add';

  // ── Notificaciones ──
  static const String notificationsList = '/notifications';
  static const String notificationsMarkRead = '/notifications/mark-read';
  static const String notificationsMarkAllRead = '/notifications/mark-all-read';
  static String notificationDetail(String id) => '/notifications/$id';
  static const String notificationsSettings = '/notifications/settings';
  static const String notificationsRegisterToken = '/notifications/register-token';
  static const String notificationsUnregisterToken = '/notifications/unregister-token';

  // ── Compañeros de cuarto (Roommate Matching) ──
  static const String roommateProfile = '/roommate/profile';
  static const String roommateMatches = '/roommate/matches';
  static const String roommateDiscover = '/roommate/discover';
  static String roommateProfileDetail(String id) => '/roommate/profile/$id';
  static const String roommateSwipe = '/roommate/swipe';
  static const String roommateCompatibility = '/roommate/compatibility';
  static const String roommatePreferences = '/roommate/preferences';

  // ── Búsqueda ──
  static const String searchSuggestions = '/search/suggestions';
  static const String searchRecent = '/search/recent';
  static const String searchPopular = '/search/popular';
  static const String searchClear = '/search/clear';

  // ── Onboarding ──
  static const String onboardingComplete = '/onboarding/complete';
  static const String onboardingPreferences = '/onboarding/preferences';
  static const String onboardingUniversity = '/onboarding/university';
  static const String onboardingBudget = '/onboarding/budget';

  // ── Mapa ──
  static const String mapClusters = '/map/clusters';
  static const String mapBounds = '/map/bounds';
  static const String mapHeatmap = '/map/heatmap';

  // ── Universidades ──
  static const String universitiesList = '/universities';
  static String universityDetail(String id) => '/universities/$id';
  static String universityRooms(String id) => '/universities/$id/rooms';

  // ── Distritos ──
  static const String districtsList = '/districts';
  static String districtDetail(String id) => '/districts/$id';
  static String districtRooms(String id) => '/districts/$id/rooms';
  static String districtStats(String id) => '/districts/$id/stats';

  // ── Estadísticas ──
  static const String statsDashboard = '/stats/dashboard';
  static const String statsMarket = '/stats/market';
  static const String statsPriceHistory = '/stats/price-history';

  // ── Reportes / Soporte ──
  static const String reportsCreate = '/reports';
  static const String supportTicket = '/support/tickets';
  static const String supportFaq = '/support/faq';

  // ── Configuración del app ──
  static const String appConfig = '/config';
  static const String appVersion = '/config/version';
  static const String appMaintenance = '/config/maintenance';
  static const String appFeatureFlags = '/config/features';

  // ──────────────────────────────────────────────
  //  CONFIGURACIÓN DE IMÁGENES
  // ──────────────────────────────────────────────
  static const String imageBaseUrl = 'https://img.wasistudent.app';
  static const String imagePlaceholder = '$imageBaseUrl/placeholders/room_default.webp';
  static const String avatarPlaceholder = '$imageBaseUrl/placeholders/avatar_default.webp';

  // Tamaños de imagen predefinidos
  static String imageThumbnail(String path) => '$imageBaseUrl/resize/200/$path';
  static String imageMedium(String path) => '$imageBaseUrl/resize/600/$path';
  static String imageLarge(String path) => '$imageBaseUrl/resize/1200/$path';
  static String imageOriginal(String path) => '$imageBaseUrl/original/$path';

  // ──────────────────────────────────────────────
  //  CONFIGURACIÓN DE MAPAS
  // ──────────────────────────────────────────────
  //
  // El mockup actual usa un mapa visual estático dibujado con CustomPaint
  // (ver `lib/screens/explore_map_screen.dart`). No requiere API key.
  //
  // Cuando se integre un proveedor real de mapas (Google Maps, Mapbox,
  // OpenStreetMap), agregar aquí las API keys correspondientes y
  // reemplazar el `_MapCanvas` por el widget del proveedor elegido.
  //
  // static const String googleMapsApiKey = 'YOUR_API_KEY';
  // static const String mapboxApiKey = 'YOUR_API_KEY';

  static const double defaultLatitude = -13.5319;
  static const double defaultLongitude = -71.9675;
  static const double defaultZoom = 14.0;
  static const double searchRadiusKm = 3.0;
  static const int maxClusterItems = 100;

  // ──────────────────────────────────────────────
  //  RATE LIMITING
  // ──────────────────────────────────────────────
  static const int maxSearchRequestsPerMinute = 20;
  static const int maxChatMessagesPerMinute = 30;
  static const int maxReviewSubmissionsPerDay = 3;
  static const int maxImageUploadsPerSession = 10;

  // ──────────────────────────────────────────────
  //  WEBHOOKS / ANALYTICS
  // ──────────────────────────────────────────────
  static String get analyticsEndpoint => '$baseUrl/api/$apiVersion/analytics/event';
  static String get crashReportEndpoint => '$baseUrl/api/$apiVersion/crashes/report';

  // ──────────────────────────────────────────────
  //  CDN / ALMACENAMIENTO
  // ──────────────────────────────────────────────
  static const String cdnBaseUrl = 'https://cdn.wasistudent.app';
  static String get uploadUrl => '$baseUrl/api/$apiVersion/upload';
  static const int maxUploadSizeBytes = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedDocumentExtensions = ['pdf', 'doc', 'docx', 'jpg', 'png'];

  // ──────────────────────────────────────────────
  //  WEBSOCKET CHANNELS
  // ──────────────────────────────────────────────
  static String wsChatChannel(String chatId) => '$baseWsUrl/chat/$chatId';
  static String wsNotificationsChannel(String userId) => '$baseWsUrl/notifications/$userId';
  static String wsPresenceChannel(String userId) => '$baseWsUrl/presence/$userId';

  // ──────────────────────────────────────────────
  //  DEEP LINKS
  // ──────────────────────────────────────────────
  static const String deepLinkScheme = 'wasistudent';
  static const String deepLinkHost = 'app.wasistudent.com';
  static String deepLinkRoom(String id) => '$deepLinkScheme://$deepLinkHost/room/$id';
  static String deepLinkProfile(String id) => '$deepLinkScheme://$deepLinkHost/profile/$id';
  static String deepLinkReview(String id) => '$deepLinkScheme://$deepLinkHost/review/$id';

  // ──────────────────────────────────────────────
  //  UTILIDADES
  // ──────────────────────────────────────────────

  /// Verifica si la API está en modo mantenimiento
  static bool get isMaintenance => false;

  /// Indica si estamos en entorno de desarrollo
  static bool get isDevelopment => environment == Environment.development;

  /// Indica si estamos en entorno de producción
  static bool get isProduction => environment == Environment.production;

  /// Headers de autenticación para solicitudes autenticadas
  static Map<String, String> authHeaders(String token) {
    return {
      ...defaultHeaders,
      authHeaderKey: '$authHeaderPrefix $token',
    };
  }

  /// Construye una URL con parámetros de consulta
  static String buildUrl(String path, [Map<String, dynamic>? queryParams]) {
    var url = endpoint(path);
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .where((e) => e.value != null)
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');
      url += '?$queryString';
    }
    return url;
  }

  /// Timeout adaptado para la altitud de Cusco
  /// En caso de conexión lenta, usa timeouts extendidos
  static Duration get adaptiveConnectTimeout {
    // En desarrollo siempre usar el timeout normal
    if (isDevelopment) return connectTimeout;
    // En producción se podría detectar la velocidad de conexión
    return connectTimeout;
  }

  static Duration get adaptiveReceiveTimeout {
    if (isDevelopment) return receiveTimeout;
    return receiveTimeout;
  }
}

/// Entornos de despliegue
enum Environment {
  development,
  staging,
  production,
}

/// Códigos de error de la API
class ApiErrorCode {
  ApiErrorCode._();

  // Autenticación
  static const String invalidCredentials = 'AUTH_001';
  static const String tokenExpired = 'AUTH_002';
  static const String tokenInvalid = 'AUTH_003';
  static const String accountLocked = 'AUTH_004';
  static const String emailNotVerified = 'AUTH_005';
  static const String phoneNotVerified = 'AUTH_006';

  // Validación
  static const String validationError = 'VAL_001';
  static const String invalidInput = 'VAL_002';
  static const String missingField = 'VAL_003';

  // Recursos
  static const String notFound = 'RES_001';
  static const String alreadyExists = 'RES_002';
  static const String conflict = 'RES_003';

  // Negocio
  static const String roomUnavailable = 'BIZ_001';
  static const String bookingConflict = 'BIZ_002';
  static const String paymentFailed = 'BIZ_003';
  static const String insufficientFunds = 'BIZ_004';
  static const String contractActive = 'BIZ_005';
  static const String verificationRequired = 'BIZ_006';
  static const String trustScoreLow = 'BIZ_007';

  // Rate limiting
  static const String rateLimitExceeded = 'RATE_001';

  // Sistema
  static const String serverError = 'SYS_001';
  static const String serviceUnavailable = 'SYS_002';
  static const String maintenance = 'SYS_003';
  static const String timeout = 'SYS_004';
  static const String networkError = 'SYS_005';

  /// Mensaje en español para un código de error
  static String message(String code) {
    switch (code) {
      // Auth
      case invalidCredentials:
        return 'Credenciales inválidas. Verifica tu correo y contraseña.';
      case tokenExpired:
        return 'Tu sesión ha expirado. Inicia sesión nuevamente.';
      case tokenInvalid:
        return 'Token de autenticación inválido.';
      case accountLocked:
        return 'Tu cuenta ha sido bloqueada. Contacta soporte.';
      case emailNotVerified:
        return 'Verifica tu correo electrónico para continuar.';
      case phoneNotVerified:
        return 'Verifica tu número de teléfono para continuar.';
      // Validación
      case validationError:
        return 'Los datos ingresados no son válidos.';
      case invalidInput:
        return 'El formato de los datos es incorrecto.';
      case missingField:
        return 'Faltan campos obligatorios.';
      // Recursos
      case notFound:
        return 'El recurso solicitado no existe.';
      case alreadyExists:
        return 'Ya existe un registro con estos datos.';
      case conflict:
        return 'Hay un conflicto con los datos existentes.';
      // Negocio
      case roomUnavailable:
        return 'Esta habitación ya no está disponible.';
      case bookingConflict:
        return 'Ya tienes una reserva en estas fechas.';
      case paymentFailed:
        return 'El pago no pudo ser procesado. Intenta de nuevo.';
      case insufficientFunds:
        return 'Fondos insuficientes para completar la operación.';
      case contractActive:
        return 'Ya tienes un contrato activo para este período.';
      case verificationRequired:
        return 'Necesitas verificar tu identidad para continuar.';
      case trustScoreLow:
        return 'Tu nivel de confianza es insuficiente para esta acción.';
      // Rate
      case rateLimitExceeded:
        return 'Has realizado demasiadas solicitudes. Espera un momento.';
      // Sistema
      case serverError:
        return 'Error interno del servidor. Intenta más tarde.';
      case serviceUnavailable:
        return 'El servicio no está disponible temporalmente.';
      case maintenance:
        return 'Estamos en mantenimiento. Vuelve pronto.';
      case timeout:
        return 'La conexión tardó demasiado. Verifica tu internet.';
      case networkError:
        return 'Sin conexión a internet. Verifica tu red.';
      default:
        return 'Ha ocurrido un error inesperado.';
    }
  }
}

/// Códigos de estado HTTP utilizados
class HttpStatus {
  HttpStatus._();
  static const int ok = 200;
  static const int created = 201;
  static const int noContent = 204;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int conflict = 409;
  static const int unprocessableEntity = 422;
  static const int tooManyRequests = 429;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}
