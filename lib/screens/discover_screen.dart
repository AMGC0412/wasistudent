import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/room.dart';
import '../providers/room_provider.dart';
import '../utils/format_helpers.dart';

/// Pantalla estilo Tinder para descubrir habitaciones con swipe.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  late AnimationController _cardEnterController;
  late AnimationController _undoController;

  List<Room> _rooms = [];
  int _currentIndex = 0;
  List<_SwipeAction> _history = [];
  bool _initialized = false;

  // Drag state
  double _dragX = 0;
  double _dragY = 0;
  // ignore: unused_field
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _cardEnterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _undoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
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
    final provider = context.read<RoomProvider>();
    if (provider.allRooms.isEmpty) {
      await provider.loadRooms();
    }
    setState(() {
      _rooms = List.from(provider.allRooms.where((r) => r.isActive));
    });
    _cardEnterController.forward();
  }

  void _onSwipeRight() {
    // Favorito
    final provider = context.read<RoomProvider>();
    if (_rooms.isNotEmpty && _currentIndex < _rooms.length) {
      provider.toggleFavorite(_rooms[_currentIndex].id);
    }
    _history.add(_SwipeAction.favorite);
    _advanceCard();
  }

  void _onSwipeLeft() {
    // Rechazar
    _history.add(_SwipeAction.pass);
    _advanceCard();
  }

  void _advanceCard() {
    setState(() {
      _currentIndex++;
      _dragX = 0;
      _dragY = 0;
      _isDragging = false;
    });
    _cardEnterController.forward(from: 0);
  }

  void _undoLastSwipe() {
    if (_history.isEmpty || _currentIndex == 0) return;
    setState(() {
      _currentIndex--;
      _history.removeLast();
      _dragX = 0;
      _dragY = 0;
    });
    _undoController.forward(from: 0).then((_) {
      _undoController.reverse();
    });
  }

  @override
  void dispose() {
    _cardEnterController.dispose();
    _undoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final isFinished = _currentIndex >= _rooms.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Descubrir'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              onPressed: _undoLastSwipe,
              icon: const Icon(Icons.undo_rounded),
              tooltip: 'Deshacer',
            ),
        ],
      ),
      body: isFinished
          ? _buildFinishedState(isDark)
          : Column(
              children: [
                // ── Contador ──
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: WasiSpacing.sm),
                  child: Text(
                    '${_currentIndex + 1} de ${_rooms.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? WasiColors.textTertiaryDark
                          : WasiColors.textTertiaryLight,
                    ),
                  ),
                ),

                // ── Cards ──
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: WasiSpacing.lg,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Cards de fondo (preview)
                            if (_currentIndex + 2 < _rooms.length)
                              _buildBackgroundCard(
                                constraints,
                                isDark,
                                scale: 0.88,
                                offset: 20,
                              ),
                            if (_currentIndex + 1 < _rooms.length)
                              _buildBackgroundCard(
                                constraints,
                                isDark,
                                scale: 0.94,
                                offset: 8,
                              ),

                            // Card principal (draggable)
                            if (_currentIndex < _rooms.length)
                              _buildMainCard(
                                constraints,
                                isDark,
                                size,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // ── Botones de acción ──
                _buildActionButtons(isDark),

                const SizedBox(height: WasiSpacing.xxl),
              ],
            ),
    );
  }

  // ──────────────────────────────────────────
  //  CARD DE FONDO
  // ──────────────────────────────────────────
  Widget _buildBackgroundCard(
    BoxConstraints constraints,
    bool isDark, {
    required double scale,
    required double offset,
  }) {
    return Positioned.fill(
      top: offset,
      child: Transform.scale(
        scale: scale,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
            borderRadius: BorderRadius.circular(WasiRadius.xxl),
            border: Border.all(
              color: isDark
                  ? WasiColors.outlineDark.withValues(alpha: 0.3)
                  : WasiColors.outlineLight,
              width: 1,
            ),
            boxShadow: WasiShadows.medium(isLight: !isDark),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  //  CARD PRINCIPAL (DRAGGABLE)
  // ──────────────────────────────────────────
  Widget _buildMainCard(BoxConstraints constraints, bool isDark, Size screenSize) {
    final room = _rooms[_currentIndex];
    final rotation = _dragX / screenSize.width * 0.4;
    final swipeThreshold = screenSize.width * 0.35;

    // Colores de overlay
    final likeOpacity = (_dragX / swipeThreshold).clamp(0.0, 1.0);
    final passOpacity = (-_dragX / swipeThreshold).clamp(0.0, 1.0);

    return GestureDetector(
      onPanStart: (_) => setState(() => _isDragging = true),
      onPanUpdate: (details) {
        setState(() {
          _dragX += details.delta.dx;
          _dragY += details.delta.dy;
        });
      },
      onPanEnd: (details) {
        if (_dragX > swipeThreshold) {
          _onSwipeRight();
        } else if (_dragX < -swipeThreshold) {
          _onSwipeLeft();
        } else {
          setState(() {
            _dragX = 0;
            _dragY = 0;
            _isDragging = false;
          });
        }
      },
      child: Transform.translate(
        offset: Offset(_dragX, _dragY),
        child: Transform.rotate(
          angle: rotation,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
              borderRadius: BorderRadius.circular(WasiRadius.xxl),
              border: Border.all(
                color: isDark
                    ? WasiColors.outlineDark.withValues(alpha: 0.3)
                    : WasiColors.outlineLight,
                width: 1,
              ),
              boxShadow: WasiShadows.strong(isLight: !isDark),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(WasiRadius.xxl),
              child: Stack(
                children: [
                  // ── Contenido de la card ──
                  Column(
                    children: [
                      // Imagen placeholder
                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          color: WasiColors.primaryContainer,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              const Center(
                                child: Icon(
                                  Icons.bed_rounded,
                                  size: 64,
                                  color: WasiColors.primary,
                                ),
                              ),

                              // Match badge
                              if (room.matchingScore > 0)
                                Positioned(
                                  top: 20,
                                  left: 20,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          WasiColors.accent,
                                          WasiColors.accentLight,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(WasiRadius.lg),
                                      boxShadow: [
                                        BoxShadow(
                                          color: WasiColors.accent.withValues(alpha: 0.3),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.auto_awesome_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '${room.matchingScore.round()}% match',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              // Verificación
                              if (room.verificationLevel >= 2)
                                Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: WasiColors.success,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.verified_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Info
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(WasiSpacing.xxl),
                          color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      room.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                        color: isDark
                                            ? WasiColors.textPrimaryDark
                                            : WasiColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                F.pricePerMonth(room.price),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: WasiColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _InfoChip(
                                    icon: Icons.location_on_rounded,
                                    label: room.district,
                                    isDark: isDark,
                                  ),
                                  const SizedBox(width: 12),
                                  if (room.walkingTimeMin > 0)
                                    _InfoChip(
                                      icon: Icons.directions_walk_rounded,
                                      label: '${room.walkingTimeMin} min',
                                      isDark: isDark,
                                    ),
                                  const SizedBox(width: 12),
                                  if (room.sizeSqm > 0)
                                    _InfoChip(
                                      icon: Icons.square_foot_rounded,
                                      label: F.area(room.sizeSqm),
                                      isDark: isDark,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (room.amenities.isNotEmpty)
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: room.amenities.take(4).map((a) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? WasiColors.surfaceVariantDark
                                          : WasiColors.surfaceVariantLight,
                                      borderRadius: BorderRadius.circular(WasiRadius.sm),
                                    ),
                                    child: Text(
                                      a,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: isDark
                                            ? WasiColors.textSecondaryDark
                                            : WasiColors.textSecondaryLight,
                                      ),
                                    ),
                                  )).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Overlay LIKE (verde) ──
                  if (likeOpacity > 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: WasiColors.success.withValues(alpha: likeOpacity * 0.25),
                          borderRadius: BorderRadius.circular(WasiRadius.xxl),
                        ),
                        child: likeOpacity > 0.3
                            ? Center(
                                child: Transform.rotate(
                                  angle: -0.3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: WasiColors.success,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'FAVORITO',
                                      style: TextStyle(
                                        color: WasiColors.success,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),

                  // ── Overlay PASS (rojo) ──
                  if (passOpacity > 0)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: WasiColors.error.withValues(alpha: passOpacity * 0.25),
                          borderRadius: BorderRadius.circular(WasiRadius.xxl),
                        ),
                        child: passOpacity > 0.3
                            ? Center(
                                child: Transform.rotate(
                                  angle: 0.3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: WasiColors.error,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'PASAR',
                                      style: TextStyle(
                                        color: WasiColors.error,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  //  BOTONES DE ACCIÓN
  // ──────────────────────────────────────────
  Widget _buildActionButtons(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WasiSpacing.huge),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pasar
          _ActionButton(
            icon: Icons.close_rounded,
            color: WasiColors.error,
            size: 56,
            onPressed: _onSwipeLeft,
            label: 'Pasar',
          ),

          // Info
          _ActionButton(
            icon: Icons.info_outline_rounded,
            color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
            size: 44,
            onPressed: () {
              if (_currentIndex < _rooms.length) {
                context.push('/room/${_rooms[_currentIndex].id}');
              }
            },
            label: 'Info',
          ),

          // Favorito
          _ActionButton(
            icon: Icons.favorite_rounded,
            color: WasiColors.success,
            size: 56,
            onPressed: _onSwipeRight,
            label: 'Favorito',
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  ESTADO "HAS VISTO TODO"
  // ──────────────────────────────────────────
  Widget _buildFinishedState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WasiSpacing.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: WasiColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.celebration_rounded,
                  size: 48,
                  color: WasiColors.primary,
                ),
              ),
            ),
            const SizedBox(height: WasiSpacing.xxl),
            const Text(
              '¡Has visto todo!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: WasiSpacing.md),
            Text(
              'Vuelve más tarde para descubrir nuevas habitaciones o revisa tus favoritos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: WasiSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _undoLastSwipe,
                  icon: const Icon(Icons.undo_rounded, size: 18),
                  label: const Text('Deshacer'),
                ),
                const SizedBox(width: WasiSpacing.md),
                ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.favorites),
                  icon: const Icon(Icons.favorite_rounded, size: 18),
                  label: const Text('Favoritos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  ACTION BUTTON
// ──────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onPressed;
  final String label;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Center(
                child: Icon(icon, color: color, size: size * 0.4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
//  INFO CHIP
// ──────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 15,
          color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────
//  SWIPE ACTION ENUM
// ──────────────────────────────────────────
enum _SwipeAction { pass, favorite }
