import 'package:flutter/material.dart';
import '../theme/design.dart';

/// Estado vacío reutilizable con ilustración, título y descripción.
///
/// Se muestra cuando una lista no tiene elementos (ej. no hay cuartos
/// publicados, no hay favoritos, no hay reseñas).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WasiDesign.spaceXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ilustración: círculo con icono
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: WasiDesign.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: WasiDesign.primary,
              ),
            ),
            const SizedBox(height: WasiDesign.spaceXl),
            Text(
              title,
              style: WasiDesign.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: WasiDesign.spaceSm),
            Text(
              description,
              style: WasiDesign.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: WasiDesign.spaceXl),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton loader para tarjetas de cuarto mientras cargan.
class RoomCardSkeleton extends StatelessWidget {
  const RoomCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: WasiDesign.spaceLg,
        vertical: WasiDesign.spaceSm,
      ),
      decoration: BoxDecoration(
        color: WasiDesign.surface,
        borderRadius: BorderRadius.circular(WasiDesign.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen skeleton
          Container(
            height: 180,
            color: WasiDesign.surfaceVariant,
          ),
          Padding(
            padding: const EdgeInsets.all(WasiDesign.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título skeleton
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: WasiDesign.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 12,
                  decoration: BoxDecoration(
                    color: WasiDesign.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        color: WasiDesign.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: WasiDesign.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de skeletons para mostrar mientras cargan datos.
class LoadingList extends StatelessWidget {
  final int itemCount;
  const LoadingList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: WasiDesign.spaceLg),
      itemBuilder: (_, __) => const RoomCardSkeleton(),
    );
  }
}

/// Widget de error reutilizable.
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WasiDesign.spaceXxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: WasiDesign.error,
            ),
            const SizedBox(height: WasiDesign.spaceLg),
            Text(
              message,
              style: WasiDesign.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: WasiDesign.spaceLg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
