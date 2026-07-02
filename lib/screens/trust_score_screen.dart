import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../models/trust_score.dart';
import '../utils/format_helpers.dart';

/// Pantalla de puntuación de confianza detallada.
/// Muestra el TrustRing central, nombre de nivel, progreso al siguiente,
/// grid de insignias, desglose por dimensiones, estadísticas y explicación.
class TrustScoreScreen extends StatelessWidget {
  final TrustScoreModel trustScore;

  const TrustScoreScreen({super.key, required this.trustScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puntuación de confianza')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            _buildTrustRing(context),
            const SizedBox(height: 16),
            _buildLevelInfo(context),
            const SizedBox(height: 20),
            _buildProgressToNext(context),
            const SizedBox(height: 24),
            _buildBadgeGrid(context),
            const SizedBox(height: 24),
            _buildDimensionBreakdown(context),
            const SizedBox(height: 24),
            _buildStatsCard(context),
            const SizedBox(height: 20),
            _buildExplanationCard(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── TrustRing Center ──────────────────────────────────────────────

  Widget _buildTrustRing(BuildContext context) {
    final score = trustScore.overallScore;
    final color = trustScore.levelColor;
    final icon = trustScore.levelIcon;

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12,
              color: WasiColors.surfaceVariantLight,
            ),
          ),
          // Score ring
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 12,
              strokeCap: StrokeCap.round,
              color: color,
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 4),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1.0,
                ),
              ),
              const Text(
                '/ 100',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Level Info ────────────────────────────────────────────────────

  Widget _buildLevelInfo(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: trustScore.levelColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            trustScore.levelName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: trustScore.levelColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Última actualización: ${F.timeAgo(trustScore.lastUpdated)}',
          style: const TextStyle(
            fontSize: 12,
            color: WasiColors.textTertiaryLight,
          ),
        ),
      ],
    );
  }

  // ── Progress to Next ──────────────────────────────────────────────

  Widget _buildProgressToNext(BuildContext context) {
    if (trustScore.overallScore >= 90) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: WasiColors.successContainer,
            borderRadius: WasiRadius.card,
          ),
          child: const Row(
            children: [
              Icon(
                Icons.workspace_premium,
                color: WasiColors.onSuccessContainer,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '¡Felicidades! Has alcanzado el nivel máximo de confianza.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: WasiColors.onSuccessContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final progress = trustScore.progressToNextLevel;
    final nextScore = trustScore.nextLevelScore;
    final remaining = nextScore - trustScore.overallScore;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso al siguiente nivel',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                'Faltan $remaining puntos',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: WasiColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: WasiColors.surfaceVariantLight,
              color: trustScore.levelColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${trustScore.overallScore} → $nextScore puntos',
            style: const TextStyle(
              fontSize: 11,
              color: WasiColors.textTertiaryLight,
            ),
          ),
        ],
      ),
    );
  }

  // ── Badge Grid ────────────────────────────────────────────────────

  Widget _buildBadgeGrid(BuildContext context) {
    final badges = trustScore.badges;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Insignias (${trustScore.earnedBadgeCount}/${badges.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: badges.map((badge) {
              return Tooltip(
                message: badge.name,
                child: AnimatedOpacity(
                  opacity: badge.earned ? 1.0 : 0.35,
                  duration: WasiDuration.normal,
                  child: Container(
                    width: 64,
                    height: 72,
                    decoration: BoxDecoration(
                      color: badge.earned
                          ? WasiColors.successContainer
                          : WasiColors.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(12),
                      border: badge.earned
                          ? Border.all(
                              color: WasiColors.success.withValues(
                                alpha: 0.3,
                              ),
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _badgeIcon(badge.icon),
                          size: 24,
                          color: badge.earned
                              ? WasiColors.onSuccessContainer
                              : WasiColors.textTertiaryLight,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          badge.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: badge.earned
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: badge.earned
                                ? WasiColors.onSuccessContainer
                                : WasiColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Dimension Breakdown ───────────────────────────────────────────

  Widget _buildDimensionBreakdown(BuildContext context) {
    final dimensions = trustScore.dimensionBreakdown;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Desglose por dimensiones',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...dimensions.entries.map((entry) {
            return _DimensionCard(
              name: entry.key,
              score: entry.value,
            );
          }),
        ],
      ),
    );
  }

  // ── Stats Card ────────────────────────────────────────────────────

  Widget _buildStatsCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WasiColors.surfaceLight,
          borderRadius: WasiRadius.card,
          border: Border.all(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatBox(
                  label: 'Contratos',
                  value:
                      '${trustScore.completedContracts}/${trustScore.totalContracts}',
                  icon: Icons.assignment_turned_in_outlined,
                ),
                _StatBox(
                  label: 'Cumplimiento',
                  value:
                      '${(trustScore.contractCompletionRate * 100).toStringAsFixed(0)}%',
                  icon: Icons.trending_up,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatBox(
                  label: 'Reseñas recibidas',
                  value: '${trustScore.reviewsReceived}',
                  icon: Icons.star_outline,
                ),
                _StatBox(
                  label: 'Reseñas dadas',
                  value: '${trustScore.reviewsGiven}',
                  icon: Icons.rate_review_outlined,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _StatBox(
                  label: 'Miembro hace',
                  value:
                      '${trustScore.monthsAsMember} ${trustScore.monthsAsMember == 1 ? "mes" : "meses"}',
                  icon: Icons.calendar_today_outlined,
                ),
                _StatBox(
                  label: 'Nivel verificación',
                  value: '${trustScore.verificationLevel}/3',
                  icon: Icons.verified_user_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Explanation Card ──────────────────────────────────────────────

  Widget _buildExplanationCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WasiColors.primaryContainer,
          borderRadius: WasiRadius.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: WasiColors.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '¿Cómo funciona?',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: WasiColors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Tu puntuación de confianza se calcula en base a 5 dimensiones:\n\n'
              '• Identidad verificada: DNI, correo y teléfono validados\n'
              '• Contratos cumplidos: Historial de contratos completados\n'
              '• Reseñas recibidas: Calificaciones de otros usuarios\n'
              '• Antigüedad: Tiempo como miembro activo\n'
              '• Capacidad de respuesta: Velocidad de respuesta a mensajes\n\n'
              'Un puntaje alto te da visibilidad prioritaria y acceso a '
              'habitaciones exclusivas. Las insignias se desbloquean '
              'automáticamente al cumplir hitos específicos.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: WasiColors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Badge icon helper ─────────────────────────────────────────────

  IconData _badgeIcon(String iconName) {
    const iconMap = {
      'verified_user': Icons.verified_user,
      'assignment_turned_in': Icons.assignment_turned_in,
      'star': Icons.star,
      'calendar_today': Icons.calendar_today,
      'bolt': Icons.bolt,
      'emoji_events': Icons.emoji_events,
      'diamond': Icons.diamond,
      'school': Icons.school,
    };
    return iconMap[iconName] ?? Icons.emoji_events;
  }
}

// ── Dimension Card ──────────────────────────────────────────────────

class _DimensionCard extends StatelessWidget {
  final String name;
  final int score;

  const _DimensionCard({required this.name, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$score%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: WasiColors.surfaceVariantLight,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 80) return WasiColors.success;
    if (score >= 60) return WasiColors.accent;
    if (score >= 40) return WasiColors.accentDark;
    return WasiColors.error;
  }
}

// ── Stat Box ────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: WasiColors.surfaceVariantLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: WasiColors.primaryLight),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: WasiColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
