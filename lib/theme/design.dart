import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const Color primary50 = Color(0xFFFBEDEB);
  static const Color primary100 = Color(0xFFF4D3CE);
  static const Color primary200 = Color(0xFFE89D92);
  static const Color primaryLight = Color(0xFFE07A5F);
  static const Color primary400 = Color(0xFFD05A45);
  static const Color primary500 = Color(0xFFC44536);
  static const Color primary600 = Color(0xFFA8362A);
  static const Color primaryDark = Color(0xFF8B2C20);
  static const Color primary800 = Color(0xFF6B2018);
  static const Color primary900 = Color(0xFF4A1611);

  /// Verde andino — para confirmaciones y éxito.
  static const Color success = Color(0xFF2D6A4F);
  static const Color success50 = Color(0xFFE8F3EE);
  static const Color success100 = Color(0xFFC9E5D6);
  static const Color success200 = Color(0xFF95C9AE);
  static const Color successLight = Color(0xFF52B788);
  static const Color success400 = Color(0xFF3D8E68);
  static const Color success500 = Color(0xFF2D6A4F);
  static const Color success600 = Color(0xFF235540);
  static const Color successContainer = Color(0xFFD8F3DC);

  /// Ámbar dorado — para destacados y advertencias suaves.
  static const Color accent = Color(0xFFE9C46A);
  static const Color accentSoft = Color(0xFFF4E5BC);
  static const Color accentLight = Color(0xFFF4A261);
  static const Color warning = Color(0xFFE76F51);
  static const Color warningSoft = Color(0xFFFCE4DD);

  /// Azul profundo — para enlaces e información.
  static const Color info = Color(0xFF264653);
  static const Color infoLight = Color(0xFF2A9D8F);
  static const Color infoSoft = Color(0xFFD5E8E6);
  static const Color infoBg = Color(0xFFE7F0F2);

  /// Neutros cálidos (crema cusqueña, no blanco frío).
  static const Color background = Color(0xFFFBF7F0);
  static const Color background2 = Color(0xFFF5EDE0);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFFAF4E9);
  static const Color surface3 = Color(0xFFF2E9D8);
  static const Color surfaceVariant = Color(0xFFF5EDE0);
  static const Color outline = Color(0xFFE0D5C0);
  static const Color outlineSoft = Color(0xFFECE3D2);

  /// Texto
  static const Color textPrimary = Color(0xFF2D2418);
  static const Color textSecondary = Color(0xFF6B5D4F);
  static const Color textTertiary = Color(0xFFA0927F);
  static const Color textInverse = Color(0xFFFBF7F0);

  /// Estados
  static const Color error = Color(0xFFBC1A1A);
  static const Color errorContainer = Color(0xFFFDE0E0);

  // ── Tipografía ─────────────────────────────────────────────────────

  static const String fontFamily = 'Roboto';
  static const String fontDisplay = 'Plus Jakarta Sans';

  static TextStyle get displayLarge => const TextStyle(
        fontSize: 38,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        height: 1.2,
        letterSpacing: -0.3,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.25,
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

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textTertiary,
        height: 1.4,
      );

  static TextStyle get labelSmall => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textTertiary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.3,
      );

  // ── Radios ─────────────────────────────────────────────────────────

  static const double radiusXs = 6;
  static const double radiusSm = 10;
  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusXxl = 32;
  static const double radiusFull = 999;

  // ── Espaciado ──────────────────────────────────────────────────────

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 20;
  static const double spaceXxl = 24;
  static const double spaceXxxl = 32;
  static const double space4xl = 48;
  static const double space5xl = 64;

  // ── Sombras (cálidas, no negras) ───────────────────────────────────

  static List<BoxShadow> get shadowXs => [
        BoxShadow(
          color: const Color(0xFF4A1611).withValues(alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: const Color(0xFF4A1611).withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: const Color(0xFF4A1611).withValues(alpha: 0.10),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: const Color(0xFF4A1611).withValues(alpha: 0.14),
          blurRadius: 40,
          offset: const Offset(0, 14),
        ),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: const Color(0xFF4A1611).withValues(alpha: 0.20),
          blurRadius: 60,
          offset: const Offset(0, 24),
        ),
      ];

  static List<BoxShadow> get shadowPrimary => [
        BoxShadow(
          color: primary.withValues(alpha: 0.32),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowSuccess => [
        BoxShadow(
          color: success.withValues(alpha: 0.28),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  // ── Duraciones y curvas ────────────────────────────────────────────

  static const Duration durationFast = Duration(milliseconds: 140);
  static const Duration durationBase = Duration(milliseconds: 220);
  static const Duration durationSlow = Duration(milliseconds: 380);
  static const Duration durationSpring = Duration(milliseconds: 480);

  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveSpring = Curves.easeOutBack;

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
          systemOverlayStyle: SystemUiOverlayStyle.dark,
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
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: outline, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: outline, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: error, width: 1.5),
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
              borderRadius: BorderRadius.circular(radiusSm),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: const BorderSide(color: outline, width: 1.5),
            padding: const EdgeInsets.symmetric(
              horizontal: spaceXl,
              vertical: spaceMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSm),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primary,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
        dividerTheme: const DividerThemeData(
          color: outlineSoft,
          thickness: 1,
          space: 1,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surface2,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusFull),
          ),
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

  // ── Helpers de gradiente ───────────────────────────────────────────

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );

  static const LinearGradient primaryGradientSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successLight],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );

  // ── Trust Score helpers ────────────────────────────────────────────

  static Color trustColor(int score) {
    if (score >= 75) return success;
    if (score >= 50) return warning;
    return error;
  }

  static String trustLabel(int score) {
    if (score >= 90) return 'Excelente';
    if (score >= 75) return 'Muy bueno';
    if (score >= 50) return 'Aceptable';
    return 'Bajo';
  }
}
