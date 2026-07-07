import 'package:flutter/material.dart';

/// Colores centrales de la marca WasiStudent
/// Inspirados en la tierra, el cielo y la vitalidad del Cusco
class WasiColors {
  // ── Primario: Teal profundo ──
  static const Color primary = Color(0xFF574E32);
  static const Color primaryLight = Color(0xFF6B5E3F);
  static const Color primaryDark = Color(0xFF3D3622);
  static const Color primaryContainer = Color(0xFFD0ECEF);
  static const Color onPrimaryContainer = Color(0xFF0E2D33);

  // ── Acento: Oro cálido ──
  static const Color accent = Color(0xFF917521);
  static const Color accentLight = Color(0xFFB8942A);
  static const Color accentDark = Color(0xFF7A6219);
  static const Color secondaryContainer = Color(0xFFFFF3DB);
  static const Color onSecondaryContainer = Color(0xFF3D2E00);

  // ── Éxito: Turquesa fresco ──
  static const Color success = Color(0xFF438759);
  static const Color successLight = Color(0xFF5AA876);
  static const Color successDark = Color(0xFF356B47);
  static const Color successContainer = Color(0xFFD6F5F2);
  static const Color onSuccessContainer = Color(0xFF003733);

  // ── Error: Coral suave ──
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFF9494);
  static const Color errorDark = Color(0xFFE04545);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // ── Superficie claro ──
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF0F3F6);
  static const Color outlineLight = Color(0xFFD8DFE4);
  static const Color outlineVariantLight = Color(0xFFBCC6CE);

  // ── Superficie oscuro ──
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color surfaceDark = Color(0xFF1B2838);
  static const Color surfaceVariantDark = Color(0xFF243447);
  static const Color outlineDark = Color(0xFF3E4F63);
  static const Color outlineVariantDark = Color(0xFF2E3F52);

  // ── Texto ──
  static const Color textPrimaryLight = Color(0xFF1A2332);
  static const Color textSecondaryLight = Color(0xFF5A6B7F);
  static const Color textTertiaryLight = Color(0xFF8E9BAD);
  static const Color textPrimaryDark = Color(0xFFE8EDF2);
  static const Color textSecondaryDark = Color(0xFFA0B1C4);
  static const Color textTertiaryDark = Color(0xFF6B7F94);

  // ── Gradientes ──
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF917521), Color(0xFFFF6B6B)],
  );

  static const LinearGradient coolGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF574E32), Color(0xFF438759)],
  );
}

/// Tema principal de WasiStudent
class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────────
  //  TEMA CLARO
  // ──────────────────────────────────────────
  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: WasiColors.primary,
      onPrimary: Colors.white,
      primaryContainer: WasiColors.primaryContainer,
      onPrimaryContainer: WasiColors.onPrimaryContainer,
      secondary: WasiColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: WasiColors.secondaryContainer,
      onSecondaryContainer: WasiColors.onSecondaryContainer,
      tertiary: WasiColors.success,
      onTertiary: Colors.white,
      tertiaryContainer: WasiColors.successContainer,
      onTertiaryContainer: WasiColors.onSuccessContainer,
      error: WasiColors.error,
      onError: Colors.white,
      errorContainer: WasiColors.errorContainer,
      onErrorContainer: WasiColors.onErrorContainer,
      surface: WasiColors.surfaceLight,
      onSurface: WasiColors.textPrimaryLight,
      surfaceContainerHighest: WasiColors.surfaceVariantLight,
      outline: WasiColors.outlineLight,
      outlineVariant: WasiColors.outlineVariantLight,
      shadow: Colors.black.withValues(alpha: 0.08),
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  // ──────────────────────────────────────────
  //  TEMA OSCURO
  // ──────────────────────────────────────────
  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: WasiColors.primaryLight,
      onPrimary: Colors.white,
      primaryContainer: WasiColors.primaryDark,
      onPrimaryContainer: WasiColors.primaryContainer,
      secondary: WasiColors.accent,
      onSecondary: Colors.black,
      secondaryContainer: WasiColors.accentDark,
      onSecondaryContainer: WasiColors.secondaryContainer,
      tertiary: WasiColors.success,
      onTertiary: Colors.black,
      tertiaryContainer: WasiColors.successDark,
      onTertiaryContainer: WasiColors.successContainer,
      error: WasiColors.errorLight,
      onError: Colors.black,
      errorContainer: WasiColors.errorDark,
      onErrorContainer: WasiColors.errorContainer,
      surface: WasiColors.surfaceDark,
      onSurface: WasiColors.textPrimaryDark,
      surfaceContainerHighest: WasiColors.surfaceVariantDark,
      outline: WasiColors.outlineDark,
      outlineVariant: WasiColors.outlineVariantDark,
      shadow: Colors.black.withValues(alpha: 0.32),
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  // ──────────────────────────────────────────
  //  CONSTRUCTOR BASE
  // ──────────────────────────────────────────
  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      scaffoldBackgroundColor: isLight
          ? WasiColors.backgroundLight
          : WasiColors.backgroundDark,

      // ── Tipografía ──
      textTheme: TextTheme(
        // Display
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w800,
          height: 1.12,
          letterSpacing: -0.25,
          color: colorScheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          height: 1.16,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          height: 1.22,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        // Headline
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          height: 1.29,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          height: 1.33,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        // Title
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.27,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.5,
          letterSpacing: 0.15,
          color: colorScheme.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.43,
          letterSpacing: 0.1,
          color: colorScheme.onSurface,
        ),
        // Body
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.43,
          letterSpacing: 0.25,
          color: colorScheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.33,
          letterSpacing: 0.4,
          color: isLight ? WasiColors.textSecondaryLight : WasiColors.textSecondaryDark,
        ),
        // Label
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.43,
          letterSpacing: 0.1,
          color: colorScheme.onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          height: 1.33,
          letterSpacing: 0.5,
          color: colorScheme.onSurface,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.45,
          letterSpacing: 0.5,
          color: isLight ? WasiColors.textTertiaryLight : WasiColors.textTertiaryDark,
        ),
      ),

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: 24,
        ),
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: Colors.transparent,
        color: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isLight
                ? WasiColors.outlineLight.withValues(alpha: 0.5)
                : WasiColors.outlineDark.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: isLight
            ? WasiColors.surfaceVariantLight
            : WasiColors.surfaceVariantDark,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isLight
              ? WasiColors.textPrimaryLight
              : WasiColors.textPrimaryDark,
        ),
        secondaryLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isLight
                ? WasiColors.outlineLight
                : WasiColors.outlineDark,
            width: 1,
          ),
        ),
        side: BorderSide.none,
      ),

      // ── Bottom Navigation ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isLight
            ? WasiColors.textTertiaryLight
            : WasiColors.textTertiaryDark,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        elevation: 8,
      ),

      // ── Input Decoration ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? WasiColors.surfaceVariantLight.withValues(alpha: 0.6)
            : WasiColors.surfaceVariantDark.withValues(alpha: 0.6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isLight
                ? WasiColors.outlineLight
                : WasiColors.outlineDark,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isLight
              ? WasiColors.textSecondaryLight
              : WasiColors.textSecondaryDark,
        ),
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isLight
              ? WasiColors.textTertiaryLight
              : WasiColors.textTertiaryDark,
        ),
        prefixIconColor: isLight
            ? WasiColors.textSecondaryLight
            : WasiColors.textSecondaryDark,
        suffixIconColor: isLight
            ? WasiColors.textSecondaryLight
            : WasiColors.textSecondaryDark,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),

      // ── FAB ──
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 6,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
        showDragHandle: true,
        dragHandleColor: isLight
            ? WasiColors.outlineVariantLight
            : WasiColors.outlineVariantDark,
      ),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: isLight
              ? WasiColors.textSecondaryLight
              : WasiColors.textSecondaryDark,
        ),
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight
            ? WasiColors.textPrimaryLight
            : WasiColors.textPrimaryDark,
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isLight ? Colors.white : Colors.black,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        actionTextColor: WasiColors.accent,
      ),

      // ── Tab Bar ──
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: isLight
            ? WasiColors.textTertiaryLight
            : WasiColors.textTertiaryDark,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: colorScheme.primary,
        dividerColor: isLight
            ? WasiColors.outlineLight
            : WasiColors.outlineDark,
      ),

      // ── Slider ──
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: isLight
            ? WasiColors.outlineLight
            : WasiColors.outlineDark,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withValues(alpha: 0.12),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // ── Switch ──
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return isLight ? Colors.white : WasiColors.textTertiaryDark;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isLight
              ? WasiColors.outlineLight
              : WasiColors.outlineDark;
        }),
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // ── Icon Button ──
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: isLight
              ? WasiColors.textSecondaryLight
              : WasiColors.textSecondaryDark,
          iconSize: 24,
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: isLight
            ? WasiColors.outlineLight
            : WasiColors.outlineDark,
        thickness: 1,
        space: 1,
      ),

      // ── Progress Indicator ──
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: isLight
            ? WasiColors.outlineLight
            : WasiColors.outlineDark,
        circularTrackColor: Colors.transparent,
      ),

      // ── Popup Menu ──
      popupMenuTheme: PopupMenuThemeData(
        color: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          );
        }),
      ),

      // ── Tooltip ──
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isLight
              ? WasiColors.textPrimaryLight
              : WasiColors.textPrimaryDark,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isLight ? Colors.white : Colors.black,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),

      // ── Badge ──
      badgeTheme: BadgeThemeData(
        backgroundColor: WasiColors.error,
        textColor: Colors.white,
        smallSize: 8,
        largeSize: 20,
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),

      // ── Navigation Bar (Material 3) ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: isSelected ? 12 : 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.1,
            color: isSelected
                ? colorScheme.primary
                : isLight
                    ? WasiColors.textTertiaryLight
                    : WasiColors.textTertiaryDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: isSelected ? 26 : 24,
            color: isSelected
                ? colorScheme.primary
                : isLight
                    ? WasiColors.textTertiaryLight
                    : WasiColors.textTertiaryDark,
          );
        }),
        elevation: 0,
        height: 64,
      ),

      // ── Scrollbar ──
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(6),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return colorScheme.primary;
          }
          return isLight
              ? WasiColors.outlineVariantLight
              : WasiColors.outlineVariantDark;
        }),
      ),

      // ── List Tile ──
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: isLight
              ? WasiColors.textSecondaryLight
              : WasiColors.textSecondaryDark,
        ),
      ),

      // ── Search Bar ──
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(
          isLight
              ? WasiColors.surfaceVariantLight
              : WasiColors.surfaceVariantDark,
        ),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        hintStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: isLight
                ? WasiColors.textTertiaryLight
                : WasiColors.textTertiaryDark,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),

      // ── Drawer ──
      drawerTheme: DrawerThemeData(
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
      ),

      // ── Time Picker ──
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        hourMinuteTextColor: colorScheme.primary,
        dayPeriodTextColor: colorScheme.primary,
      ),

      // ── Date Picker ──
      datePickerTheme: DatePickerThemeData(
        backgroundColor: isLight ? WasiColors.surfaceLight : WasiColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        dayStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

/// Sombras predefinidas para un look consistente
class WasiShadows {
  static List<BoxShadow> soft({bool isLight = true}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isLight ? 0.06 : 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> medium({bool isLight = true}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isLight ? 0.08 : 0.28),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> strong({bool isLight = true}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isLight ? 0.12 : 0.36),
          blurRadius: 32,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> card({bool isLight = true}) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isLight ? 0.04 : 0.16),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> button({bool isLight = true}) => [
        BoxShadow(
          color: WasiColors.primary.withValues(alpha: isLight ? 0.2 : 0.4),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}

/// Radios de borde consistentes
class WasiRadius {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;

  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius bottomSheet = BorderRadius.vertical(top: Radius.circular(xxl));
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius avatar = BorderRadius.all(Radius.circular(full));
  static const BorderRadius thumbnail = BorderRadius.all(Radius.circular(sm));
}

/// Espaciado consistente
class WasiSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 48;

  // ── EdgeInsets comunes ──
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets screenV = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets screenAll = EdgeInsets.all(lg);
  static const EdgeInsets cardH = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets cardAll = EdgeInsets.all(lg);
  static const EdgeInsets itemH = EdgeInsets.symmetric(horizontal: lg, vertical: sm);
  static const EdgeInsets buttonH = EdgeInsets.symmetric(horizontal: xl, vertical: md);
}

/// Duraciones de animación
class WasiDuration {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration shimmer = Duration(milliseconds: 1500);
}

/// Curvas de animación
class WasiCurves {
  static const Curve easeOutCubic = Cubic(0.33, 1, 0.68, 1);
  static const Curve easeInOutCubic = Cubic(0.65, 0, 0.35, 1);
  static const Curve easeOutBack = Cubic(0.34, 1.56, 0.64, 1);
  static const Curve decelerate = Cubic(0, 0, 0.2, 1);
}
