import 'package:flutter/material.dart';

/// Modelo de pagos para la aplicación WasiStudent.
/// Gestiona el seguimiento de alquileres, depósitos y servicios
/// para estudiantes en Cusco.

enum PaymentStatus { pending, paid, overdue, cancelled, refunded }

class Payment {
  final String id;
  final String roomId;
  final String roomTitle;
  final String ownerId;
  final String ownerName;

  final double amount;
  final String currency;
  final PaymentStatus status;

  final DateTime dueDate;
  final DateTime? paidDate;
  final String? paymentMethod;

  final String? receiptNumber;
  final String description;
  final int month;
  final int year;

  final bool isDeposit;
  final bool isUtilities;

  const Payment({
    required this.id,
    required this.roomId,
    required this.roomTitle,
    required this.ownerId,
    required this.ownerName,
    required this.amount,
    this.currency = 'PEN',
    required this.status,
    required this.dueDate,
    this.paidDate,
    this.paymentMethod,
    this.receiptNumber,
    this.description = '',
    required this.month,
    required this.year,
    this.isDeposit = false,
    this.isUtilities = false,
  });

  // ── Computed Getters ──────────────────────────────────────────────

  String get statusLabel {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.paid:
        return 'Pagado';
      case PaymentStatus.overdue:
        return 'Vencido';
      case PaymentStatus.cancelled:
        return 'Cancelado';
      case PaymentStatus.refunded:
        return 'Reembolsado';
    }
  }

  Color get statusColor {
    switch (status) {
      case PaymentStatus.pending:
        return const Color(0xFFFF9800); // Naranja
      case PaymentStatus.paid:
        return const Color(0xFF4CAF50); // Verde
      case PaymentStatus.overdue:
        return const Color(0xFFF44336); // Rojo
      case PaymentStatus.cancelled:
        return const Color(0xFF9E9E9E); // Gris
      case PaymentStatus.refunded:
        return const Color(0xFF2196F3); // Azul
    }
  }

  IconData get statusIcon {
    switch (status) {
      case PaymentStatus.pending:
        return Icons.schedule;
      case PaymentStatus.paid:
        return Icons.check_circle;
      case PaymentStatus.overdue:
        return Icons.error;
      case PaymentStatus.cancelled:
        return Icons.cancel;
      case PaymentStatus.refunded:
        return Icons.replay;
    }
  }

  String get formattedAmount => 'S/ ${amount.toStringAsFixed(0)}';

  /// Nombre del mes en español.
  String get monthName {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return months[month - 1];
  }

  /// Período formateado (ej. "Abril 2025").
  String get periodLabel => '$monthName $year';

  /// Fecha de vencimiento formateada.
  String get dueDateFormatted {
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  /// Fecha de pago formateada.
  String get paidDateFormatted {
    if (paidDate == null) return '--';
    return '${paidDate!.day}/${paidDate!.month}/${paidDate!.year}';
  }

  /// Días hasta el vencimiento (negativo si ya venció).
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;

  /// Días de atraso (0 si no está vencido).
  int get daysOverdue {
    if (status == PaymentStatus.overdue) {
      return DateTime.now().difference(dueDate).inDays;
    }
    return 0;
  }

  /// Si el pago está próximo a vencer (dentro de 5 días).
  bool get isDueSoon =>
      status == PaymentStatus.pending && daysUntilDue >= 0 && daysUntilDue <= 5;

  /// Método de pago en español.
  String get paymentMethodLabel {
    switch (paymentMethod) {
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
      default:
        return 'No especificado';
    }
  }

  /// Tipo de pago en español.
  String get typeLabel {
    if (isDeposit) return 'Depósito';
    if (isUtilities) return 'Servicios';
    return 'Alquiler';
  }

  Payment copyWith({
    String? id,
    String? roomId,
    String? roomTitle,
    String? ownerId,
    String? ownerName,
    double? amount,
    String? currency,
    PaymentStatus? status,
    DateTime? dueDate,
    DateTime? paidDate,
    String? paymentMethod,
    String? receiptNumber,
    String? description,
    int? month,
    int? year,
    bool? isDeposit,
    bool? isUtilities,
  }) {
    return Payment(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      roomTitle: roomTitle ?? this.roomTitle,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      description: description ?? this.description,
      month: month ?? this.month,
      year: year ?? this.year,
      isDeposit: isDeposit ?? this.isDeposit,
      isUtilities: isUtilities ?? this.isUtilities,
    );
  }

  // ── Mock Data ─────────────────────────────────────────────────────

  static List<Payment> mockPayments() {
    return [
      Payment(
        id: 'pay-001',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 650,
        currency: 'PEN',
        status: PaymentStatus.paid,
        dueDate: DateTime(2025, 3, 5),
        paidDate: DateTime(2025, 3, 3),
        paymentMethod: 'yape',
        receiptNumber: 'KW-2025-0342',
        description: 'Alquiler mensual - Marzo 2025',
        month: 3,
        year: 2025,
        isDeposit: false,
        isUtilities: false,
      ),
      Payment(
        id: 'pay-002',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 80,
        currency: 'PEN',
        status: PaymentStatus.paid,
        dueDate: DateTime(2025, 3, 10),
        paidDate: DateTime(2025, 3, 8),
        paymentMethod: 'yape',
        receiptNumber: 'KW-2025-0343',
        description: 'Servicios (luz, agua, internet) - Marzo 2025',
        month: 3,
        year: 2025,
        isDeposit: false,
        isUtilities: true,
      ),
      Payment(
        id: 'pay-003',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 650,
        currency: 'PEN',
        status: PaymentStatus.pending,
        dueDate: DateTime(2025, 4, 5),
        paymentMethod: null,
        receiptNumber: null,
        description: 'Alquiler mensual - Abril 2025',
        month: 4,
        year: 2025,
        isDeposit: false,
        isUtilities: false,
      ),
      Payment(
        id: 'pay-004',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 80,
        currency: 'PEN',
        status: PaymentStatus.pending,
        dueDate: DateTime(2025, 4, 10),
        paymentMethod: null,
        receiptNumber: null,
        description: 'Servicios (luz, agua, internet) - Abril 2025',
        month: 4,
        year: 2025,
        isDeposit: false,
        isUtilities: true,
      ),
      Payment(
        id: 'pay-005',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 650,
        currency: 'PEN',
        status: PaymentStatus.paid,
        dueDate: DateTime(2025, 2, 5),
        paidDate: DateTime(2025, 2, 4),
        paymentMethod: 'transfer',
        receiptNumber: 'KW-2025-0210',
        description: 'Alquiler mensual - Febrero 2025',
        month: 2,
        year: 2025,
        isDeposit: false,
        isUtilities: false,
      ),
      Payment(
        id: 'pay-006',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 650,
        currency: 'PEN',
        status: PaymentStatus.paid,
        dueDate: DateTime(2025, 1, 5),
        paidDate: DateTime(2025, 1, 2),
        paymentMethod: 'yape',
        receiptNumber: 'KW-2025-0088',
        description: 'Alquiler mensual - Enero 2025',
        month: 1,
        year: 2025,
        isDeposit: false,
        isUtilities: false,
      ),
      Payment(
        id: 'pay-007',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 650,
        currency: 'PEN',
        status: PaymentStatus.overdue,
        dueDate: DateTime(2025, 2, 5),
        paidDate: DateTime(2025, 2, 15),
        paymentMethod: 'cash',
        receiptNumber: 'KW-2025-0245',
        description: 'Alquiler mensual - Diciembre 2024 (pago tardío)',
        month: 12,
        year: 2024,
        isDeposit: false,
        isUtilities: false,
      ),
      Payment(
        id: 'pay-008',
        roomId: 'room-001',
        roomTitle: 'Habitación luminosa cerca de la UNSAAC',
        ownerId: 'owner-001',
        ownerName: 'María Elena Quispe',
        amount: 650,
        currency: 'PEN',
        status: PaymentStatus.paid,
        dueDate: DateTime(2024, 4, 1),
        paidDate: DateTime(2024, 3, 28),
        paymentMethod: 'transfer',
        receiptNumber: 'KW-2024-0890',
        description: 'Depósito de garantía',
        month: 4,
        year: 2024,
        isDeposit: true,
        isUtilities: false,
      ),
      Payment(
        id: 'pay-009',
        roomId: 'room-002',
        roomTitle: 'Estudio moderno en el Centro Histórico',
        ownerId: 'owner-002',
        ownerName: 'Carlos Mendoza',
        amount: 1200,
        currency: 'PEN',
        status: PaymentStatus.cancelled,
        dueDate: DateTime(2025, 4, 1),
        paidDate: null,
        paymentMethod: null,
        receiptNumber: null,
        description: 'Alquiler mensual - Abril 2025 (reserva cancelada)',
        month: 4,
        year: 2025,
        isDeposit: false,
        isUtilities: false,
      ),
      Payment(
        id: 'pay-010',
        roomId: 'room-002',
        roomTitle: 'Estudio moderno en el Centro Histórico',
        ownerId: 'owner-002',
        ownerName: 'Carlos Mendoza',
        amount: 1200,
        currency: 'PEN',
        status: PaymentStatus.refunded,
        dueDate: DateTime(2025, 3, 1),
        paidDate: DateTime(2025, 3, 5),
        paymentMethod: 'card',
        receiptNumber: 'KW-2025-0399',
        description: 'Depósito reembolsado por cancelación anticipada',
        month: 3,
        year: 2025,
        isDeposit: true,
        isUtilities: false,
      ),
    ];
  }
}
