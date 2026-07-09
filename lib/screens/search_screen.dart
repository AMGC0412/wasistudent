import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../models/room.dart';
import '../providers/room_provider.dart';
import '../utils/format_helpers.dart';

/// Pantalla de búsqueda con historial, sugerencias y resultados en tiempo real.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> _recentSearches = [];
  List<Room> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  // ── Búsquedas populares ──
  static const _popularSearches = [
    'Habitación cerca de UNSAAC',
    'Wanchaq',
    'Hasta S/600',
    'Amoblada',
    'Verificada',
    'Contrato digital',
    'Wi-Fi incluido',
    'San Blas',
  ];

  @override
  void initState() {
    super.initState();
    // Auto-focus después del frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _addRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _recentSearches = [
        query,
        ..._recentSearches.where((s) => s != query),
      ].take(8).toList();
    });
  }

  void _clearRecentSearches() {
    setState(() => _recentSearches = []);
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    final provider = context.read<RoomProvider>();
    await provider.searchRooms(query);

    if (!mounted) return;
    setState(() {
      _searchResults = provider.searchResults;
      _isSearching = false;
    });

    _addRecentSearch(query);
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showResults = _hasSearched || _searchController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: null,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          // ── Barra de búsqueda ──
          _buildSearchBar(isDark),

          // ── Contenido ──
          Expanded(
            child: showResults
                ? _buildSearchResults(isDark)
                : _buildSuggestions(isDark),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  BARRA DE BÚSQUEDA
  // ──────────────────────────────────────────
  Widget _buildSearchBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        WasiSpacing.lg,
        WasiSpacing.sm,
        WasiSpacing.lg,
        WasiSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? WasiColors.surfaceDark : WasiColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? WasiColors.outlineDark.withValues(alpha: 0.3)
                : WasiColors.outlineLight,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: true,
              onChanged: (value) {
                _performSearch(value);
              },
              onSubmitted: _performSearch,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? WasiColors.textPrimaryDark : WasiColors.textPrimaryLight,
              ),
              decoration: InputDecoration(
                hintText: 'Buscar habitaciones, distritos, dueños...',
                hintStyle: TextStyle(
                  color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _hasSearched = false;
                          });
                        },
                        icon: Icon(
                          Icons.clear_rounded,
                          color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? WasiColors.surfaceVariantDark
                    : WasiColors.surfaceVariantLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(WasiRadius.lg),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: WasiSpacing.sm),

          // Botón de filtro
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? WasiColors.surfaceVariantDark
                  : WasiColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(WasiRadius.md),
            ),
            child: IconButton(
              onPressed: () => context.push(AppRoutes.explore),
              icon: Icon(
                Icons.tune_rounded,
                color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
              ),
            ),
          ),

          // Voice search placeholder
          const SizedBox(width: WasiSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? WasiColors.surfaceVariantDark
                  : WasiColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(WasiRadius.md),
            ),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Búsqueda por voz próximamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(
                Icons.mic_rounded,
                color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  SUGERENCIAS (sin búsqueda activa)
  // ──────────────────────────────────────────
  Widget _buildSuggestions(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(WasiSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Búsquedas recientes ──
          if (_recentSearches.isNotEmpty) ...[
            Row(
              children: [
                const Text(
                  'Búsquedas recientes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: WasiSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return ActionChip(
                  onPressed: () => _onSuggestionTap(search),
                  avatar: Icon(
                    Icons.history_rounded,
                    size: 16,
                    color: isDark ? WasiColors.textTertiaryDark : WasiColors.textTertiaryLight,
                  ),
                  label: Text(search),
                  side: BorderSide(
                    color: isDark
                        ? WasiColors.outlineDark.withValues(alpha: 0.3)
                        : WasiColors.outlineLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WasiRadius.xxl),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: WasiSpacing.xxl),
          ],

          // ── Búsquedas populares ──
          const Text(
            'Búsquedas populares',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: WasiSpacing.md),
          ..._popularSearches.map((search) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: WasiSpacing.sm,
              ),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? WasiColors.surfaceVariantDark
                      : WasiColors.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(WasiRadius.md),
                ),
                child: Center(
                  child: Icon(
                    Icons.trending_up_rounded,
                    size: 18,
                    color: isDark
                        ? WasiColors.accentLight
                        : WasiColors.primary,
                  ),
                ),
              ),
              title: Text(
                search,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? WasiColors.textPrimaryDark
                      : WasiColors.textPrimaryLight,
                ),
              ),
              trailing: Icon(
                Icons.north_west_rounded,
                size: 18,
                color: isDark
                    ? WasiColors.textTertiaryDark
                    : WasiColors.textTertiaryLight,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WasiRadius.md),
              ),
              onTap: () => _onSuggestionTap(search),
            );
          }),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────
  //  RESULTADOS DE BÚSQUEDA
  // ──────────────────────────────────────────
  Widget _buildSearchResults(bool isDark) {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults(isDark);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            WasiSpacing.lg,
            WasiSpacing.md,
            WasiSpacing.lg,
            WasiSpacing.sm,
          ),
          child: Text(
            '${_searchResults.length} resultado${_searchResults.length == 1 ? '' : 's'}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              WasiSpacing.lg,
              0,
              WasiSpacing.lg,
              120,
            ),
            itemCount: _searchResults.length,
            separatorBuilder: (_, __) => const SizedBox(height: WasiSpacing.sm),
            itemBuilder: (context, index) {
              final room = _searchResults[index];
              return _SearchResultTile(
                room: room,
                isDark: isDark,
                searchQuery: _searchController.text.toLowerCase(),
                onTap: () => context.push('/room/${room.id}'),
              );
            },
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  //  SIN RESULTADOS
  // ──────────────────────────────────────────
  Widget _buildNoResults(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(WasiSpacing.huge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? WasiColors.surfaceVariantDark
                    : WasiColors.surfaceVariantLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.search_off_rounded,
                  size: 36,
                  color: isDark
                      ? WasiColors.textTertiaryDark
                      : WasiColors.textTertiaryLight,
                ),
              ),
            ),
            const SizedBox(height: WasiSpacing.xl),
            const Text(
              'Sin resultados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: WasiSpacing.sm),
            Text(
              'No encontramos habitaciones para "${_searchController.text}"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? WasiColors.textSecondaryDark : WasiColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: WasiSpacing.xl),
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                  _hasSearched = false;
                });
              },
              icon: const Icon(Icons.search_rounded, size: 18),
              label: const Text('Nueva búsqueda'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────
//  SEARCH RESULT TILE
// ──────────────────────────────────────────
class _SearchResultTile extends StatelessWidget {
  final Room room;
  final bool isDark;
  final String searchQuery;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.room,
    required this.isDark,
    required this.searchQuery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
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
              // Imagen
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: WasiColors.primaryContainer,
                  borderRadius: BorderRadius.circular(WasiRadius.md),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.bed_rounded,
                        color: WasiColors.primary,
                        size: 28,
                      ),
                    ),
                    // Badges
                    if (room.verificationLevel >= 2)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: WasiColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (room.matchingScore > 0)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: WasiColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${room.matchingScore.round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: WasiSpacing.md),

              // Info
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
                    const SizedBox(height: 3),
                    Text(
                      room.district,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? WasiColors.textTertiaryDark
                            : WasiColors.textTertiaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (room.amenities.isNotEmpty)
                      Row(
                        children: room.amenities.take(2).map((a) => Container(
                          margin: const EdgeInsets.only(right: 4),
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
                ),
              ),

              // Precio
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    F.price(room.price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: WasiColors.primary,
                    ),
                  ),
                  Text(
                    '/mes',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? WasiColors.textTertiaryDark
                          : WasiColors.textTertiaryLight,
                    ),
                  ),
                  if (room.walkingTimeMin > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.directions_walk_rounded,
                          size: 12,
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
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
