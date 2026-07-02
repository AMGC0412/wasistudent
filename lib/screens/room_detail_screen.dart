import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../models/room.dart';
import '../models/trust_score.dart';
import '../models/user_preferences.dart';
import '../providers/room_provider.dart';
import '../providers/review_provider.dart';
import '../utils/format_helpers.dart';
import '../widgets/verification_checklist_card.dart';
import '../widgets/guarantee_banner.dart';
import 'room_photos_screen.dart';
import 'contract_flow_screen.dart';

/// Pantalla de detalle completo de una habitación.
/// Incluye SliverAppBar con imagen placeholder, badges de precio y compatibilidad,
/// estadísticas, descripción, servicios, reglas, propietario y reseñas.
class RoomDetailScreen extends StatefulWidget {
  final String roomId;

  const RoomDetailScreen({super.key, required this.roomId});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: WasiDuration.slow,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: WasiCurves.easeOutCubic,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _fadeController.forward();
    });
  }

  Future<void> _loadData() async {
    final roomProvider = context.read<RoomProvider>();
    final reviewProvider = context.read<ReviewProvider>();
    roomProvider.addToRecentlyViewed(widget.roomId);
    await reviewProvider.loadReviewsForRoom(widget.roomId);
    _isFavorite = roomProvider.isFavorite(widget.roomId);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.watch<RoomProvider>();
    final room = roomProvider.getRoomById(widget.roomId);

    if (room == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Habitación no encontrada')),
        body: const Center(
          child: Text('No se encontró la habitación solicitada.'),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(room),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(room),
                  _buildStatsRow(room),
                  _buildDescription(room),
                  _buildAmenities(room),
                  // ── Verificación en persona (12 puntos) ──
                  VerificationChecklistCard(),
                  const SizedBox(height: 8),
                  // ── Garantía WasiStudent (acuerdo opcional) ──
                  GuaranteeBanner(),
                  _buildHouseRules(room),
                  _buildOwnerCard(room),
                  _buildLocationPlaceholder(room),
                  _buildReviewsSummary(room),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(room),
    );
  }

  // ── SliverAppBar ──────────────────────────────────────────────────

  Widget _buildSliverAppBar(Room room) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: WasiColors.primaryContainer,
              child: const Center(
                child: Icon(
                  Icons.photo_camera_outlined,
                  size: 64,
                  color: WasiColors.primaryLight,
                ),
              ),
            ),
            // Gradient overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
            // Photo counter
            Positioned(
              top: 80,
              right: 16,
              child: GestureDetector(
                onTap: () => _openPhotos(room),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${room.imageUrls.length} fotos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Price badge
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: WasiColors.accent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: WasiShadows.button(),
                ),
                child: Text(
                  F.pricePerMonth(room.price),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            // Match badge
            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: WasiColors.success.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.thumb_up, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '${room.matchingScore.round()}% match',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() => _isFavorite = !_isFavorite);
            context.read<RoomProvider>().toggleFavorite(widget.roomId);
          },
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? WasiColors.error : null,
          ),
        ),
        IconButton(
          onPressed: _shareRoom,
          icon: const Icon(Icons.share_outlined),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  // ── Title Section ─────────────────────────────────────────────────

  Widget _buildTitleSection(Room room) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  room.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: WasiColors.textSecondaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                room.district,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: WasiColors.textSecondaryLight,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.verified_user,
                size: 16,
                color: room.verificationColor,
              ),
              const SizedBox(width: 4),
              Text(
                room.verificationLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: room.verificationColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (room.isUrgent) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: WasiColors.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '🔴 Urgente - Disponible ahora',
                style: TextStyle(
                  color: WasiColors.onErrorContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────

  Widget _buildStatsRow(Room room) {
    final stats = [
      _StatItem(
        icon: Icons.directions_walk,
        label: F.walkingTime(room.walkingTimeMin.toDouble()),
        subtitle: 'caminando',
      ),
      _StatItem(
        icon: Icons.square_foot_outlined,
        label: room.sizeFormatted,
        subtitle: 'tamaño',
      ),
      _StatItem(
        icon: Icons.people_outline,
        label: '${room.maxOccupants}',
        subtitle: room.maxOccupants == 1 ? 'ocupante' : 'ocupantes',
      ),
      _StatItem(
        icon: Icons.bed_outlined,
        label: _roomTypeLabel(room.roomType),
        subtitle: 'tipo',
      ),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        borderRadius: WasiRadius.card,
        border: Border.all(
          color: WasiColors.outlineLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: stats
            .map(
              (s) => Expanded(
                child: Column(
                  children: [
                    Icon(s.icon, size: 22, color: WasiColors.primary),
                    const SizedBox(height: 6),
                    Text(
                      s.label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: WasiColors.textPrimaryLight,
                      ),
                    ),
                    Text(
                      s.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: WasiColors.textTertiaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Description ───────────────────────────────────────────────────

  Widget _buildDescription(Room room) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            room.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: WasiColors.textSecondaryLight,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _infoChip(
                Icons.payments_outlined,
                'Depósito: ${room.depositFormatted}',
              ),
              const SizedBox(width: 8),
              _infoChip(
                Icons.bolt_outlined,
                'Servicios: ${room.utilitiesFormatted}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Amenities Grid ────────────────────────────────────────────────

  Widget _buildAmenities(Room room) {
    if (room.amenities.isEmpty) return const SizedBox.shrink();

    final amenityIcons = {
      'Wi-Fi': Icons.wifi,
      'Agua caliente': Icons.hot_tub_outlined,
      'Cocina compartida': Icons.kitchen_outlined,
      'Cocina propia': Icons.kitchen,
      'Lavandería': Icons.local_laundry_service_outlined,
      'Jardín': Icons.yard_outlined,
      'Escritorio': Icons.desk,
      'Closet': Icons.checkroom_outlined,
      'Baño privado': Icons.bathtub_outlined,
      'Calefacción': Icons.thermostat,
      'TV': Icons.tv_outlined,
      'Minibar': Icons.local_bar_outlined,
      'Estacionamiento': Icons.local_parking,
      'Seguridad 24/7': Icons.security,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Servicios incluidos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: room.amenities.map((amenity) {
              final icon = amenityIcons[amenity] ?? Icons.check_circle_outline;
              return Chip(
                avatar: Icon(icon, size: 18, color: WasiColors.primary),
                label: Text(amenity),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── House Rules ───────────────────────────────────────────────────

  Widget _buildHouseRules(Room room) {
    if (room.houseRules.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reglas de la casa',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...room.houseRules.map(
            (rule) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.rule_outlined,
                    size: 18,
                    color: WasiColors.textTertiaryLight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rule,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: WasiColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _ruleBadge(room.acceptsCouples, 'Parejas', Icons.favorite_outline),
              _ruleBadge(room.acceptsPets, 'Mascotas', Icons.pets_outlined),
              _ruleBadge(room.acceptsForeigners, 'Extranjeros', Icons.public),
            ],
          ),
        ],
      ),
    );
  }

  // ── Owner Card ────────────────────────────────────────────────────

  Widget _buildOwnerCard(Room room) {
    final trustModel = TrustScoreModel.mock(); // Mock for UI

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Propietario',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: WasiColors.surfaceLight,
              borderRadius: WasiRadius.card,
              border: Border.all(
                color: WasiColors.outlineLight.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Avatar + TrustRing
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: WasiColors.primaryContainer,
                      child: Text(
                        room.ownerAvatar,
                        style: const TextStyle(
                          color: WasiColors.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: trustModel.levelColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          trustModel.levelIcon,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.ownerName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: WasiColors.accent,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            F.rating(room.ownerRating),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: WasiColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.shield_outlined,
                            size: 14,
                            color: trustModel.levelColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${room.trustScore}% confianza',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: trustModel.levelColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Miembro desde ${room.ownerMemberSince.year}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: WasiColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _contactOwner(room),
                  icon: const Icon(Icons.chat_bubble_outline),
                  style: IconButton.styleFrom(
                    backgroundColor: WasiColors.primaryContainer,
                    foregroundColor: WasiColors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Location Placeholder ──────────────────────────────────────────

  Widget _buildLocationPlaceholder(Room room) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ubicación',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: WasiColors.surfaceVariantLight,
              borderRadius: WasiRadius.card,
              border: Border.all(
                color: WasiColors.outlineLight.withValues(alpha: 0.5),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 40,
                    color: WasiColors.textTertiaryLight,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room.district,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: WasiColors.textSecondaryLight,
                    ),
                  ),
                  Text(
                    'A ${F.distanceKm(room.distanceKm)} de tu universidad',
                    style: const TextStyle(
                      fontSize: 12,
                      color: WasiColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (room.nearbyPlaces.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: room.nearbyPlaces.map((place) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: WasiColors.successContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.place,
                        size: 12,
                        color: WasiColors.onSuccessContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place,
                        style: const TextStyle(
                          fontSize: 11,
                          color: WasiColors.onSuccessContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── Reviews Summary ───────────────────────────────────────────────

  Widget _buildReviewsSummary(Room room) {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, _) {
        final avgRating = reviewProvider.getAverageRating(room.id);
        final reviewCount = reviewProvider.getReviewCount(room.id);
        final breakdown = reviewProvider.getRatingBreakdown(room.id);
        final starDist = reviewProvider.getStarDistribution(room.id);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Reseñas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$reviewCount reseñas',
                    style: const TextStyle(
                      fontSize: 13,
                      color: WasiColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Rating overview
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        F.rating(avgRating),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: WasiColors.textPrimaryLight,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < avgRating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: 18,
                            color: WasiColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  // Star distribution
                  Expanded(
                    child: Column(
                      children: [5, 4, 3, 2, 1].map((star) {
                        final count = starDist[star] ?? 0;
                        final pct =
                            reviewCount > 0 ? count / reviewCount : 0.0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text(
                                '$star',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: WasiColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor:
                                        WasiColors.surfaceVariantLight,
                                    color: WasiColors.accent,
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              // Category breakdown
              if (breakdown.isNotEmpty) ...[
                const SizedBox(height: 14),
                ...breakdown.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 12,
                              color: WasiColors.textSecondaryLight,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: entry.value / 5,
                              backgroundColor:
                                  WasiColors.surfaceVariantLight,
                              color: WasiColors.primaryLight,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          F.rating(entry.value),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: WasiColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────

  Widget _buildBottomBar(Room room) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: WasiColors.surfaceLight,
        border: Border(
          top: BorderSide(
            color: WasiColors.outlineLight.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Compare button
            OutlinedButton.icon(
              onPressed: () => _toggleCompare(room),
              icon: const Icon(Icons.compare_arrows, size: 18),
              label: const Text('Comparar'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Contract button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _startContract(room),
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text('Iniciar contrato'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: WasiColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: WasiColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: WasiColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ruleBadge(bool allowed, String label, IconData icon) {
    final color =
        allowed ? WasiColors.success : WasiColors.textTertiaryLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: allowed
            ? WasiColors.successContainer
            : WasiColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${allowed ? "✓" : "✗"} $label',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _roomTypeLabel(RoomType type) {
    switch (type) {
      case RoomType.private:
        return 'Privada';
      case RoomType.shared:
        return 'Compartida';
      case RoomType.studio:
        return 'Estudio';
      case RoomType.any:
        return 'Cualquiera';
    }
  }

  void _openPhotos(Room room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoomPhotosScreen(roomId: room.id),
      ),
    );
  }

  void _shareRoom() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enlace copiado al portapapeles')),
    );
  }

  void _contactOwner(Room room) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contactando a ${room.ownerName}...')),
    );
  }

  void _toggleCompare(Room room) {
    final provider = context.read<RoomProvider>();
    provider.toggleCompare(room.id);
    final isCompared = provider.isInCompare(room.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCompared
              ? '${room.title} añadida a comparación'
              : '${room.title} removida de comparación',
        ),
      ),
    );
  }

  void _startContract(Room room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ContractFlowScreen(roomId: room.id),
      ),
    );
  }
}

// ── Data class for stat items ───────────────────────────────────────

class _StatItem {
  final IconData icon;
  final String label;
  final String subtitle;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}
