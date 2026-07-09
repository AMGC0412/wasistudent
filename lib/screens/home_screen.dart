import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/room.dart';
import '../providers/room_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/preference_provider.dart';
import '../providers/role_provider.dart';
import '../utils/format_helpers.dart';
import 'owner/owner_dashboard_screen.dart';

/// Pantalla principal (Home) con contenido personalizado para el estudiante.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

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
    if (roomProvider.allRooms.isEmpty) {
      await roomProvider.loadRooms();
    }
    _animController.forward();
  }

  Future<void> _onRefresh() async {
    final roomProvider = context.read<RoomProvider>();
    await roomProvider.loadRooms();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = context.watch<RoleProvider>();
    // Si el rol activo es propietaria, mostrar su dashboard en lugar del
    // home de estudiante. Ambos comparten el tab "Inicio" de la bottom nav.
    if (roleProvider.isOwner) {
      return const OwnerDashboardScreen();
    }
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notifProvider = context.watch<NotificationProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: WasiColors.primary,
        backgroundColor: isDark ? WasiColors.surfaceDark : Colors.white,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── AppBar personalizado ──
            SliverToBoxAdapter(child: _buildAppBar(isDark, notifProvider)),

            // ── Barra de búsqueda ──
            SliverToBoxAdapter(child: _buildSearchBar(isDark)),

            // ── Ajustar prioridades de búsqueda (acceso directo) ──
            SliverToBoxAdapter(child: _buildPrioritiesShortcut(isDark)),

            // ── Chips de filtro rápido ──
            SliverToBoxAdapter(child: _buildQuickFilters(isDark)),

            // ── Sección "Para ti" ──
            _buildParaTiSection(theme, isDark),

            // ── Sección "Verificados recientemente" ──
            _buildVerifiedSection(theme, isDark),

            // ── Sección "Últimos agregados" ──
            _buildLatestSection(theme, isDark),

            // Espacio final para FAB
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.discover),
        icon: const Icon(Icons.auto_awesome_rounded, size: 20),
        label: const Text(
          'Descubrir',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        heroTag: 'discover_fab',
      ),
    );
  }

  // ──────────────────────────────────────────
  //  ACCESO DIRECTO: AJUSTAR PRIORIDADES
  // ──────────────────────────────────────────
  /// Card en el home que resume las 6 dimensiones del matching y permite
  /// al usuario ajustar los pesos con un toque. Si el usuario no ha
  /// configurado nada, muestra "Pesos balanceados (recomendado)".
  Widget _buildPrioritiesShortcut(bool isDark) {
    final prefs = context.watch<PreferenceProvider>().prefs;
    final hasCustomPriorities = prefs.priorities.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(WasiSpacing.lg, 8, WasiSpacing.lg, 8),
      child: Material(
        color: WasiColors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => context.go(AppRoutes.preferences),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: WasiColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ajusta tus prioridades de búsqueda',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: WasiColors.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasCustomPriorities
                            ? 'Pesos personalizados · toca para editar'
                            : 'Pesos balanceados (recomendado) · toca para personalizar',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: WasiColors.onPrimaryContainer
                              .withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                // 6 puntos indicando las dimensiones
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(6, (i) {
                    final dimensionColors = [
                      WasiColors.primary,
                      WasiColors.success,
                      const Color(0xFF9C27B0),
                      const Color(0xFFE91E63),
                      const Color(0xFF00BCD4),
                      const Color(0xFFFF9800),
                    ];
                    return Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        color: dimensionColors[i],
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: WasiColors.onPrimaryContainer,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  //  APP BAR
  // ──────────────────────────────────────────
  Widget _buildAppBar(bool isDark, NotificationProvider notifProvider) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          WasiSpacing.lg,
          WasiSpacing.sm,
          WasiSpacing.lg,
          0,
        ),
        child: Row(
          children: [
            // Logo
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [WasiColors.primary, WasiColors.primaryLight],
                  ).createShader(bounds),
                  child: const Text(
                    'WasiStudent',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Ubicación
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? WasiColors.surfaceVariantDark
                    : WasiColors.surfaceVariantLight,
                borderRadius: BorderRadius.circular(WasiRadius.xl),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: isDark
                        ? WasiColors.accentLight
                        : WasiColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Cusco',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? WasiColors.textPrimaryDark
                          : WasiColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: WasiSpacing.sm),

            // Campana de notificaciones
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? WasiColors.surfaceVariantDark
                        : WasiColors.surfaceVariantLight,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () =>
                        context.push(AppRoutes.notifications),
                    icon: Icon(
                      Icons.notifications_outlined,
                      size: 22,
                      color: isDark
                          ? WasiColors.textPrimaryDark
                          : WasiColors.textPrimaryLight,
                    ),
                  ),
                ),
                if (notifProvider.unreadCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: WasiColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? WasiColors.surfaceDark
                              : WasiColors.surfaceLight,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${notifProvider.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  //  BARRA DE BÚSQUEDA
  // ──────────────────────────────────────────
  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        WasiSpacing.lg,
        WasiSpacing.lg,
        WasiSpacing.lg,
        WasiSpacing.sm,
      ),
      child: Material(
        color: isDark
            ? WasiColors.surfaceVariantDark
            : WasiColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(WasiRadius.lg),
        child: InkWell(
          onTap: () => context.push(AppRoutes.search),
          borderRadius: BorderRadius.circular(WasiRadius.lg),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WasiRadius.lg),
              border: Border.all(
                color: isDark
                    ? WasiColors.outlineDark.withValues(alpha: 0.3)
                    : WasiColors.outlineLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: isDark
                      ? WasiColors.textTertiaryDark
                      : WasiColors.textTertiaryLight,
                ),
                const SizedBox(width: 12),
                Text(
                  'Buscar habitaciones, distritos...',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? WasiColors.textTertiaryDark
                        : WasiColors.textTertiaryLight,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: isDark
                      ? WasiColors.textTertiaryDark
                      : WasiColors.textTertiaryLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  //  CHIPS DE FILTRO RÁPIDO
  // ──────────────────────────────────────────
  Widget _buildQuickFilters(bool isDark) {
    final filters = [
      (Icons.savings_rounded, 'Hasta S/600'),
      (Icons.location_on_rounded, 'Cerca de UNSAAC'),
      (Icons.verified_rounded, 'Verificados'),
      (Icons.chair_rounded, 'Amoblados'),
      (Icons.lock_rounded, 'Contrato digital'),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: WasiSpacing.lg),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (iconData, label) = filters[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? WasiColors.surfaceVariantDark
                  : WasiColors.surfaceLight,
              borderRadius: BorderRadius.circular(WasiRadius.xxl),
              border: Border.all(
                color: isDark
                    ? WasiColors.outlineDark.withValues(alpha: 0.3)
                    : WasiColors.outlineLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, size: 14, color: WasiColors.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? WasiColors.textSecondaryDark
                        : WasiColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────
  //  SECCIÓN "PARA TI"
  // ──────────────────────────────────────────
  Widget _buildParaTiSection(ThemeData theme, bool isDark) {
    return Consumer<RoomProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return SliverToBoxAdapter(
            child: _buildLoadingShimmer(isDark),
          );
        }

        final rooms = provider.rooms.take(8).toList();
        if (rooms.isEmpty) {
          return SliverToBoxAdapter(
            child: _buildEmptyState(
              isDark: isDark,
              icon: Icons.search_off_rounded,
              title: 'Sin resultados',
              subtitle: 'Prueba ajustando tus preferencias',
            ),
          );
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de sección
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  WasiSpacing.lg,
                  WasiSpacing.xl,
                  WasiSpacing.lg,
                  WasiSpacing.md,
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, size: 18, color: WasiColors.accent),
                    const SizedBox(width: 6),
                    const Text(
                      'Para ti',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.explore),
                      child: const Text('Ver todo'),
                    ),
                  ],
                ),
              ),

              // Cards horizontales
              SizedBox(
                height: 260,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: WasiSpacing.lg,
                  ),
                  itemCount: rooms.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: WasiSpacing.md),
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return _HomeRoomCard(
                      room: room,
                      isFavorite: provider.isFavorite(room.id),
                      onFavoriteTap: () =>
                          provider.toggleFavorite(room.id),
                      onTap: () => context
                          .push('/room/${room.id}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ──────────────────────────────────────────
  //  SECCIÓN "VERIFICADOS RECIENTEMENTE"
  // ──────────────────────────────────────────
  Widget _buildVerifiedSection(ThemeData theme, bool isDark) {
    return Consumer<RoomProvider>(
      builder: (context, provider, _) {
        final verified = provider.getVerifiedRooms().take(3).toList();
        if (verified.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  WasiSpacing.lg,
                  WasiSpacing.xxl,
                  WasiSpacing.lg,
                  WasiSpacing.md,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: WasiColors.successContainer,
                        borderRadius: BorderRadius.circular(WasiRadius.sm),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: WasiColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Verificados recientemente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),

              ...verified.map((room) => _VerifiedListTile(
                    room: room,
                    isDark: isDark,
                    onTap: () => context.push('/room/${room.id}'),
                  )),
            ],
          ),
        );
      },
    );
  }

  // ──────────────────────────────────────────
  //  SECCIÓN "ÚLTIMOS AGREGADOS"
  // ──────────────────────────────────────────
  Widget _buildLatestSection(ThemeData theme, bool isDark) {
    return Consumer<RoomProvider>(
      builder: (context, provider, _) {
        final latest = provider.rooms
            .where((r) => r.isActive)
            .toList()
            .reversed
            .take(4)
            .toList();
        if (latest.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  WasiSpacing.lg,
                  WasiSpacing.xxl,
                  WasiSpacing.lg,
                  WasiSpacing.md,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule_rounded, size: 18, color: WasiColors.textSecondaryLight),
                    const SizedBox(width: 6),
                    const Text(
                      'Últimos agregados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),

              ...latest.map((room) => _LatestListTile(
                    room: room,
                    isDark: isDark,
                    onTap: () => context.push('/room/${room.id}'),
                  )),
            ],
          ),
        );
      },
    );
  }

  // ──────────────────────────────────────────
  //  HELPERS
  // ──────────────────────────────────────────

  Widget _buildLoadingShimmer(bool isDark) {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: WasiSpacing.lg),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: WasiSpacing.md),
        itemBuilder: (context, _) => Container(
          width: 220,
          decoration: BoxDecoration(
            color: isDark ? WasiColors.surfaceVariantDark : WasiColors.surfaceVariantLight,
            borderRadius: BorderRadius.circular(WasiRadius.lg),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(WasiSpacing.huge),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Icon(
            icon,
            size: 64,
            color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? WasiColors.textPrimaryDark : WasiColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
//  HOME ROOM CARD (horizontal)
// ──────────────────────────────────────────
class _HomeRoomCard extends StatelessWidget {
  final Room room;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  const _HomeRoomCard({
    required this.room,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
          borderRadius: BorderRadius.circular(WasiRadius.lg),
          border: Border.all(
            color: isDark
                ? WasiColors.outlineDark.withValues(alpha: 0.3)
                : WasiColors.outlineLight,
            width: 1,
          ),
          boxShadow: WasiShadows.card(isLight: !isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen placeholder ──
            Stack(
              children: [
                Container(
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: WasiColors.primaryContainer,
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

                // Badge de match
                if (room.matchingScore > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [WasiColors.accent, WasiColors.accentLight],
                        ),
                        borderRadius: BorderRadius.circular(WasiRadius.sm),
                      ),
                      child: Text(
                        '${room.matchingScore.round()}% match',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                // Botón favorito
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 18,
                        color: isFavorite ? WasiColors.error : Colors.white,
                      ),
                    ),
                  ),
                ),

                // Badge de verificación
                if (room.verificationLevel >= 2)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: WasiColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            // ── Info ──
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    F.pricePerMonth(room.price),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: WasiColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? WasiColors.textPrimaryDark
                          : WasiColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 13,
                        color: isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          room.district,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? WasiColors.textTertiaryDark
                                : WasiColors.textTertiaryLight,
                          ),
                        ),
                      ),
                      if (room.walkingTimeMin > 0) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.directions_walk_rounded,
                          size: 13,
                          color: isDark
                              ? WasiColors.textTertiaryDark
                              : WasiColors.textTertiaryLight,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${room.walkingTimeMin} min',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? WasiColors.textTertiaryDark
                                : WasiColors.textTertiaryLight,
                          ),
                        ),
                      ],
                    ],
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

// ──────────────────────────────────────────
//  VERIFIED LIST TILE
// ──────────────────────────────────────────
class _VerifiedListTile extends StatelessWidget {
  final Room room;
  final bool isDark;
  final VoidCallback onTap;

  const _VerifiedListTile({
    required this.room,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WasiSpacing.lg,
        vertical: WasiSpacing.xs,
      ),
      child: Material(
        color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(WasiRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(WasiRadius.md),
          child: Container(
            padding: const EdgeInsets.all(WasiSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WasiRadius.md),
              border: Border.all(
                color: isDark
                    ? WasiColors.outlineDark.withValues(alpha: 0.3)
                    : WasiColors.outlineLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Avatar del propietario
                CircleAvatar(
                  radius: 22,
                  backgroundColor: WasiColors.primaryContainer,
                  child: Text(
                    room.ownerAvatar,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: WasiColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: WasiSpacing.md),
                Expanded(
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
                          color: isDark
                              ? WasiColors.textPrimaryDark
                              : WasiColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${room.district} · ${room.ownerName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? WasiColors.textTertiaryDark
                              : WasiColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      F.price(room.price),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: WasiColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 13,
                          color: WasiColors.success,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Verificado',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? WasiColors.successLight
                                : WasiColors.successDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  LATEST LIST TILE
// ──────────────────────────────────────────
class _LatestListTile extends StatelessWidget {
  final Room room;
  final bool isDark;
  final VoidCallback onTap;

  const _LatestListTile({
    required this.room,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WasiSpacing.lg,
        vertical: WasiSpacing.xs,
      ),
      child: Material(
        color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
        borderRadius: BorderRadius.circular(WasiRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(WasiRadius.md),
          child: Container(
            padding: const EdgeInsets.all(WasiSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WasiRadius.md),
              border: Border.all(
                color: isDark
                    ? WasiColors.outlineDark.withValues(alpha: 0.3)
                    : WasiColors.outlineLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: WasiColors.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(WasiRadius.md),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bed_outlined,
                      color: WasiColors.primary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: WasiSpacing.md),
                Expanded(
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
                          color: isDark
                              ? WasiColors.textPrimaryDark
                              : WasiColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${room.district} · ${F.walkingTime(room.walkingTimeMin.toDouble())}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? WasiColors.textTertiaryDark
                              : WasiColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  F.pricePerMonth(room.price),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WasiColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
