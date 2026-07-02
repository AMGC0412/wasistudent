/// Utilidades de formateo para WasiStudent.
///
/// Proporciona formateadores consistentes para precios, distancias,
/// tiempos, fechas y otros valores comunes en la aplicación.
/// Todos los textos están en español.
///
/// Uso: `F.price(650)` → `'S/ 650'`
class F {
  F._();

  // ── Precios y moneda ───────────────────────────────────────────────

  /// Formatea un precio en soles peruanos.
  ///
  /// Ejemplos:
  /// - `F.price(650.0)` → `'S/ 650'`
  /// - `F.price(1234.5)` → `'S/ 1,235'`
  /// - `F.price(0.0)` → `'Gratis'`
  static String price(double v) {
    if (v == 0) return 'Gratis';
    return 'S/ ${_addThousandsSeparator(v.round())}';
  }

  /// Formatea un rango de precios.
  ///
  /// Ejemplo: `F.priceRange(400, 800)` → `'S/ 400 - S/ 800'`
  static String priceRange(double min, double max) {
    return '${price(min)} - ${price(max)}';
  }

  /// Formatea un precio con período.
  ///
  /// Ejemplo: `F.pricePerMonth(650)` → `'S/ 650/mes'`
  static String pricePerMonth(double v) {
    return '${price(v)}/mes';
  }

  /// Formatea un precio con decimales detallados.
  ///
  /// Ejemplo: `F.priceDetailed(650.50)` → `'S/ 650.50'`
  static String priceDetailed(double v) {
    if (v == 0) return 'Gratis';
    final parts = v.toStringAsFixed(2).split('.');
    final integerPart = _addThousandsSeparator(int.parse(parts[0]));
    return 'S/ $integerPart.${parts[1]}';
  }

  // ── Distancia ──────────────────────────────────────────────────────

  /// Formatea una distancia en metros a una cadena legible.
  ///
  /// - `F.distance(350)` → `'350 m'`
  /// - `F.distance(1200)` → `'1.2 km'`
  static String distance(double m) {
    if (m < 0) return '0 m';
    if (m < 1000) {
      return '${m.round()} m';
    }
    return '${(m / 1000).toStringAsFixed(1)} km';
  }

  /// Formatea una distancia en kilómetros.
  ///
  /// - `F.distanceKm(1.5)` → `'1.5 km'`
  /// - `F.distanceKm(0.3)` → `'300 m'`
  static String distanceKm(double km) {
    return distance(km * 1000);
  }

  // ── Tiempo de caminata ─────────────────────────────────────────────

  /// Formatea un tiempo en minutos como tiempo de caminata.
  ///
  /// - `F.walkingTime(15)` → `'15 min'`
  /// - `F.walkingTime(90)` → `'1 h 30 min'`
  static String walkingTime(num min) {
    if (min < 0) return '0 min';
    if (min < 60) return '${min.round()} min';
    final hours = min ~/ 60;
    final remaining = (min % 60).round();
    if (remaining == 0) return '$hours h';
    return '$hours h $remaining min';
  }

  /// Formatea un tiempo de caminata con texto descriptivo.
  ///
  /// - `F.walkingTimeLabel(5)` → `'5 min caminando'`
  /// - `F.walkingTimeLabel(90)` → `'1 h 30 min caminando'`
  static String walkingTimeLabel(num min) {
    return '${walkingTime(min)} caminando';
  }

  // ── Porcentaje ─────────────────────────────────────────────────────

  /// Formatea un valor como porcentaje.
  ///
  /// - `F.pct(85.5)` → `'86%'`
  /// - `F.pct(0.0)` → `'0%'`
  static String pct(double v) {
    return '${v.round()}%';
  }

  /// Formatea un valor como porcentaje con un decimal.
  ///
  /// - `F.pctDetailed(85.56)` → `'85.6%'`
  static String pctDetailed(double v) {
    return '${v.toStringAsFixed(1)}%';
  }

  // ── Fechas ─────────────────────────────────────────────────────────

  /// Formatea una fecha en formato corto: 'DD/MM/YYYY'
  ///
  /// Ejemplo: `F.date(DateTime(2025, 3, 15))` → `'15/03/2025'`
  static String date(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/'
        '${d.month.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  /// Formatea una fecha en formato largo: 'D de mes de YYYY'
  ///
  /// Ejemplo: `F.dateLong(DateTime(2025, 3, 15))` → `'15 de marzo de 2025'`
  static String dateLong(DateTime d) {
    return '${d.day} de ${_monthName(d.month)} de ${d.year}';
  }

  /// Formatea una fecha con mes corto: 'DD mes YYYY'
  ///
  /// Ejemplo: `F.dateMedium(DateTime(2025, 3, 15))` → `'15 mar 2025'`
  static String dateMedium(DateTime d) {
    return '${d.day} ${_monthNameShort(d.month)} ${d.year}';
  }

  /// Formatea una fecha relativa: 'Hace X min/horas/días'
  ///
  /// - Menos de 1 min: 'Justo ahora'
  /// - Menos de 60 min: 'Hace X min'
  /// - Menos de 24 h: 'Hace X horas'
  /// - Menos de 7 días: 'Hace X días'
  /// - Menos de 30 días: 'Hace X semanas'
  /// - Más: fecha corta
  static String timeAgo(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);

    if (diff.isNegative) return 'Justo ahora';

    if (diff.inSeconds < 60) return 'Justo ahora';
    if (diff.inMinutes < 60) {
      return diff.inMinutes == 1 ? 'Hace 1 min' : 'Hace ${diff.inMinutes} min';
    }
    if (diff.inHours < 24) {
      return diff.inHours == 1 ? 'Hace 1 hora' : 'Hace ${diff.inHours} horas';
    }
    if (diff.inDays < 7) {
      return diff.inDays == 1 ? 'Hace 1 día' : 'Hace ${diff.inDays} días';
    }
    if (diff.inDays < 30) {
      final weeks = diff.inDays ~/ 7;
      return weeks == 1 ? 'Hace 1 semana' : 'Hace $weeks semanas';
    }
    if (diff.inDays < 365) {
      final months = diff.inDays ~/ 30;
      return months == 1 ? 'Hace 1 mes' : 'Hace $months meses';
    }
    final years = diff.inDays ~/ 365;
    return years == 1 ? 'Hace 1 año' : 'Hace $years años';
  }

  /// Formatea una hora: 'HH:MM'
  static String time(DateTime d) {
    return '${d.hour.toString().padLeft(2, '0')}:'
        '${d.minute.toString().padLeft(2, '0')}';
  }

  /// Formatea fecha y hora: 'DD/MM/YYYY HH:MM'
  static String dateTime(DateTime d) {
    return '${date(d)} ${time(d)}';
  }

  // ── Teléfono ───────────────────────────────────────────────────────

  /// Formatea un número de teléfono peruano.
  ///
  /// Ejemplos:
  /// - `F.phone('984555123')` → `'984 555 123'`
  /// - `F.phone('+51984555123')` → `'+51 984 555 123'`
  static String phone(String p) {
    // Eliminar espacios y guiones existentes
    final clean = p.replaceAll(RegExp(r'[\s\-()]'), '');

    // Si empieza con +51 (Perú)
    if (clean.startsWith('+51') && clean.length >= 11) {
      final number = clean.substring(3);
      return '+51 ${_formatPeruvianNumber(number)}';
    }

    // Si empieza con 51 sin +
    if (clean.startsWith('51') && clean.length >= 10) {
      final number = clean.substring(2);
      return '+51 ${_formatPeruvianNumber(number)}';
    }

    // Número local peruano (9 dígitos)
    if (clean.length == 9 && clean.startsWith('9')) {
      return _formatPeruvianNumber(clean);
    }

    // Fallback: devolver el número con formato básico
    if (clean.length > 6) {
      final half = clean.length ~/ 2;
      return '${clean.substring(0, half)} ${clean.substring(half)}';
    }

    return p;
  }

  /// Formatea un número peruano de 9 dígitos.
  static String _formatPeruvianNumber(String number) {
    if (number.length == 9) {
      return '${number.substring(0, 3)} '
          '${number.substring(3, 6)} '
          '${number.substring(6)}';
    }
    return number;
  }

  // ── Rating ─────────────────────────────────────────────────────────

  /// Formatea un rating de 0-5 con un decimal.
  ///
  /// Ejemplo: `F.rating(4.56)` → `'4.6'`
  static String rating(double r) {
    return r.toStringAsFixed(1);
  }

  /// Formatea un rating con estrellas.
  ///
  /// Ejemplo: `F.ratingWithStars(4.5)` → `'4.5 ★'`
  static String ratingWithStars(double r) {
    return '${r.toStringAsFixed(1)} \u2605';
  }

  // ── Área ───────────────────────────────────────────────────────────

  /// Formatea un área en metros cuadrados.
  ///
  /// Ejemplo: `F.area(15.5)` → `'16 m²'`
  static String area(double sqm) {
    return '${sqm.round()} m\u00B2';
  }

  /// Formatea un área con decimales.
  ///
  /// Ejemplo: `F.areaDetailed(15.5)` → `'15.5 m²'`
  static String areaDetailed(double sqm) {
    return '${sqm.toStringAsFixed(1)} m\u00B2';
  }

  // ── Números compactos ──────────────────────────────────────────────

  /// Formatea un número grande en forma compacta.
  ///
  /// Ejemplos:
  /// - `F.compactNumber(500)` → `'500'`
  /// - `F.compactNumber(1200)` → `'1.2k'`
  /// - `F.compactNumber(1500000)` → `'1.5M'`
  static String compactNumber(int n) {
    if (n < 0) return '-${compactNumber(-n)}';
    if (n < 1000) return n.toString();
    if (n < 1000000) {
      final k = n / 1000.0;
      return k == k.roundToDouble()
          ? '${k.round()}k'
          : '${k.toStringAsFixed(1)}k';
    }
    if (n < 1000000000) {
      final m = n / 1000000.0;
      return m == m.roundToDouble()
          ? '${m.round()}M'
          : '${m.toStringAsFixed(1)}M';
    }
    final b = n / 1000000000.0;
    return b == b.roundToDouble()
        ? '${b.round()}B'
        : '${b.toStringAsFixed(1)}B';
  }

  // ── Helpers ────────────────────────────────────────────────────────

  /// Nombre completo del mes en español.
  static String _monthName(int month) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return months[month - 1];
  }

  /// Nombre corto del mes en español (3 letras).
  static String _monthNameShort(int month) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return months[month - 1];
  }

  /// Agrega separador de miles (coma) a un número entero.
  static String _addThousandsSeparator(int number) {
    final str = number.abs().toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
      count++;
    }

    final result = buffer.toString().split('').reversed.join();
    return number < 0 ? '-$result' : result;
  }
}
