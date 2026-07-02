import 'package:flutter/material.dart';

/// Sistema de diseño refinado para WasiStudent MVP.
///
/// Paleta inspirada en los colores de Cusco:
/// - Terracota (adobe cusqueño) como acento principal
/// - Verde andino como confirmación
/// - Crema cálida como fondo
/// - Tipografía con buena legibilidad en altitud
class WasiDesign {
  WasiDesign._();

  // ── Paleta de colores ──────────────────────────────────────────────

  /// Terracota cusqueña — color principal de la marca.
  static const Color primary = Color(0xFFC44536);
  static const Color primaryLight = Color(0xFFE07A5F);
  static const Color primaryDark = Color(0xFF8B2C20);

  /// Verde andino — para confirmaciones y éxito.
  static const Color success = Color(0xFF2D6A4F);
  static const Color successLight = Color(0xFF52B788);
  static const Color successContainer = Color(0xFFD8F3DC);

  /// Ámbar dorado — para destacados y advertencias suaves.
  static const Color accent = Color(0xFFE9C46A);
  static const Color accentLight = Color(0xFFF4A261);
  static const Color warning = Color(0xFFE76F51);

  /// Azul profundo — para enlaces e información.
  static const Color info = Color(0xFF264653);
  static const Color infoLight = Color(0xFF2A9D8F);

  /// Neutros cálidos (crema cusqueña, no blanco frío).
  static const Color background = Color(0xFFFBF7F0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5EDE0);
  static const Color outline = Color(0xFFE0D5C0);

  /// Texto
  static const Color textPrimary = Color(0xFF2D2418);
  static const Color textSecondary = Color(0xFF6B5D4F);
  static const Color textTertiary = Color(0xFFA0927F);

  /// Estados
  static const Color error = Color(0xFFBC1A1A);
  static const Color errorContainer = Color(0xFFFDE0E0);

  // ── Tipografía ─────────────────────────────────────────────────────

  static const String fontFamily = 'Roboto';

  static TextStyle get displayLarge => const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textTertiary,
        letterSpacing: 0.5,
      );

  // ── Radios ─────────────────────────────────────────────────────────

  static const double radiusXs = 6;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;

  // ── Espaciado ──────────────────────────────────────────────────────

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double spaceXxl = 24;
  static const double spaceXxxl = 32;

  // ── Sombras ────────────────────────────────────────────────────────

  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // ── Tema completo ──────────────────────────────────────────────────

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: primary,
          secondary: accent,
          surface: surface,
          error: error,
          onPrimary: Colors.white,
          onSecondary: textPrimary,
          onSurface: textPrimary,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          foregroundColor: textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        cardTheme: CardThemeData(
          color: surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: BorderSide(color: outline, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMd),
            borderSide: const BorderSide(color: error, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spaceLg,
            vertical: spaceMd,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: spaceXl,
              vertical: spaceMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMd),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: primary, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: spaceXl,
              vertical: spaceMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMd),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primaryLight,
          secondary: accent,
          surface: const Color(0xFF1F1A14),
          error: error,
        ),
        scaffoldBackgroundColor: const Color(0xFF15110C),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF15110C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
}
