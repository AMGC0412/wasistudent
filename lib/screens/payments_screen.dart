import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/payment.dart';
import '../providers/payment_provider.dart';
import '../utils/format_helpers.dart';
import 'payment_detail_screen.dart';

/// Pantalla de panel de pagos.
/// Muestra tarjetas de total pagado/pendiente, próximo pago a vencer
/// (destacado), historial agrupado por mes, banner de aviso de vencidos
/// y filtro por estado.
class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  PaymentStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        actions: [
          PopupMenuButton<PaymentStatus?>(
            onSelected: (status) {
              setState(() => _filterStatus = status);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('Todos')),
              const PopupMenuItem(value: PaymentStatus.paid, child: Text('Pagados')),
              const PopupMenuItem(value: PaymentStatus.pending, child: Text('Pendientes')),
              const PopupMenuItem(value: PaymentStatus.overdue, child: Text('Vencidos')),
            ],
            icon: Icon(
              Icons.filter_list,
              color: _filterStatus != null ? WasiColors.accent : null,
            ),
          ),
        ],
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.payments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _buildErrorState(provider);
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadPayments(),
            color: WasiColors.primary,
            child: CustomScrollView(
              slivers: [
                // ── Summary Cards ──
                SliverToBoxAdapter(child: _buildSummaryCards(provider)),

                // ── Overdue Warning ──
                SliverToBoxAdapter(
                  child: _buildOverdueBanner(provider),
                ),

                // ── Next Due Payment ──
                SliverToBoxAdapter(
                  child: _buildNextDueCard(provider),
                ),

                // ── Payment History ──
                ..._buildPaymentHistory(provider),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Summary Cards ──────────────────────────────────────────────────

  Widget _buildSummaryCards(PaymentProvider provider) {
    final totalPaid = provider.getTotalPaid();
    final totalPending = provider.getTotalPending();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'Total pagado',
              amount: F.price(totalPaid),
              icon: Icons.check_circle_outline,
              color: WasiColors.success,
              bgColor: WasiColors.successContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              title: 'Total pendiente',
              amount: F.price(totalPending),
              icon: Icons.schedule,
              color: totalPending > 0 ? WasiColors.accent : WasiColors.success,
              bgColor: totalPending > 0
                  ? WasiColors.secondaryContainer
                  : WasiColors.successContainer,
            ),
          ),
        ],
      ),
    );
  }

  // ── Overdue Banner ─────────────────────────────────────────────────

  Widget _buildOverdueBanner(PaymentProvider provider) {
    final overdue = provider.getOverduePayments();
    if (overdue.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WasiColors.errorContainer.withValues(alpha: 0.5),
        borderRadius: WasiRadius.card,
        border: Border.all(color: WasiColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: WasiColors.error, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${overdue.length} pago${overdue.length > 1 ? 's' : ''} vencido${overdue.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tienes pagos pendientes fuera de fecha. Regulariza tu situación para mantener tu puntuación de confianza.',
                  style: TextStyle(
                    fontSize: 12,
                    color: WasiColors.onErrorContainer.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Next Due Card ──────────────────────────────────────────────────

  Widget _buildNextDueCard(PaymentProvider provider) {
    final nextDue = provider.getNextDue();
    if (nextDue == null) return const SizedBox.shrink();

    final daysLeft = nextDue.daysUntilDue;
    final isUrgent = daysLeft <= 5;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isUrgent ? WasiColors.warmGradient : WasiColors.coolGradient,
        borderRadius: WasiRadius.card,
        boxShadow: [
          BoxShadow(
            color: (isUrgent ? WasiColors.error : WasiColors.primary)
                .withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Próximo pago',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isUrgent ? '¡Urgente!' : 'Pronto',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            nextDue.formattedAmount,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nextDue.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.85),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            'Vence: ${nextDue.dueDateFormatted} ${daysLeft >= 0 ? "($daysLeft día${daysLeft != 1 ? 's' : ''})" : "(vencido)"}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Payment History ────────────────────────────────────────────────

  List<Widget> _buildPaymentHistory(PaymentProvider provider) {
    var payments = provider.payments.toList();

    // Apply filter
    if (_filterStatus != null) {
      payments = payments.where((p) => p.status == _filterStatus).toList();
    }

    // Group by month/year
    final grouped = <String, List<Payment>>{};
    for (final payment in payments) {
      final key = payment.periodLabel;
      grouped.putIfAbsent(key, () => []).add(payment);
    }

    final slivers = <Widget>[];

    // Section header
    slivers.add(
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Text(
            'Historial de pagos',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );

    if (grouped.isEmpty) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Text(
                'No hay pagos para este filtro.',
                style: const TextStyle(
                  fontSize: 14,
                  color: WasiColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ),
      );
    }

    for (final entry in grouped.entries) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              entry.key,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: WasiColors.textTertiaryLight,
              ),
            ),
          ),
        ),
      );

      slivers.add(
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _PaymentTile(
              payment: entry.value[index],
              onTap: () => _navigateToDetail(context, entry.value[index]),
            ),
            childCount: entry.value.length,
          ),
        ),
      );
    }

    return slivers;
  }

  // ── Error State ────────────────────────────────────────────────────

  Widget _buildErrorState(PaymentProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: WasiColors.error),
            const SizedBox(height: 16),
            Text(
              provider.error ?? 'Error al cargar pagos',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: WasiColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Navigation ─────────────────────────────────────────────────────

  void _navigateToDetail(BuildContext context, Payment payment) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<PaymentProvider>(),
          child: PaymentDetailScreen(paymentId: payment.id),
        ),
      ),
    );
  }
}

// ── Summary Card ─────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.5),
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Payment Tile ─────────────────────────────────────────────────────

class _PaymentTile extends StatelessWidget {
  final Payment payment;
  final VoidCallback onTap;

  const _PaymentTile({required this.payment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: WasiColors.surfaceLight,
          borderRadius: WasiRadius.card,
          border: Border.all(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: payment.statusColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                payment.statusIcon,
                size: 20,
                color: payment.statusColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment.typeLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    payment.roomTitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: WasiColors.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  payment.formattedAmount,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: payment.statusColor,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: payment.statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    payment.statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: payment.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: WasiColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
