import 'package:flutter/material.dart';

import '../config/theme.dart';

/// Pantalla de galería de fotos de una habitación.
/// Muestra un grid de placeholders con contador y navegación a fullscreen.
class RoomPhotosScreen extends StatefulWidget {
  final String roomId;

  const RoomPhotosScreen({super.key, required this.roomId});

  @override
  State<RoomPhotosScreen> createState() => _RoomPhotosScreenState();
}

class _RoomPhotosScreenState extends State<RoomPhotosScreen> {
  int _currentIndex = 0;
  bool _isFullscreen = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullscreen) {
      return _buildFullscreenView();
    }
    return _buildGridView();
  }

  // ── Grid View ─────────────────────────────────────────────────────

  Widget _buildGridView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotos'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '8 fotos',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: WasiColors.textSecondaryLight,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return _buildPhotoTile(index);
        },
      ),
    );
  }

  Widget _buildPhotoTile(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          _isFullscreen = true;
        });
      },
      child: Hero(
        tag: 'photo_$index',
        child: Container(
          decoration: BoxDecoration(
            color: WasiColors.surfaceVariantLight,
            borderRadius: WasiRadius.card,
            border: Border.all(
              color: WasiColors.outlineLight.withValues(alpha: 0.4),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder image area
              const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: WasiColors.textTertiaryLight,
                ),
              ),
              // Photo number
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Fullscreen View ───────────────────────────────────────────────

  Widget _buildFullscreenView() {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1} / 8',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => _isFullscreen = false),
            icon: const Icon(Icons.grid_view, color: Colors.white),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemCount: 8,
        itemBuilder: (context, index) {
          return Hero(
            tag: 'photo_$index',
            child: Container(
              color: WasiColors.surfaceVariantDark,
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 80,
                  color: WasiColors.textTertiaryDark,
                ),
              ),
            ),
          );
        },
      ),
      // Bottom counter
      bottomNavigationBar: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            8,
            (index) => AnimatedContainer(
              duration: WasiDuration.fast,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.white
                    : Colors.white38,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
