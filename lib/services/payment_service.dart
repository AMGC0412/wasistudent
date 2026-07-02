import '../models/room.dart';
import '../models/payment.dart';

/// Servicio de pagos para WasiStudent.
/// Calcula costos totales, genera cronogramas de pagos,
/// formatea montos en soles peruanos (PEN) y traduce
/// métodos de pago comunes en Perú.
class PaymentService {
  // ── Cálculo de costos ──────────────────────────────────────────────

  /// Calcula el costo mensual total: alquiler + servicios.
  ///
  /// Si la habitación tiene [utilitiesCost] > 0, lo suma al precio base.
  /// Si no, asume que los servicios están incluidos en el alquiler.
  double calculateTotalMonthly(Room room) {
    return room.price + room.utilitiesCost;
  }

  /// Calcula el depósito de garantía (1 mes de alquiler).
  ///
  /// Si la habitación tiene un [depositAmount] definido, lo usa.
  /// Si no, calcula 1 mes del alquiler base.
  double calculateDeposit(Room room) {
    if (room.depositAmount > 0) return room.depositAmount;
    return room.price;
  }

  /// Calcula el costo inicial total (primer mes + depósito + servicios).
  double calculateInitialCost(Room room) {
    return calculateTotalMonthly(room) + calculateDeposit(room);
  }

  /// Calcula el costo total por un período de N meses, incluyendo
  /// el depósito inicial.
  double calculateTotalCost(Room room, int months) {
    return (calculateTotalMonthly(room) * months) + calculateDeposit(room);
  }

  /// Calcula el costo mensual por persona si se comparte la habitación.
  double calculatePerPerson(Room room, int people) {
    if (people <= 1) return calculateTotalMonthly(room);
    return calculateTotalMonthly(room) / people;
  }

  // ── Generación de cronograma de pagos ──────────────────────────────

  /// Genera un cronograma de pagos mensuales para una habitación.
  ///
  /// Parámetros:
  /// - [room]: La habitación a alquilar
  /// - [startDate]: Fecha de inicio del contrato
  /// - [months]: Número de meses del contrato
  ///
  /// Retorna una lista de [Payment] con:
  /// - El depósito inicial como primer pago
  /// - Los pagos mensuales de alquiler
  /// - Los pagos mensuales de servicios (si aplica)
  List<Payment> generatePaymentSchedule(
    Room room,
    DateTime startDate,
    int months,
  ) {
    final payments = <Payment>[];
    final deposit = calculateDeposit(room);
    final rentAmount = room.price;
    final utilitiesAmount = room.utilitiesCost;

    // 1. Depósito de garantía
    payments.add(Payment(
      id: '${room.id}-deposit',
      roomId: room.id,
      roomTitle: room.title,
      ownerId: room.ownerId,
      ownerName: room.ownerName,
      amount: deposit,
      currency: 'PEN',
      status: PaymentStatus.pending,
      dueDate: startDate,
      description: 'Depósito de garantía',
      month: startDate.month,
      year: startDate.year,
      isDeposit: true,
    ));

    // 2. Pagos mensuales
    for (int i = 0; i < months; i++) {
      DateTime paymentDate;
      int month;
      int year;

      if (i == 0) {
        // Primer mes: el día de inicio
        paymentDate = startDate;
        month = startDate.month;
        year = startDate.year;
      } else {
        // Meses siguientes: día 5 del mes correspondiente
        final nextMonth = DateTime(startDate.year, startDate.month + i);
        paymentDate = DateTime(nextMonth.year, nextMonth.month, 5);
        month = nextMonth.month;
        year = nextMonth.year;
      }

      // Alquiler mensual
      payments.add(Payment(
        id: '${room.id}-rent-${year}${month.toString().padLeft(2, '0')}',
        roomId: room.id,
        roomTitle: room.title,
        ownerId: room.ownerId,
        ownerName: room.ownerName,
        amount: rentAmount,
        currency: 'PEN',
        status: PaymentStatus.pending,
        dueDate: paymentDate,
        description: 'Alquiler mensual - ${_monthName(month)} $year',
        month: month,
        year: year,
        isDeposit: false,
        isUtilities: false,
      ));

      // Servicios mensuales (si aplica)
      if (utilitiesAmount > 0) {
        // Los servicios se pagan el día 10 del mes
        final utilitiesDate = DateTime(paymentDate.year, paymentDate.month, 10);
        payments.add(Payment(
          id:
              '${room.id}-utils-${year}${month.toString().padLeft(2, '0')}',
          roomId: room.id,
          roomTitle: room.title,
          ownerId: room.ownerId,
          ownerName: room.ownerName,
          amount: utilitiesAmount,
          currency: 'PEN',
          status: PaymentStatus.pending,
          dueDate: utilitiesDate,
          description:
              'Servicios (luz, agua, internet) - ${_monthName(month)} $year',
          month: month,
          year: year,
          isDeposit: false,
          isUtilities: true,
        ));
      }
    }

    return payments;
  }

  // ── Formateo de moneda ─────────────────────────────────────────────

  /// Formatea un monto en soles peruanos: 'S/ X'
  ///
  /// Ejemplos:
  /// - formatCurrency(650.0) → 'S/ 650'
  /// - formatCurrency(1234.5) → 'S/ 1,235'
  /// - formatCurrency(650.99) → 'S/ 651'
  String formatCurrency(double amount) {
    final rounded = amount.round();
    final formatted = _addThousandsSeparator(rounded);
    return 'S/ $formatted';
  }

  /// Formatea un monto con decimales: 'S/ X.XX'
  String formatCurrencyDetailed(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final integerPart = _addThousandsSeparator(int.parse(parts[0]));
    return 'S/ $integerPart.${parts[1]}';
  }

  /// Formatea un rango de precios: 'S/ 400 - S/ 800'
  String formatPriceRange(double min, double max) {
    return '${formatCurrency(min)} - ${formatCurrency(max)}';
  }

  /// Agrega separador de miles (coma) a un número entero.
  String _addThousandsSeparator(int number) {
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

  // ── Métodos de pago ────────────────────────────────────────────────

  /// Retorna el nombre en español del método de pago.
  ///
  /// Métodos soportados:
  /// - 'yape' → 'Yape'
  /// - 'plin' → 'Plin'
  /// - 'transfer' → 'Transferencia bancaria'
  /// - 'cash' → 'Efectivo'
  /// - 'card' → 'Tarjeta'
  String getPaymentMethodName(String method) {
    switch (method.toLowerCase()) {
      case 'yape':
        return 'Yape';
      case 'plin':
        return 'Plin';
      case 'transfer':
        return 'Transferencia bancaria';
      case 'cash':
        return 'Efectivo';
      case 'card':
        return 'Tarjeta';
      case 'deposit':
        return 'Depósito bancario';
      case 'bim':
        return 'Billetera BIM';
      default:
        return 'No especificado';
    }
  }

  /// Retorna una descripción corta del método de pago.
  String getPaymentMethodDescription(String method) {
    switch (method.toLowerCase()) {
      case 'yape':
        return 'Pago inmediato con Yape al número del propietario';
      case 'plin':
        return 'Pago inmediato con Plin al número del propietario';
      case 'transfer':
        return 'Transferencia interbancaria (puede tardar 1-2 horas)';
      case 'cash':
        return 'Pago en efectivo directamente al propietario';
      case 'card':
        return 'Pago con tarjeta de débito o crédito';
      case 'deposit':
        return 'Depósito en cuenta bancaria del propietario';
      case 'bim':
        return 'Pago desde billetera móvil BIM';
      default:
        return 'Método de pago no especificado';
    }
  }

  /// Retorna los métodos de pago más comunes en Perú.
  List<Map<String, String>> getCommonPaymentMethods() {
    return [
      {
        'id': 'yape',
        'name': getPaymentMethodName('yape'),
        'description': getPaymentMethodDescription('yape'),
        'icon': 'phone_android',
      },
      {
        'id': 'plin',
        'name': getPaymentMethodName('plin'),
        'description': getPaymentMethodDescription('plin'),
        'icon': 'phone_iphone',
      },
      {
        'id': 'transfer',
        'name': getPaymentMethodName('transfer'),
        'description': getPaymentMethodDescription('transfer'),
        'icon': 'account_balance',
      },
      {
        'id': 'cash',
        'name': getPaymentMethodName('cash'),
        'description': getPaymentMethodDescription('cash'),
        'icon': 'payments',
      },
    ];
  }

  // ── Resumen de pagos ───────────────────────────────────────────────

  /// Genera un resumen de los pagos de un cronograma.
  PaymentSummary summarizePayments(List<Payment> payments) {
    double totalRent = 0;
    double totalUtilities = 0;
    double totalDeposits = 0;
    int paidCount = 0;
    int pendingCount = 0;
    int overdueCount = 0;

    for (final payment in payments) {
      if (payment.isDeposit) {
        totalDeposits += payment.amount;
      } else if (payment.isUtilities) {
        totalUtilities += payment.amount;
      } else {
        totalRent += payment.amount;
      }

      switch (payment.status) {
        case PaymentStatus.paid:
        case PaymentStatus.refunded:
          paidCount++;
          break;
        case PaymentStatus.pending:
          pendingCount++;
          break;
        case PaymentStatus.overdue:
          overdueCount++;
          break;
        case PaymentStatus.cancelled:
          break;
      }
    }

    return PaymentSummary(
      totalRent: totalRent,
      totalUtilities: totalUtilities,
      totalDeposits: totalDeposits,
      totalAmount: totalRent + totalUtilities + totalDeposits,
      paidCount: paidCount,
      pendingCount: pendingCount,
      overdueCount: overdueCount,
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────

  /// Nombre del mes en español.
  String _monthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return months[month - 1];
  }
}

/// Resumen de pagos generado por [PaymentService.summarizePayments].
class PaymentSummary {
  final double totalRent;
  final double totalUtilities;
  final double totalDeposits;
  final double totalAmount;
  final int paidCount;
  final int pendingCount;
  final int overdueCount;

  const PaymentSummary({
    required this.totalRent,
    required this.totalUtilities,
    required this.totalDeposits,
    required this.totalAmount,
    required this.paidCount,
    required this.pendingCount,
    required this.overdueCount,
  });

  int get totalCount => paidCount + pendingCount + overdueCount;

  String get totalRentFormatted => 'S/ ${totalRent.toStringAsFixed(0)}';
  String get totalUtilitiesFormatted =>
      'S/ ${totalUtilities.toStringAsFixed(0)}';
  String get totalDepositsFormatted =>
      'S/ ${totalDeposits.toStringAsFixed(0)}';
  String get totalAmountFormatted =>
      'S/ ${totalAmount.toStringAsFixed(0)}';

  bool get hasOverdue => overdueCount > 0;
  bool get allPaid => pendingCount == 0 && overdueCount == 0;
}
