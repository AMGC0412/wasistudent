import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/room.dart';
import '../models/user_preferences.dart' show RoomType;
import '../providers/room_provider.dart';
import '../providers/preference_provider.dart';
import '../utils/format_helpers.dart';

/// Pantalla de exploración con filtros, ordenamiento y vista de habitaciones.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool _isGridView = false;
  bool _initialized = false;

  // ── Distritos de Cusco ──
  static const _districts = [
    'Todos',
    'Wanchaq',
    'Santiago',
    'Cusco Centro',
    'San Sebastián',
    'San Jerónimo',
    'Poroy',
  ];

  // ── Opciones de ordenamiento ──
  static const _sortOptions = [
    ('matching', 'Match', Icons.auto_awesome_rounded),
    ('price_low', 'Precio', Icons.attach_money_rounded),
    ('distance', 'Distancia', Icons.directions_walk_rounded),
    ('trust', 'Confianza', Icons.verified_rounded),
    ('newest', 'Nuevos', Icons.fiber_new_rounded),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    final roomProvider = context.read<RoomProvider>();
    final prefProvider = context.read<PreferenceProvider>();
    if (roomProvider.allRooms.isEmpty) {
      await roomProvider.loadRooms();
    }
    roomProvider.filterRooms(prefProvider.prefs);
  }

  Future<void> _onRefresh() async {
    final roomProvider = context.read<RoomProvider>();
    final prefProvider = context.read<PreferenceProvider>();
    await roomProvider.loadRooms();
    roomProvider.filterRooms(prefProvider.prefs);
  }

  void _onDistrictTap(String district) {
    final roomProvider = context.read<RoomProvider>();
    final prefProvider = context.read<PreferenceProvider>();
    roomProvider.setFilterDistrict(district == 'Todos' ? '' : district);
    roomProvider.filterRooms(prefProvider.prefs);
  }

  void _onSortTap(String sortBy) {
    final roomProvider = context.read<RoomProvider>();
    roomProvider.sortRooms(sortBy);
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => _AdvancedFilterSheet(
        onApply: () {
          final roomProvider = this.context.read<RoomProvider>();
          final prefProvider = this.context.read<PreferenceProvider>();
          roomProvider.filterRooms(prefProvider.prefs);
          Navigator.pop(context);
        },
        onClear: () {
          final roomProvider = this.context.read<RoomProvider>();
          final prefProvider = this.context.read<PreferenceProvider>();
          roomProvider.clearFilters();
          roomProvider.filterRooms(prefProvider.prefs);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar'),
        actions: [
          // Toggle vista
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: AnimatedSwitcher(
              duration: WasiDuration.fast,
              child: Icon(
                _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
                key: ValueKey(_isGridView),
              ),
            ),
          ),
          // Filtros
          IconButton(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.tune_rounded),
          ),
          // Mapa
          IconButton(
            onPressed: () => context.push(AppRoutes.map),
            icon: const Icon(Icons.map_outlined),
          ),
        ],
      ),
      body: Consumer<RoomProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // ── Distritos ──
              _buildDistrictChips(provider, isDark),

              // ── Barra de ordenamiento ──
              _buildSortBar(provider, isDark),

              // ── Contador + Banner de comparar ──
              _buildResultHeader(provider, isDark),

              // ── Lista / Grid de resultados ──
              Expanded(
                child: provider.isLoading
                    ? _buildLoadingState(isDark)
                    : provider.rooms.isEmpty
                        ? _buildEmptyState(isDark)
                        : RefreshIndicator(
                            onRefresh: _onRefresh,
                            color: WasiColors.primary,
                            child: _isGridView
                                ? _buildGrid(provider, isDark)
                                : _buildList(provider, isDark),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────
  //  DISTRITO CHIPS
  // ──────────────────────────────────────────
  Widget _buildDistrictChips(RoomProvider provider, bool isDark) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: WasiSpacing.lg,
          vertical: WasiSpacing.sm,
        ),
        itemCount: _districts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final district = _districts[index];
          final isSelected = (district == 'Todos' && provider.filterDistrict.isEmpty) ||
              district == provider.filterDistrict;

          return GestureDetector(
            onTap: () => _onDistrictTap(district),
            child: AnimatedContainer(
              duration: WasiDuration.fast,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? WasiColors.primary
                    : isDark
                        ? WasiColors.surfaceVariantDark
                        : WasiColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(WasiRadius.xxl),
                border: Border.all(
                  color: isSelected
                      ? WasiColors.primary
                      : isDark
                          ? WasiColors.outlineDark.withValues(alpha: 0.3)
                          : WasiColors.outlineLight,
                  width: 1,
                ),
              ),
              child: Text(
                district,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────
  //  BARRA DE ORDENAMIENTO
  // ──────────────────────────────────────────
  Widget _buildSortBar(RoomProvider provider, bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: WasiSpacing.lg,
          vertical: WasiSpacing.xs,
        ),
        itemCount: _sortOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (sortBy, label, icon) = _sortOptions[index];
          final isSelected = provider.sortBy == sortBy;

          return GestureDetector(
            onTap: () => _onSortTap(sortBy),
            child: AnimatedContainer(
              duration: WasiDuration.fast,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? WasiColors.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(WasiRadius.xxl),
                border: Border.all(
                  color: isSelected
                      ? WasiColors.primary
                      : isDark
                          ? WasiColors.outlineDark.withValues(alpha: 0.3)
                          : WasiColors.outlineLight,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 15,
                    color: isSelected
                        ? WasiColors.primary
                        : isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? WasiColors.primary
                          : isDark
                              ? WasiColors.textTertiaryDark
                              : WasiColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────
  //  RESULTADO HEADER
  // ──────────────────────────────────────────
  Widget _buildResultHeader(RoomProvider provider, bool isDark) {
    final compareCount = provider.compareList.length;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WasiSpacing.lg,
        vertical: WasiSpacing.sm,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${provider.rooms.length} habitaciones',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? WasiColors.textSecondaryDark
                      : WasiColors.textSecondaryLight,
                ),
              ),
              const Spacer(),
              if (provider.activeFilterCount > 0)
                GestureDetector(
                  onTap: () {
                    provider.clearFilters();
                    final prefProvider = context.read<PreferenceProvider>();
                    provider.filterRooms(prefProvider.prefs);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: WasiColors.errorContainer,
                      borderRadius: BorderRadius.circular(WasiRadius.xxl),
                    ),
                    child: Text(
                      'Limpiar filtros (${provider.activeFilterCount})',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: WasiColors.onErrorContainer,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Banner de comparación
          if (compareCount >= 2)
            Container(
              margin: const EdgeInsets.only(top: WasiSpacing.sm),
              padding: const EdgeInsets.all(WasiSpacing.md),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [WasiColors.primary, WasiColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(WasiRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.compare_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$compareCount habitaciones seleccionadas para comparar',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.comparison),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text(
                      'Comparar',
                      style: TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  LIST VIEW
  // ──────────────────────────────────────────
  Widget _buildList(RoomProvider provider, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        WasiSpacing.lg,
        WasiSpacing.sm,
        WasiSpacing.lg,
        120,
      ),
      itemCount: provider.rooms.length,
      separatorBuilder: (_, __) => const SizedBox(height: WasiSpacing.md),
      itemBuilder: (context, index) {
        final room = provider.rooms[index];
        return _ExploreRoomCard(
          room: room,
          isDark: isDark,
          isFavorite: provider.isFavorite(room.id),
          isInCompare: provider.isInCompare(room.id),
          canCompare: provider.canCompare,
          onFavoriteTap: () => provider.toggleFavorite(room.id),
          onCompareTap: () => provider.toggleCompare(room.id),
          onTap: () => context.push('/room/${room.id}'),
        );
      },
    );
  }

  // ──────────────────────────────────────────
  //  GRID VIEW
  // ──────────────────────────────────────────
  Widget _buildGrid(RoomProvider provider, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        WasiSpacing.lg,
        WasiSpacing.sm,
        WasiSpacing.lg,
        120,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: WasiSpacing.md,
        crossAxisSpacing: WasiSpacing.md,
        childAspectRatio: 0.72,
      ),
      itemCount: provider.rooms.length,
      itemBuilder: (context, index) {
        final room = provider.rooms[index];
        return _ExploreRoomCard(
          room: room,
          isDark: isDark,
          isFavorite: provider.isFavorite(room.id),
          isInCompare: provider.isInCompare(room.id),
          canCompare: provider.canCompare,
          onFavoriteTap: () => provider.toggleFavorite(room.id),
          onCompareTap: () => provider.toggleCompare(room.id),
          onTap: () => context.push('/room/${room.id}'),
        );
      },
    );
  }

  // ──────────────────────────────────────────
  //  ESTADOS
  // ──────────────────────────────────────────
  Widget _buildLoadingState(bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(WasiSpacing.lg),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: WasiSpacing.md),
      itemBuilder: (_, __) => Container(
        height: 140,
        decoration: BoxDecoration(
          color: isDark ? WasiColors.surfaceVariantDark : WasiColors.surfaceVariantLight,
          borderRadius: BorderRadius.circular(WasiRadius.lg),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WasiSpacing.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
            ),
            const SizedBox(height: WasiSpacing.xl),
            const Text(
              'Sin resultados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: WasiSpacing.sm),
            Text(
              'Intenta ajustar tus filtros o cambiar el distrito',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: WasiSpacing.xl),
            OutlinedButton(
              onPressed: () {
                final provider = context.read<RoomProvider>();
                provider.clearFilters();
                final prefProvider = context.read<PreferenceProvider>();
                provider.filterRooms(prefProvider.prefs);
              },
              child: const Text('Limpiar filtros'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  EXPLORE ROOM CARD
// ──────────────────────────────────────────
class _ExploreRoomCard extends StatelessWidget {
  final Room room;
  final bool isDark;
  final bool isFavorite;
  final bool isInCompare;
  final bool canCompare;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCompareTap;
  final VoidCallback onTap;

  const _ExploreRoomCard({
    required this.room,
    required this.isDark,
    required this.isFavorite,
    required this.isInCompare,
    required this.canCompare,
    required this.onFavoriteTap,
    required this.onCompareTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
          borderRadius: BorderRadius.circular(WasiRadius.lg),
          border: Border.all(
            color: isInCompare
                ? WasiColors.accent
                : isDark
                    ? WasiColors.outlineDark.withValues(alpha: 0.3)
                    : WasiColors.outlineLight,
            width: isInCompare ? 2 : 1,
          ),
          boxShadow: WasiShadows.card(isLight: !isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen con badges ──
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: WasiColors.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(WasiRadius.lg),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bed_rounded,
                      size: 40,
                      color: WasiColors.primary,
                    ),
                  ),
                ),

                // Match badge
                if (room.matchingScore > 0)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [WasiColors.accent, WasiColors.accentLight],
                        ),
                        borderRadius: BorderRadius.circular(WasiRadius.sm),
                        boxShadow: [
                          BoxShadow(
                            color: WasiColors.accent.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome_rounded, size: 12, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            '${room.matchingScore.round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Badges de propiedades
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (room.verificationLevel >= 2)
                        Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(left: 4),
                          decoration: const BoxDecoration(
                            color: WasiColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                        ),
                      if (room.isUrgent)
                        Container(
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(left: 4),
                          decoration: const BoxDecoration(
                            color: WasiColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bolt_rounded, size: 12, color: Colors.white),
                        ),
                    ],
                  ),
                ),

                // Botones de acción
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favorito
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 18,
                            color: isFavorite ? WasiColors.error : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Comparar
                      GestureDetector(
                        onTap: onCompareTap,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: isInCompare
                                ? WasiColors.accent
                                : (canCompare ? Colors.black45 : Colors.black26),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isInCompare ? Icons.check_rounded : Icons.compare_arrows_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Precio
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: WasiColors.primaryDark,
                      borderRadius: BorderRadius.circular(WasiRadius.sm),
                    ),
                    child: Text(
                      F.pricePerMonth(room.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Info ──
            Padding(
              padding: const EdgeInsets.all(WasiSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? WasiColors.textPrimaryDark : WasiColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          room.district,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                          ),
                        ),
                      ),
                      if (room.walkingTimeMin > 0) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.directions_walk_rounded,
                          size: 13,
                          color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${room.walkingTimeMin} min',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (room.amenities.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: room.amenities.take(3).map((a) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? WasiColors.surfaceVariantDark
                              : WasiColors.surfaceVariantLight,
                          borderRadius: BorderRadius.circular(WasiRadius.xs),
                        ),
                        child: Text(
                          a,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? WasiColors.textSecondaryDark
                                : WasiColors.textSecondaryLight,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  ADVANCED FILTER SHEET
// ──────────────────────────────────────────
class _AdvancedFilterSheet extends StatefulWidget {
  final VoidCallback onApply;
  final VoidCallback onClear;

  const _AdvancedFilterSheet({
    required this.onApply,
    required this.onClear,
  });

  @override
  State<_AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<_AdvancedFilterSheet> {
  double _minBudget = 300;
  double _maxBudget = 1200;
  bool _verifiedOnly = false;
  bool _availableOnly = false;
  String _roomType = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(WasiSpacing.xxl),
          child: ListView(
            controller: scrollController,
            children: [
              // Título
              Row(
                children: [
                  const Text(
                    'Filtros avanzados',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      final provider = context.read<RoomProvider>();
                      provider.clearFilters();
                      widget.onClear();
                    },
                    child: const Text('Limpiar'),
                  ),
                ],
              ),

              const SizedBox(height: WasiSpacing.xxl),

              // Presupuesto
              Text(
                'Presupuesto',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? WasiColors.textPrimaryDark : WasiColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: WasiSpacing.sm),
              Row(
                children: [
                  Text(
                    'S/ ${_minBudget.round()} - S/ ${_maxBudget.round()}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(_minBudget, _maxBudget),
                min: 200,
                max: 2000,
                divisions: 18,
                labels: RangeLabels('S/ ${_minBudget.round()}', 'S/ ${_maxBudget.round()}'),
                onChanged: (values) {
                  setState(() {
                    _minBudget = values.start;
                    _maxBudget = values.end;
                  });
                },
              ),

              const SizedBox(height: WasiSpacing.xl),

              // Tipo de habitación
              Text(
                'Tipo de habitación',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? WasiColors.textPrimaryDark : WasiColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: WasiSpacing.sm),
              Wrap(
                spacing: 8,
                children: [
                  _FilterChip(
                    label: 'Privada',
                    selected: _roomType == 'private',
                    onTap: () => setState(() => _roomType = _roomType == 'private' ? '' : 'private'),
                  ),
                  _FilterChip(
                    label: 'Compartida',
                    selected: _roomType == 'shared',
                    onTap: () => setState(() => _roomType = _roomType == 'shared' ? '' : 'shared'),
                  ),
                  _FilterChip(
                    label: 'Estudio',
                    selected: _roomType == 'studio',
                    onTap: () => setState(() => _roomType = _roomType == 'studio' ? '' : 'studio'),
                  ),
                ],
              ),

              const SizedBox(height: WasiSpacing.xl),

              // Switches
              SwitchListTile(
                title: const Text('Solo verificados'),
                subtitle: const Text('Habitaciones con verificación en persona'),
                value: _verifiedOnly,
                onChanged: (v) => setState(() => _verifiedOnly = v),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: const Text('Disponibles ahora'),
                subtitle: const Text('Habitaciones disponibles inmediatamente'),
                value: _availableOnly,
                onChanged: (v) => setState(() => _availableOnly = v),
                contentPadding: EdgeInsets.zero,
              ),

              const SizedBox(height: WasiSpacing.xxl),

              // Botón Aplicar
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final provider = context.read<RoomProvider>();
                    provider.setFilterBudget(_maxBudget);
                    provider.setFilterRoomType(
                      _roomType.isEmpty
                          ? null
                          : RoomType.values.firstWhere(
                              (e) => e.name == _roomType,
                              orElse: () => RoomType.private,
                            ),
                    );
                    provider.setFilterVerified(_verifiedOnly);
                    provider.setFilterAvailable(_availableOnly);
                    widget.onApply();
                  },
                  child: const Text('Aplicar filtros'),
                ),
              ),

              const SizedBox(height: WasiSpacing.xxl),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: WasiDuration.fast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? WasiColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(WasiRadius.xxl),
          border: Border.all(
            color: selected ? WasiColors.primary : WasiColors.outlineLight,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
