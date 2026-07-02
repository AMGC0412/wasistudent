/// Modelo de perfil de compañero de cuarto para WasiStudent.
/// Permite a los estudiantes encontrar compañeros compatibles
/// para compartir alojamiento en Cusco.

library;

enum SleepSchedule { early, normal, late, nightOwl }

class RoommateProfile {
  final String id;
  final String name;
  final int age;
  final String avatar; // Iniciales
  final String university;
  final String career;
  final int semester;

  final String bio;
  final List<String> lifestyleTags;
  final List<String> interests;

  final String budgetRange; // ej. "S/ 400-700"
  final List<String> preferredDistricts;

  final int cleanlinessLevel; // 1-5
  final int socialLevel; // 1-5
  final int studyLevel; // 1-5

  final SleepSchedule sleepSchedule;

  final bool isVerified;
  final double compatibilityScore; // 0-100

  final List<String> photos;

  const RoommateProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.avatar,
    this.university = '',
    this.career = '',
    this.semester = 1,
    this.bio = '',
    this.lifestyleTags = const [],
    this.interests = const [],
    this.budgetRange = '',
    this.preferredDistricts = const [],
    this.cleanlinessLevel = 3,
    this.socialLevel = 3,
    this.studyLevel = 3,
    this.sleepSchedule = SleepSchedule.normal,
    this.isVerified = false,
    this.compatibilityScore = 0.0,
    this.photos = const [],
  });

  // ── Computed Getters ──────────────────────────────────────────────

  String get universityShort {
    if (university.contains('Nacional')) return 'UNSAAC';
    if (university.contains('Andina')) return 'UANDINA';
    if (university.contains('Católica')) return 'UCSP';
    if (university.contains('Tecnológica')) return 'UTP';
    if (university.contains('Le Cordon')) return 'LCB';
    return university;
  }

  String get sleepScheduleLabel {
    switch (sleepSchedule) {
      case SleepSchedule.early:
        return 'Madrugador/a (22:00 - 6:00)';
      case SleepSchedule.normal:
        return 'Normal (23:00 - 7:00)';
      case SleepSchedule.late:
        return 'Trasnochador/a (1:00 - 9:00)';
      case SleepSchedule.nightOwl:
        return 'Búho nocturno (3:00 - 11:00)';
    }
  }

  String get sleepScheduleShort {
    switch (sleepSchedule) {
      case SleepSchedule.early:
        return 'Madrugador';
      case SleepSchedule.normal:
        return 'Normal';
      case SleepSchedule.late:
        return 'Trasnochador';
      case SleepSchedule.nightOwl:
        return 'Nocturno';
    }
  }

  String get cleanlinessLabel {
    if (cleanlinessLevel >= 5) return 'Muy ordenado/a';
    if (cleanlinessLevel >= 4) return 'Ordenado/a';
    if (cleanlinessLevel >= 3) return 'Normal';
    if (cleanlinessLevel >= 2) return 'Relajado/a';
    return 'Desordenado/a';
  }

  String get socialLabel {
    if (socialLevel >= 5) return 'Muy social';
    if (socialLevel >= 4) return 'Social';
    if (socialLevel >= 3) return 'Equilibrado/a';
    if (socialLevel >= 2) return 'Reservado/a';
    return 'Muy reservado/a';
  }

  String get studyLabel {
    if (studyLevel >= 5) return 'Muy estudioso/a';
    if (studyLevel >= 4) return 'Estudioso/a';
    if (studyLevel >= 3) return 'Equilibrado/a';
    if (studyLevel >= 2) return 'Relajado/a';
    return 'Muy relajado/a';
  }

  /// Nivel de compatibilidad en texto.
  String get compatibilityLabel {
    if (compatibilityScore >= 90) return 'Compatibilidad excelente';
    if (compatibilityScore >= 75) return 'Buena compatibilidad';
    if (compatibilityScore >= 60) return 'Compatibilidad moderada';
    if (compatibilityScore >= 40) return 'Compatibilidad baja';
    return 'Poca compatibilidad';
  }

  /// Etiqueta del distrito principal.
  String get primaryDistrict =>
      preferredDistricts.isNotEmpty ? preferredDistricts.first : 'No especificado';

  RoommateProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? avatar,
    String? university,
    String? career,
    int? semester,
    String? bio,
    List<String>? lifestyleTags,
    List<String>? interests,
    String? budgetRange,
    List<String>? preferredDistricts,
    int? cleanlinessLevel,
    int? socialLevel,
    int? studyLevel,
    SleepSchedule? sleepSchedule,
    bool? isVerified,
    double? compatibilityScore,
    List<String>? photos,
  }) {
    return RoommateProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      university: university ?? this.university,
      career: career ?? this.career,
      semester: semester ?? this.semester,
      bio: bio ?? this.bio,
      lifestyleTags: lifestyleTags ?? this.lifestyleTags,
      interests: interests ?? this.interests,
      budgetRange: budgetRange ?? this.budgetRange,
      preferredDistricts: preferredDistricts ?? this.preferredDistricts,
      cleanlinessLevel: cleanlinessLevel ?? this.cleanlinessLevel,
      socialLevel: socialLevel ?? this.socialLevel,
      studyLevel: studyLevel ?? this.studyLevel,
      sleepSchedule: sleepSchedule ?? this.sleepSchedule,
      isVerified: isVerified ?? this.isVerified,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      photos: photos ?? this.photos,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static List<RoommateProfile> mockProfiles() {
    return [
      RoommateProfile(
        id: 'rm-001',
        name: 'Alejandra Soto',
        age: 21,
        avatar: 'AS',
        university: 'Universidad Nacional de San Antonio Abad del Cusco',
        career: 'Enfermería',
        semester: 6,
        bio:
            'Estudiante de enfermería, muy organizada y respetuosa. Me levanto temprano para prácticas en el hospital. En mis tiempos libres me gusta leer y hacer yoga. Busco compañera que valore el orden y la tranquilidad para estudiar. No fumo y prefiero un ambiente sin fiestas entre semana.',
        lifestyleTags: ['Organizada', 'Saludable', 'Madruguadora', 'Sin fiestas'],
        interests: ['Yoga', 'Lectura', 'Cocina saludable', 'Running'],
        budgetRange: 'S/ 500-750',
        preferredDistricts: ['Wanchaq', 'Santiago'],
        cleanlinessLevel: 5,
        socialLevel: 3,
        studyLevel: 5,
        sleepSchedule: SleepSchedule.early,
        isVerified: true,
        compatibilityScore: 88,
        photos: [
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-002',
        name: 'Sebastián Ccama',
        age: 20,
        avatar: 'SC',
        university: 'Universidad Nacional de San Antonio Abad del Cusco',
        career: 'Ingeniería Civil',
        semester: 4,
        bio:
            'Ingeniero en formación y músico de corazón. Toco la guitarra en mi tiempo libre (con auriculares, prometo). Me gusta cocinar platos fusión andinos. Busco compa que no le moleste que a veces estudio hasta tarde. Soy limpio con las áreas comunes pero mi cuarto es mi reino.',
        lifestyleTags: ['Músico', 'Cocinero', 'Trasnochador', 'Andino'],
        interests: ['Guitarra', 'Cocina andina', 'Fútbol', 'Cerveza artesanal'],
        budgetRange: 'S/ 400-600',
        preferredDistricts: ['Wanchaq', 'Santa Mónica'],
        cleanlinessLevel: 3,
        socialLevel: 5,
        studyLevel: 3,
        sleepSchedule: SleepSchedule.late,
        isVerified: true,
        compatibilityScore: 72,
        photos: [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-003',
        name: 'Yuki Tanaka',
        age: 22,
        avatar: 'YT',
        university: 'UNSAAC (Intercambio)',
        career: 'Antropología',
        semester: 8,
        bio:
            'Exchange student from Tokyo University. I came to Cusco to study Andean anthropology and learn about Inca culture. I speak Spanish, English, Japanese and I\'m learning Quechua! I love hiking and trying new foods. I\'m very tidy (it\'s a Japanese thing 😅) and respectful of shared spaces.',
        lifestyleTags: ['Internacional', 'Cultural', 'Ordenado', 'Aventurero'],
        interests: ['Antropología', 'Hiking', 'Fotografía', 'Quechua', 'Cocina japonesa'],
        budgetRange: 'S/ 600-1000',
        preferredDistricts: ['Cusco Centro', 'San Blas', 'Wanchaq'],
        cleanlinessLevel: 5,
        socialLevel: 4,
        studyLevel: 4,
        sleepSchedule: SleepSchedule.normal,
        isVerified: true,
        compatibilityScore: 82,
        photos: [
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-004',
        name: 'María Fernanda Huanca',
        age: 19,
        avatar: 'MH',
        university: 'Universidad Andina del Cusco',
        career: 'Psicología',
        semester: 2,
        bio:
            'Recién entré a la universidad y estoy super emocionada. Soy de Abancay y es mi primera vez viviendo sola. Me gustaría vivir con alguien que me ayude a adaptarme al Cusco. Soy súper friendly y me encanta el karaoke los fines de semana. Tengo un gatito llamado Michi que es mi vida.',
        lifestyleTags: ['Amigable', 'Karaoke', 'Novata', 'Amante de gatos'],
        interests: ['Karaoke', 'Series', 'Gatos', 'Chocolate', 'TikTok'],
        budgetRange: 'S/ 350-550',
        preferredDistricts: ['Wanchaq', 'San Sebastián'],
        cleanlinessLevel: 3,
        socialLevel: 5,
        studyLevel: 2,
        sleepSchedule: SleepSchedule.late,
        isVerified: false,
        compatibilityScore: 65,
        photos: [
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-005',
        name: 'Ricardo Delgado',
        age: 24,
        avatar: 'RD',
        university: 'Universidad Nacional de San Antonio Abad del Cusco',
        career: 'Derecho',
        semester: 10,
        bio:
            'Estoy en los últimos ciclos de derecho y preparando mi tesis. Necesito un ambiente tranquilo y sin distracciones. Fui presidente del centro de estudiantes así que sé convivir con todo tipo de personas. Los domingos cocino un seco de cordero que es la envidia del barrio.',
        lifestyleTags: ['Estudioso', 'Líder', 'Cocinero', 'Tranquilo'],
        interests: ['Debate', 'Cocina peruana', 'Política', 'Ajedrez'],
        budgetRange: 'S/ 450-650',
        preferredDistricts: ['Santiago', 'Wanchaq'],
        cleanlinessLevel: 4,
        socialLevel: 3,
        studyLevel: 5,
        sleepSchedule: SleepSchedule.normal,
        isVerified: true,
        compatibilityScore: 79,
        photos: [
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-006',
        name: 'Isabella Rossi',
        age: 23,
        avatar: 'IR',
        university: 'UNSAAC (Intercambio)',
        career: 'Gastronomía',
        semester: 6,
        bio:
            'Italiana de Milán estudiando gastronomía andina en el Cusco. ¡La comida peruana es la mejor del mundo! Me encanta experimentar fusiones italo-andinas. Siempre cocino de más así que mi compañero siempre come bien. Muy limpia y organizada. Hablo italiano, español e inglés.',
        lifestyleTags: ['Internacional', 'Gastrónoma', 'Organizada', 'Cocinera'],
        interests: ['Gastronomía', 'Vino', 'Fotografía culinaria', 'Viajes'],
        budgetRange: 'S/ 700-1100',
        preferredDistricts: ['San Blas', 'Cusco Centro'],
        cleanlinessLevel: 4,
        socialLevel: 4,
        studyLevel: 3,
        sleepSchedule: SleepSchedule.normal,
        isVerified: true,
        compatibilityScore: 76,
        photos: [
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-007',
        name: 'Johan Mendoza',
        age: 20,
        avatar: 'JM',
        university: 'Universidad Tecnológica del Perú - Cusco',
        career: 'Ingeniería Industrial',
        semester: 3,
        bio:
            'Gamer y programador. Paso horas en la computadora pero sé respetar los horarios de sueño. Busco roommate que también le guste el gaming o al menos que no le moleste. Los fines de semana organizo torneos de Smash Bros en la sala. Trabajo medio tiempo remoto así que casi siempre estoy en casa.',
        lifestyleTags: ['Gamer', 'Programador', 'Nocturno', 'Remote'],
        interests: ['Gaming', 'Programación', 'Anime', 'eSports'],
        budgetRange: 'S/ 400-550',
        preferredDistricts: ['Wanchaq', 'Santa Mónica'],
        cleanlinessLevel: 2,
        socialLevel: 3,
        studyLevel: 3,
        sleepSchedule: SleepSchedule.nightOwl,
        isVerified: true,
        compatibilityScore: 55,
        photos: [
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-008',
        name: 'Camila Urquiaga',
        age: 22,
        avatar: 'CU',
        university: 'Universidad Nacional de San Antonio Abad del Cusco',
        career: 'Arquitectura',
        semester: 7,
        bio:
            'Arquitecta en formación, obsesionada con el diseño y la organización. Mi cuarto siempre está impecable y decorado con plantas y láminas de arquitectura colonial. Me despierto temprano para correr por la ciudad y dibujar. Busco compañera que comparta mi amor por el orden y las plantas.',
        lifestyleTags: ['Diseño', 'Organizada', 'Runner', 'Plantas'],
        interests: ['Arquitectura', 'Running', 'Dibujo', 'Plantas', 'Café'],
        budgetRange: 'S/ 550-800',
        preferredDistricts: ['Wanchaq', 'San Blas'],
        cleanlinessLevel: 5,
        socialLevel: 2,
        studyLevel: 5,
        sleepSchedule: SleepSchedule.early,
        isVerified: true,
        compatibilityScore: 92,
        photos: [
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-009',
        name: 'Pierre Leclerc',
        age: 21,
        avatar: 'PL',
        university: 'UNSAAC (Intercambio)',
        career: 'Historia del Arte',
        semester: 4,
        bio:
            'French student from Sorbonne, passionate about colonial art and Inca history. I chose Cusco because it\'s a living museum! I\'m learning Spanish (still making mistakes, sorry 🙈). Very chill and respectful. I love cooking French crêpes and I\'m always happy to share. Je suis très propre!',
        lifestyleTags: ['Francés', 'Cultural', 'Artista', 'Respetuoso'],
        interests: ['Historia del arte', 'Pintura', 'Crêpes', 'Museos', 'Vino'],
        budgetRange: 'S/ 600-950',
        preferredDistricts: ['San Blas', 'Cusco Centro', 'San Cristóbal'],
        cleanlinessLevel: 4,
        socialLevel: 4,
        studyLevel: 4,
        sleepSchedule: SleepSchedule.normal,
        isVerified: true,
        compatibilityScore: 74,
        photos: [
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
        ],
      ),
      RoommateProfile(
        id: 'rm-010',
        name: 'Lucía Pacheco',
        age: 20,
        avatar: 'LP',
        university: 'Le Cordon Bleu Cusco',
        career: 'Artes Culinarias',
        semester: 3,
        bio:
            'Future chef studying at Le Cordon Bleu. La cocina es mi vida y mi pasión. Si compartimos departamento, te garantizo que nunca comerás mal. Soy de Arequipa y extraño la comida de mi tierra, así que cocino alot para sentirme en casa. Muy limpia en la cocina (profesional obligation). Busco alguien tolerante con aromas de cocina.',
        lifestyleTags: ['Chef', 'Arequipeña', 'Apasionada', 'Limpia'],
        interests: ['Cocina gourmet', 'Repostería', 'Mercados locales', 'Pisco'],
        budgetRange: 'S/ 500-700',
        preferredDistricts: ['Wanchaq', 'Cusco Centro'],
        cleanlinessLevel: 4,
        socialLevel: 4,
        studyLevel: 3,
        sleepSchedule: SleepSchedule.normal,
        isVerified: true,
        compatibilityScore: 70,
        photos: [
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400',
        ],
      ),
    ];
  }
}
