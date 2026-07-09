import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Grilla de miniaturas de fotos que abren en pantalla completa al tocar.
class PhotoGallery extends StatelessWidget {
  final List<String> photoUrls;
  final int crossAxisCount;
  final double spacing;
  final double aspectRatio;
  final String heroTagPrefix;

  const PhotoGallery({
    super.key,
    required this.photoUrls,
    this.crossAxisCount = 3,
    this.spacing = 8,
    this.aspectRatio = 1.0,
    this.heroTagPrefix = 'photo',
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrls.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo_library_outlined,
                size: 48,
                color: WasiColors.textTertiaryLight.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'Sin fotos disponibles',
                style: TextStyle(
                  color: WasiColors.textTertiaryLight,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: photoUrls.length,
      itemBuilder: (context, index) {
        return _PhotoThumbnail(
          imageUrl: photoUrls[index],
          heroTag: '$heroTagPrefix-$index',
          onTap: () => _openFullscreen(context, index),
        );
      },
    );
  }

  void _openFullscreen(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black87,
        fullscreenDialog: true,
        pageBuilder: (_, __, ___) => _FullscreenGallery(
          photoUrls: photoUrls,
          initialIndex: initialIndex,
          heroTagPrefix: heroTagPrefix,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

/// Miniatura individual con hero animation
class _PhotoThumbnail extends StatelessWidget {
  final String imageUrl;
  final String heroTag;
  final VoidCallback onTap;

  const _PhotoThumbnail({
    required this.imageUrl,
    required this.heroTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? WasiColors.surfaceVariantDark
                  : WasiColors.surfaceVariantLight,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: isDark
                          ? WasiColors.textTertiaryDark
                          : WasiColors.textTertiaryLight,
                      size: 24,
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          WasiColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                    );
                  },
                ),
                // Overlay sutil al hover
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      splashColor: Colors.black.withValues(alpha: 0.1),
                      highlightColor: Colors.black.withValues(alpha: 0.05),
                    ),
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

/// Galería en pantalla completa con PageView
class _FullscreenGallery extends StatefulWidget {
  final List<String> photoUrls;
  final int initialIndex;
  final String heroTagPrefix;

  const _FullscreenGallery({
    required this.photoUrls,
    required this.initialIndex,
    required this.heroTagPrefix,
  });

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.photoUrls.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.photoUrls.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          return InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Hero(
                tag: '${widget.heroTagPrefix}-$index',
                child: Image.network(
                  widget.photoUrls[index],
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
