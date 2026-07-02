import 'package:flutter/material.dart';

import '../models/payment.dart';

/// Proveedor de pagos para la aplicación WasiStudent.
/// Gestiona el seguimiento de alquileres, servicios, depósitos
/// y el historial de pagos del estudiante en Cusco.
class PaymentProvider extends ChangeNotifier {
  // ── Estado ──────────────────────────────────────────────────────

  List<Payment> _payments = [];
  bool _isLoading = false;
  String? _error;

  // ── Getters ─────────────────────────────────────────────────────

  /// Lista de todos los pagos.
  List<Payment> get payments => _payments;

  /// Indica si hay una operación de carga en curso.
  bool get isLoading => _isLoading;

  /// Mensaje de error de la última operación fallida.
  String? get error => _error;

  // ── Constructor ─────────────────────────────────────────────────

  PaymentProvider() {
    loadPayments();
  }

  // ── Carga de Datos ──────────────────────────────────────────────

  /// Carga los pagos desde los datos mock.
  Future<void> loadPayments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _payments = Payment.mockPayments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Error al cargar los pagos. Intenta de nuevo.';
      notifyListeners();
    }
  }

  // ── Próximo Pago ────────────────────────────────────────────────

  /// Obtiene el próximo pago pendiente más cercano.
  Payment? getNextDue() {
    final pending = _payments
        .where((p) => p.status == PaymentStatus.pending)
        .toList();
    if (pending.isEmpty) return null;
    pending.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return pending.first;
  }

  // ── Pagos Vencidos ──────────────────────────────────────────────

  /// Obtiene los pagos vencidos.
  List<Payment> getOverduePayments() {
    return _payments
        .where((p) => p.status == PaymentStatus.overdue)
        .toList();
  }

  // ── Historial ───────────────────────────────────────────────────

  /// Obtiene el historial de pagos (solo pagados, ordenados por fecha).
  List<Payment> getPaymentHistory() {
    return _payments
        .where((p) => p.status == PaymentStatus.paid)
        .toList()
      ..sort((a, b) => (b.paidDate ?? b.dueDate)
          .compareTo(a.paidDate ?? a.dueDate));
  }

  // ── Totales ─────────────────────────────────────────────────────

  /// Total pagado (suma de todos los pagos con estado "paid").
  double getTotalPaid() {
    return _payments
        .where((p) => p.status == PaymentStatus.paid)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  /// Total pendiente (suma de pagos "pending" y "overdue").
  double getTotalPending() {
    return _payments
        .where((p) =>
            p.status == PaymentStatus.pending ||
            p.status == PaymentStatus.overdue)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  // ── Acciones ────────────────────────────────────────────────────

  /// Marca un pago como pagado.
  void markAsPaid(String id) {
    final index = _payments.indexWhere((p) => p.id == id);
    if (index != -1) {
      final now = DateTime.now();
      final receipt = 'KW-${now.year}-${_payments.length.toString().padLeft(4, '0')}';
      _payments[index] = _payments[index].copyWith(
        status: PaymentStatus.paid,
        paidDate: now,
        paymentMethod: 'yape', // Método por defecto
        receiptNumber: receipt,
      );
      notifyListeners();
    }
  }

  // ── Filtrado ────────────────────────────────────────────────────

  /// Obtiene los pagos de un mes y año específicos.
  List<Payment> getByMonth(int month, int year) {
    return _payments
        .where((p) => p.month == month && p.year == year)
        .toList();
  }

  /// Obtiene los pagos de una habitación específica.
  List<Payment> getByRoom(String roomId) {
    return _payments.where((p) => p.roomId == roomId).toList();
  }

  /// Obtiene los pagos que vencen pronto (dentro de 5 días).
  List<Payment> getUpcomingPayments() {
    return _payments
        .where((p) => p.status == PaymentStatus.pending && p.isDueSoon)
        .toList();
  }

  // ── Utilidades ──────────────────────────────────────────────────

  /// Obtiene un pago por su ID.
  Payment? getPaymentById(String id) {
    try {
      return _payments.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Total de pagos por método de pago.
  Map<String, double> getTotalsByPaymentMethod() {
    final totals = <String, double>{};
    for (final payment in _payments.where((p) => p.status == PaymentStatus.paid)) {
      final method = payment.paymentMethod ?? 'no_especificado';
      totals[method] = (totals[method] ?? 0) + payment.amount;
    }
    return totals;
  }
}
