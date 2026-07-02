import 'package:flutter/material.dart';

/// Modelo de usuario para la aplicación WasiStudent.
/// Representa a un estudiante que busca o ofrece alojamiento en Cusco.

class NotificationSettings {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool smsEnabled;
  final bool newMatches;
  final bool messages;
  final bool priceChanges;
  final bool promotions;
  final bool trustUpdates;
  final bool reviewNotifications;
  final bool paymentReminders;

  const NotificationSettings({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.newMatches = true,
    this.messages = true,
    this.priceChanges = true,
    this.promotions = false,
    this.trustUpdates = true,
    this.reviewNotifications = true,
    this.paymentReminders = true,
  });

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? smsEnabled,
    bool? newMatches,
    bool? messages,
    bool? priceChanges,
    bool? promotions,
    bool? trustUpdates,
    bool? reviewNotifications,
    bool? paymentReminders,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      newMatches: newMatches ?? this.newMatches,
      messages: messages ?? this.messages,
      priceChanges: priceChanges ?? this.priceChanges,
      promotions: promotions ?? this.promotions,
      trustUpdates: trustUpdates ?? this.trustUpdates,
      reviewNotifications: reviewNotifications ?? this.reviewNotifications,
      paymentReminders: paymentReminders ?? this.paymentReminders,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar; // Iniciales
  final String bio;

  final String university;
  final String career;
  final int semester;

  final DateTime birthDate;
  final String gender;
  final String nationality;

  final bool isVerified;
  final int verificationLevel; // 0-3

  final int trustScore; // 0-100
  final DateTime memberSince;
  final DateTime lastActive;

  final String? preferredDistrict;
  final double? budget;

  final List<String> lifestyleTags;

  final String? emergencyContact;
  final String? emergencyPhone;

  final NotificationSettings settings;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    this.bio = '',
    this.university = '',
    this.career = '',
    this.semester = 1,
    required this.birthDate,
    this.gender = '',
    this.nationality = 'Peruana',
    this.isVerified = false,
    this.verificationLevel = 0,
    this.trustScore = 0,
    required this.memberSince,
    required this.lastActive,
    this.preferredDistrict,
    this.budget,
    this.lifestyleTags = const [],
    this.emergencyContact,
    this.emergencyPhone,
    this.settings = const NotificationSettings(),
  });

  // ── Computed Getters ──────────────────────────────────────────────

  int get age {
    final now = DateTime.now();
    int calculatedAge = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  String get universityShort {
    if (university.contains('Nacional')) return 'UNSAAC';
    if (university.contains('Andina')) return 'UANDINA';
    if (university.contains('Católica')) return 'UCSP';
    if (university.contains('Tecnológica')) return 'UTP';
    return university;
  }

  String get memberSinceFormatted {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${months[memberSince.month - 1]} ${memberSince.year}';
  }

  String get lastActiveFormatted {
    final diff = DateTime.now().difference(lastActive);
    if (diff.inMinutes < 5) return 'En línea';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'Hace ${diff.inDays} d';
    return 'Hace más de una semana';
  }

  bool get isOnline => DateTime.now().difference(lastActive).inMinutes < 5;

  Color get verificationColor {
    switch (verificationLevel) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  String get budgetFormatted =>
      budget != null ? 'S/ ${budget!.toStringAsFixed(0)}/mes' : 'No especificado';

  // ── copyWith ──────────────────────────────────────────────────────

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? bio,
    String? university,
    String? career,
    int? semester,
    DateTime? birthDate,
    String? gender,
    String? nationality,
    bool? isVerified,
    int? verificationLevel,
    int? trustScore,
    DateTime? memberSince,
    DateTime? lastActive,
    String? preferredDistrict,
    double? budget,
    List<String>? lifestyleTags,
    String? emergencyContact,
    String? emergencyPhone,
    NotificationSettings? settings,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      university: university ?? this.university,
      career: career ?? this.career,
      semester: semester ?? this.semester,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      isVerified: isVerified ?? this.isVerified,
      verificationLevel: verificationLevel ?? this.verificationLevel,
      trustScore: trustScore ?? this.trustScore,
      memberSince: memberSince ?? this.memberSince,
      lastActive: lastActive ?? this.lastActive,
      preferredDistrict: preferredDistrict ?? this.preferredDistrict,
      budget: budget ?? this.budget,
      lifestyleTags: lifestyleTags ?? this.lifestyleTags,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      settings: settings ?? this.settings,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static User getMockCurrentUser() {
    return User(
      id: 'user-001',
      name: 'Valentina Rojas Poma',
      email: 'valentina.rojas@unsaac.edu.pe',
      phone: '+51 984 555 123',
      avatar: 'VR',
      bio:
          'Estudiante de arquitectura de 6to ciclo. Amante del diseño, la fotografía y los paseos por San Blas. Busco un lugar tranquilo y cerca de la universidad donde pueda estudiar y crear. Me encantan las plantas y el café de altura cusqueño.',
      university: 'Universidad Nacional de San Antonio Abad del Cusco',
      career: 'Arquitectura',
      semester: 6,
      birthDate: DateTime(2003, 7, 22),
      gender: 'Femenino',
      nationality: 'Peruana',
      isVerified: true,
      verificationLevel: 2,
      trustScore: 78,
      memberSince: DateTime(2024, 3, 10),
      lastActive: DateTime.now(),
      preferredDistrict: 'Wanchaq',
      budget: 700,
      lifestyleTags: ['Creativa', 'Tranquila', 'Organizada', 'Amante del café'],
      emergencyContact: 'Patricia Poma',
      emergencyPhone: '+51 984 666 789',
      settings: const NotificationSettings(
        pushEnabled: true,
        emailEnabled: true,
        smsEnabled: false,
        newMatches: true,
        messages: true,
        priceChanges: true,
        promotions: false,
        trustUpdates: true,
        reviewNotifications: true,
        paymentReminders: true,
      ),
    );
  }

  // ── Serialización (Hive) ──────────────────────────────────────────

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      university: json['university'] as String? ?? '',
      career: json['career'] as String? ?? '',
      semester: json['semester'] as int? ?? 1,
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'] as String)
          : DateTime(2005, 1, 1),
      gender: json['gender'] as String? ?? '',
      nationality: json['nationality'] as String? ?? 'Peruana',
      isVerified: json['isVerified'] as bool? ?? false,
      verificationLevel: json['verificationLevel'] as int? ?? 0,
      trustScore: json['trustScore'] as int? ?? 0,
      memberSince: json['memberSince'] != null
          ? DateTime.parse(json['memberSince'] as String)
          : DateTime.now(),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : DateTime.now(),
      preferredDistrict: json['preferredDistrict'] as String?,
      budget: (json['budget'] as num?)?.toDouble(),
      lifestyleTags: List<String>.from(json['lifestyleTags'] as List? ?? []),
      emergencyContact: json['emergencyContact'] as String?,
      emergencyPhone: json['emergencyPhone'] as String?,
      settings: NotificationSettings(
        pushEnabled: json['settings_pushEnabled'] as bool? ?? true,
        emailEnabled: json['settings_emailEnabled'] as bool? ?? true,
        smsEnabled: json['settings_smsEnabled'] as bool? ?? false,
        newMatches: json['settings_newMatches'] as bool? ?? true,
        messages: json['settings_messages'] as bool? ?? true,
        priceChanges: json['settings_priceChanges'] as bool? ?? true,
        promotions: json['settings_promotions'] as bool? ?? false,
        trustUpdates: json['settings_trustUpdates'] as bool? ?? true,
        reviewNotifications: json['settings_reviewNotifications'] as bool? ?? true,
        paymentReminders: json['settings_paymentReminders'] as bool? ?? true,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'bio': bio,
      'university': university,
      'career': career,
      'semester': semester,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'nationality': nationality,
      'isVerified': isVerified,
      'verificationLevel': verificationLevel,
      'trustScore': trustScore,
      'memberSince': memberSince.toIso8601String(),
      'lastActive': lastActive.toIso8601String(),
      'preferredDistrict': preferredDistrict,
      'budget': budget,
      'lifestyleTags': lifestyleTags,
      'emergencyContact': emergencyContact,
      'emergencyPhone': emergencyPhone,
      'settings_pushEnabled': settings.pushEnabled,
      'settings_emailEnabled': settings.emailEnabled,
      'settings_smsEnabled': settings.smsEnabled,
      'settings_newMatches': settings.newMatches,
      'settings_messages': settings.messages,
      'settings_priceChanges': settings.priceChanges,
      'settings_promotions': settings.promotions,
      'settings_trustUpdates': settings.trustUpdates,
      'settings_reviewNotifications': settings.reviewNotifications,
      'settings_paymentReminders': settings.paymentReminders,
    };
  }
}
