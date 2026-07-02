import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';
import '../config/routes.dart';

/// Pantalla de onboarding con 4 páginas animadas.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pageCount = 4;

  // ── Datos de cada página ──
  static const _pages = [
    _OnboardingPageData(
      emoji: '🏠',
      title: 'Encuentra tu hogar',
      description:
          'Explora habitaciones verificadas cerca de tu universidad en Cusco. Filtra por precio, ubicación y estilo de vida.',
      gradientColors: [Color(0xFF1A535C), Color(0xFF2B7A85)],
    ),
    _OnboardingPageData(
      emoji: '✅',
      title: 'Verificación en persona',
      description:
          'Cada habitación es visitada y verificada por nuestro equipo. Fotos reales, condiciones reales, sin sorpresas.',
      gradientColors: [Color(0xFF0E3A42), Color(0xFF1A535C)],
    ),
    _OnboardingPageData(
      emoji: '📱',
      title: 'Contratos digitales',
      description:
          'Firma tu contrato desde tu celular. Sin papeleos, sin trámites lentos. Todo seguro y respaldado.',
      gradientColors: [Color(0xFF2B7A85), Color(0xFF4ECDC4)],
    ),
    _OnboardingPageData(
      emoji: '🛡️',
      title: 'Puntaje de confianza',
      description:
          'Nuestro sistema único de confianza protege tu alquiler. Basado en identidad, contratos cumplidos y reseñas reales.',
      gradientColors: [Color(0xFF1A535C), Color(0xFFF9A826)],
    ),
  ];

  void _goToNext() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: WasiDuration.pageTransition,
        curve: WasiCurves.easeInOutCubic,
      );
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _skip() {
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pageCount - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _pages[_currentPage].gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Barra superior ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WasiSpacing.lg,
                  vertical: WasiSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Saltar
                    AnimatedOpacity(
                      opacity: isLastPage ? 0.0 : 1.0,
                      duration: WasiDuration.fast,
                      child: TextButton(
                        onPressed: isLastPage ? null : _skip,
                        child: const Text(
                          'Saltar',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    // Indicadores de página
                    _PageIndicators(
                      pageCount: _pageCount,
                      currentPage: _currentPage,
                    ),
                  ],
                ),
              ),

              // ── Contenido de las páginas ──
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _pageCount,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPageContent(
                      data: _pages[index],
                      pageIndex: index,
                    );
                  },
                ),
              ),

              // ── Botón inferior ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  WasiSpacing.xxl,
                  WasiSpacing.lg,
                  WasiSpacing.xxl,
                  WasiSpacing.xxl + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botón principal
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: isLastPage
                              ? const LinearGradient(
                                  colors: [
                                    WasiColors.accent,
                                    WasiColors.accentLight,
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.2),
                                    Colors.white.withValues(alpha: 0.1),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(WasiRadius.xl),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1,
                          ),
                          boxShadow: isLastPage
                              ? [
                                  BoxShadow(
                                    color: WasiColors.accent
                                        .withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _goToNext,
                            borderRadius:
                                BorderRadius.circular(WasiRadius.xl),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: WasiDuration.normal,
                                child: Text(
                                  isLastPage ? 'Comenzar' : 'Siguiente',
                                  key: ValueKey(isLastPage),
                                  style: TextStyle(
                                    color: isLastPage
                                        ? WasiColors.primaryDark
                                        : Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── Datos de una página de onboarding ──
class _OnboardingPageData {
  final String emoji;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const _OnboardingPageData({
    required this.emoji,
    required this.title,
    required this.description,
    required this.gradientColors,
  });
}

/// ── Contenido individual de cada página ──
class _OnboardingPageContent extends StatelessWidget {
  final _OnboardingPageData data;
  final int pageIndex;

  const _OnboardingPageContent({
    required this.data,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WasiSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),

          // ── Emoji grande ──
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.5, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  data.emoji,
                  style: const TextStyle(fontSize: 56),
                ),
              ),
            ),
          ),

          const SizedBox(height: WasiSpacing.huge),

          // ── Título ──
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),

          const SizedBox(height: WasiSpacing.xl),

          // ── Descripción ──
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

/// ── Indicadores de página animados (dot + line) ──
class _PageIndicators extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  const _PageIndicators({
    required this.pageCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        final isPast = index < currentPage;

        return AnimatedContainer(
          duration: WasiDuration.normal,
          curve: WasiCurves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? WasiColors.accent
                : isPast
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.25),
          ),
        );
      }),
    );
  }
}
