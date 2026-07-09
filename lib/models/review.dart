/// Modelo de reseñas para habitaciones y propietarios en WasiStudent.
/// Sistema de evaluación multidimensional para dar transparencia
/// al proceso de alquiler estudiantil en Cusco.

library;

class Review {
  final String id;
  final String roomId;
  final String userId;
  final String userName;
  final String userAvatar;

  final int rating; // 1-5 estrellas, general
  final int cleanlinessRating; // 1-5
  final int locationRating; // 1-5
  final int valueRating; // 1-5, relación calidad-precio
  final int communicationRating; // 1-5, comunicación con el propietario
  final int accuracyRating; // 1-5, coincidencia con lo anunciado

  final String comment;
  final List<String> pros;
  final List<String> cons;
  final List<String> photos;

  final DateTime timestamp;
  final bool isVerified;

  final int helpfulCount;
  final OwnerReply? ownerReply;

  const Review({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    this.cleanlinessRating = 0,
    this.locationRating = 0,
    this.valueRating = 0,
    this.communicationRating = 0,
    this.accuracyRating = 0,
    this.comment = '',
    this.pros = const [],
    this.cons = const [],
    this.photos = const [],
    required this.timestamp,
    this.isVerified = false,
    this.helpfulCount = 0,
    this.ownerReply,
  });

  // ── Computed Getters ──────────────────────────────────────────────

  /// Promedio de todas las puntuaciones detalladas.
  double get detailedAverage {
    final scores = [
      cleanlinessRating,
      locationRating,
      valueRating,
      communicationRating,
      accuracyRating,
    ].where((s) => s > 0).toList();
    if (scores.isEmpty) return rating.toDouble();
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  /// Fecha formateada en español.
  String get dateFormatted {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${timestamp.day} de ${months[timestamp.month - 1]} de ${timestamp.year}';
  }

  /// Tiempo relativo desde la reseña.
  String get relativeTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    if (diff.inDays < 30) return 'Hace ${diff.inDays ~/ 7} semanas';
    if (diff.inDays < 365) return 'Hace ${diff.inDays ~/ 30} meses';
    return 'Hace ${diff.inDays ~/ 365} años';
  }

  /// Desglose legible de las puntuaciones.
  Map<String, int> get ratingBreakdown => {
        'Limpieza': cleanlinessRating,
        'Ubicación': locationRating,
        'Calidad/precio': valueRating,
        'Comunicación': communicationRating,
        'Precisión': accuracyRating,
      };

  Review copyWith({
    String? id,
    String? roomId,
    String? userId,
    String? userName,
    String? userAvatar,
    int? rating,
    int? cleanlinessRating,
    int? locationRating,
    int? valueRating,
    int? communicationRating,
    int? accuracyRating,
    String? comment,
    List<String>? pros,
    List<String>? cons,
    List<String>? photos,
    DateTime? timestamp,
    bool? isVerified,
    int? helpfulCount,
    OwnerReply? ownerReply,
  }) {
    return Review(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      rating: rating ?? this.rating,
      cleanlinessRating: cleanlinessRating ?? this.cleanlinessRating,
      locationRating: locationRating ?? this.locationRating,
      valueRating: valueRating ?? this.valueRating,
      communicationRating: communicationRating ?? this.communicationRating,
      accuracyRating: accuracyRating ?? this.accuracyRating,
      comment: comment ?? this.comment,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
      photos: photos ?? this.photos,
      timestamp: timestamp ?? this.timestamp,
      isVerified: isVerified ?? this.isVerified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      ownerReply: ownerReply ?? this.ownerReply,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static List<Review> mockReviews() {
    return [
      Review(
        id: 'rev-001',
        roomId: 'room-001',
        userId: 'user-010',
        userName: 'Sofía Herrera',
        userAvatar: 'SH',
        rating: 5,
        cleanlinessRating: 5,
        locationRating: 5,
        valueRating: 4,
        communicationRating: 5,
        accuracyRating: 5,
        comment:
            'Viví 6 meses en esta habitación y fue una experiencia increíble. La señora Quispe es la mejor propietaria que he tenido. La habitación es exactamente como se ve en las fotos, muy luminosa y cómoda. El internet funciona perfecto para clases virtuales y la cocina tiene todo lo que necesitas.',
        pros: [
          'La propietaria es súper amable',
          'Muy cerca de la UNSAAC',
          'Internet rápido',
          'Cuarto luminoso',
        ],
        cons: [
          'Los servicios no están incluidos',
          'Solo para mujeres',
        ],
        timestamp: DateTime(2025, 1, 15),
        isVerified: true,
        helpfulCount: 12,
        ownerReply: OwnerReply(
          content:
              '¡Gracias Sofía! Fuiste una inquilina ejemplar. Las puertas de mi casa siempre estarán abiertas para ti. ¡Mucho éxito en tu carrera!',
          timestamp: DateTime(2025, 1, 16),
        ),
      ),
      Review(
        id: 'rev-002',
        roomId: 'room-001',
        userId: 'user-011',
        userName: 'Ana Lucía Mendoza',
        userAvatar: 'AM',
        rating: 4,
        cleanlinessRating: 4,
        locationRating: 5,
        valueRating: 4,
        communicationRating: 4,
        accuracyRating: 4,
        comment:
            'Buena habitación en general. La ubicación es insuperable, literalmente a unos minutos caminando de la universidad. El único detalle es que en temporada de lluvias se siente un poco de humedad, pero con un deshumidificador se soluciona.',
        pros: [
          'Ubicación excelente',
          'Barrio seguro',
          'Cerca del mercado',
        ],
        cons: [
          'Algo de humedad en lluvias',
          'Poco espacio de almacenaje',
        ],
        timestamp: DateTime(2024, 11, 20),
        isVerified: true,
        helpfulCount: 8,
      ),
      Review(
        id: 'rev-003',
        roomId: 'room-002',
        userId: 'user-012',
        userName: 'Marco Vidal',
        userAvatar: 'MV',
        rating: 4,
        cleanlinessRating: 5,
        locationRating: 3,
        valueRating: 3,
        communicationRating: 5,
        accuracyRating: 4,
        comment:
            'El estudio es hermoso y moderno, pero está un poco lejos de la UNSAAC. Si estudias en la Andina o Andina del Cusco, es perfecto porque queda más cerca. La calefacción es un lujo en Cusco, nadie te dice eso pero en junio te vas a agradecer muchísimo.',
        pros: [
          'Calefacción (¡lujo en Cusco!)',
          'Diseño moderno',
          'Totalmente independiente',
          'Baño privado',
        ],
        cons: [
          'Lejos de la UNSAAC',
          'Precio alto para estudiante',
        ],
        timestamp: DateTime(2025, 2, 5),
        isVerified: true,
        helpfulCount: 15,
        ownerReply: OwnerReply(
          content:
              'Gracias Marco. Efectivamente, el estudio está orientado más a estudiantes de posgrado o intercambio. La calefacción central hace la diferencia en los meses de frío. ¡Vuelve cuando quieras!',
          timestamp: DateTime(2025, 2, 6),
        ),
      ),
      Review(
        id: 'rev-004',
        roomId: 'room-003',
        userId: 'user-013',
        userName: 'Gabriela Sulca',
        userAvatar: 'GS',
        rating: 3,
        cleanlinessRating: 3,
        locationRating: 2,
        valueRating: 5,
        communicationRating: 3,
        accuracyRating: 3,
        comment:
            'Es lo que pagas. La habitación es pequeña y básica, pero el precio es muy accesible para Cusco. Doña Rosa es buena persona pero tiene reglas estrictas. Si buscas ahorrar y no te importa compartir y adaptarte, funciona.',
        pros: [
          'Muy económico',
          'Doña Rosa es buena persona',
          'Desayuno los domingos',
        ],
        cons: [
          'Habitación pequeña',
          'Lejos de la universidad',
          'Reglas estrictas',
          'No acepta extranjeros',
        ],
        timestamp: DateTime(2024, 9, 10),
        isVerified: true,
        helpfulCount: 6,
      ),
      Review(
        id: 'rev-005',
        roomId: 'room-004',
        userId: 'user-014',
        userName: 'Pier Osores',
        userAvatar: 'PO',
        rating: 4,
        cleanlinessRating: 3,
        locationRating: 4,
        valueRating: 4,
        communicationRating: 3,
        accuracyRating: 4,
        comment:
            'La residencia es una buena opción si vienes de fuera y no conoces nadie. Conoces gente de todas las carreras y se hacen buenas amistades. El único problema es que a veces hay ruido y las reglas de limpieza no siempre se cumplen por todos. Las tutorías gratuitas son un gran plus.',
        pros: [
          'Conoces mucha gente',
          'Tutorías gratuitas',
          'Cerca de la UNSAAC',
          'Buen precio para lo que ofrece',
        ],
        cons: [
          'Puede ser ruidoso',
          'Limpieza irregular',
          'Habitación compartida',
        ],
        timestamp: DateTime(2024, 12, 8),
        isVerified: true,
        helpfulCount: 9,
      ),
      Review(
        id: 'rev-006',
        roomId: 'room-005',
        userId: 'user-015',
        userName: 'Dr. Raúl Espinoza',
        userAvatar: 'RE',
        rating: 5,
        cleanlinessRating: 5,
        locationRating: 4,
        valueRating: 4,
        communicationRating: 5,
        accuracyRating: 5,
        comment:
            'Como profesional que trabaja remoto y visita Cusco frecuentemente, esta suite es perfecta. La arquitecta Lucía ha diseñado cada detalle con cuidado. El balconcito con vista a los tejados es mi lugar favorito para tomar café por las mañanas. El servicio de limpieza es impecable.',
        pros: [
          'Diseño arquitectónico excepcional',
          'Vista desde el balcón',
          'Limpieza semanal incluida',
          'Colchón ortopédico',
          'Ambiente profesional',
        ],
        cons: [
          'Precio elevado',
          'Lejos de la universidad',
        ],
        timestamp: DateTime(2025, 1, 28),
        isVerified: true,
        helpfulCount: 20,
        ownerReply: OwnerReply(
          content:
              '¡Gracias doctor Espinoza! Fue un placer hospedarlo. La suite fue diseñada pensando en profesionales como usted que valoran la calidad y la tranquilidad. ¡Hasta la próxima!',
          timestamp: DateTime(2025, 1, 29),
        ),
      ),
      Review(
        id: 'rev-007',
        roomId: 'room-006',
        userId: 'user-016',
        userName: 'Lizbeth Quispe',
        userAvatar: 'LQ',
        rating: 5,
        cleanlinessRating: 4,
        locationRating: 4,
        valueRating: 5,
        communicationRating: 5,
        accuracyRating: 5,
        comment:
            'La señora Carmen es un amor de persona. Me sentí como en casa desde el primer día. Los chicharrones de los sábados son espectaculares y el mate de hierbas del patio es reconfortante después de un largo día de clases. Recomiendo 100% para chicas que buscan un ambiente familiar y seguro.',
        pros: [
          'La dueña es maravillosa',
          'Ambiente familiar',
          'Comida casera',
          'Patio hermoso',
        ],
        cons: [
          'Solo para mujeres',
          'Sin calefacción',
        ],
        timestamp: DateTime(2024, 10, 15),
        isVerified: true,
        helpfulCount: 14,
      ),
      Review(
        id: 'rev-008',
        roomId: 'room-008',
        userId: 'user-017',
        userName: 'Camila Torres',
        userAvatar: 'CT',
        rating: 4,
        cleanlinessRating: 5,
        locationRating: 5,
        valueRating: 3,
        communicationRating: 4,
        accuracyRating: 4,
        comment:
            'La seguridad de este edificio es lo mejor. Como chica que vive sola, la vigilancia 24/7 me da mucha tranquilidad. Las compañeras de departamento son geniales y muy respetuosas. El único punto en contra es que el alquiler es un poco alto comparado con otras opciones en Wanchaq, pero la seguridad lo justifica.',
        pros: [
          'Vigilancia 24/7',
          'Muy seguro',
          'Compañeras respetuosas',
          'Cerca de todo',
        ],
        cons: [
          'Precio algo alto',
          'Reglas del edificio estrictas',
        ],
        timestamp: DateTime(2025, 2, 20),
        isVerified: true,
        helpfulCount: 11,
      ),
      Review(
        id: 'rev-009',
        roomId: 'room-009',
        userId: 'user-018',
        userName: 'Julián Cárdenas',
        userAvatar: 'JC',
        rating: 5,
        cleanlinessRating: 4,
        locationRating: 3,
        valueRating: 4,
        communicationRating: 5,
        accuracyRating: 5,
        comment:
            'Si eres amante de la cultura y la historia, este lugar es para ti. La vista a Sacsayhuamán desde la habitación es algo que no tiene precio. La doctora Zamora es una fuente de sabiduría y su biblioteca personal es un tesoro. Me pasó libros increíbles sobre arte colonial que usé para mi tesis. La caminata es larga pero se disfruta.',
        pros: [
          'Vista a Sacsayhuamán',
          'Biblioteca personal',
          'Anfitriona culta',
          'Experiencia cultural única',
        ],
        cons: [
          'Lejos de la universidad',
          'Caminata empinada',
          'Frío en invierno',
        ],
        timestamp: DateTime(2024, 8, 5),
        isVerified: true,
        helpfulCount: 18,
        ownerReply: OwnerReply(
          content:
              'Julián, fue un placer compartir mi hogar y mis libros contigo. Me alegra saber que la biblioteca fue útil para tu tesis. ¡Mucho éxito, joven investigador!',
          timestamp: DateTime(2024, 8, 6),
        ),
      ),
      Review(
        id: 'rev-010',
        roomId: 'room-012',
        userId: 'user-003',
        userName: 'Emma Thompson',
        userAvatar: 'ET',
        rating: 5,
        cleanlinessRating: 4,
        locationRating: 4,
        valueRating: 5,
        communicationRating: 5,
        accuracyRating: 5,
        comment:
            'Living with the Mamani-Loayza family was the best decision I made during my exchange in Cusco. Doña Nélida taught me Quechua phrases and her cooking is amazing - I still dream about her rocoto relleno! Señor Roberto took me to hidden Inca sites that aren\'t in any guidebook. I came to Cusco to study and left with a second family. This is not just a room, it\'s a life-changing experience.',
        pros: [
          'Comidas caseras deliciosas',
          'Clases de quechua',
          'Tours con Roberto',
          'Experiencia cultural auténtica',
          'Se siente como familia',
        ],
        cons: [
          'Debes respetar horarios de comidas',
          'Menos privacidad que un departamento',
        ],
        timestamp: DateTime(2025, 1, 10),
        isVerified: true,
        helpfulCount: 34,
        ownerReply: OwnerReply(
          content:
              '¡Querida Emma! Nos encantó tenerte en casa. Ya extrañamos tus historias de Michigan. Las puertas de nuestra casa siempre serán tu hogar en el Cusco. ¡Vuelve pronto! - La familia Mamani-Loayza',
          timestamp: DateTime(2025, 1, 11),
        ),
      ),
      Review(
        id: 'rev-011',
        roomId: 'room-007',
        userId: 'user-019',
        userName: 'Brayan Huillca',
        userAvatar: 'BH',
        rating: 3,
        cleanlinessRating: 2,
        locationRating: 4,
        valueRating: 4,
        communicationRating: 2,
        accuracyRating: 3,
        comment:
            'El cuarto está bien por el precio, pero el dueño no responde rápido los mensajes y las áreas comunes no están muy limpias. Mis compañeros de departamento son buena gente pero nadie quiere limpiar. La ubicación es buena, cerca del óvalo y hay buses constantes a la universidad.',
        pros: [
          'Buen precio',
          'Buena ubicación',
          'Compañeros agradables',
        ],
        cons: [
          'Dueño poco comunicativo',
          'Áreas comunes sucias',
          'Poca limpieza en general',
        ],
        timestamp: DateTime(2025, 2, 1),
        isVerified: true,
        helpfulCount: 4,
      ),
      Review(
        id: 'rev-012',
        roomId: 'room-010',
        userId: 'user-020',
        userName: 'Andrea & Luis',
        userAvatar: 'AL',
        rating: 4,
        cleanlinessRating: 3,
        locationRating: 4,
        valueRating: 4,
        communicationRating: 3,
        accuracyRating: 4,
        comment:
            'Como pareja de estudiantes, encontrar un lugar que nos aceptara fue difícil. Este cuarto es espacioso para dos personas y el escritorio doble es muy práctico. El mercado de San Pedro está cerquita y compras fruta y verdura baratísimo. Roberto es un dueño tranquilo que no molesta mucho.',
        pros: [
          'Acepta parejas',
          'Espacioso para dos',
          'Cerca del mercado San Pedro',
          'Escritorio doble',
        ],
        cons: [
          'Sin contrato digital',
          'Poca interacción con el dueño',
          'Cocina pequeña para 6 personas',
        ],
        timestamp: DateTime(2024, 12, 22),
        isVerified: true,
        helpfulCount: 7,
      ),
    ];
  }
}

/// Respuesta del propietario a una reseña.
class OwnerReply {
  final String content;
  final DateTime timestamp;

  const OwnerReply({
    required this.content,
    required this.timestamp,
  });

  String get relativeTime {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inDays == 0) return 'Hoy';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} días';
    if (diff.inDays < 30) return 'Hace ${diff.inDays ~/ 7} semanas';
    return 'Hace ${diff.inDays ~/ 30} meses';
  }
}
