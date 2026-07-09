import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/design.dart';
import '../config/routes.dart';

/// Pantalla de onboarding refinada con 5 páginas.
/// Sin emojis — usa iconos SVG/material profesionales.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  static const _pageCount = 5;

  static const _pages = [
    _OnboardingPageData(
      icon: Icons.home_work_rounded,
      title: 'Encuentra tu wasi',
      description:
          'Explora habitaciones verificadas cerca de tu universidad en Cusco. Filtra por precio, ubicación y servicios.',
      gradient: [WasiDesign.primaryDark, WasiDesign.primary],
    ),
    _OnboardingPageData(
      icon: Icons.verified_user_rounded,
      title: 'Verificación en 12 puntos',
      description:
          'Cada habitación es visitada por nuestro equipo. Identidad del propietario, seguridad eléctrica, agua, salidas de emergencia. No son solo fotos.',
      gradient: [WasiDesign.info, WasiDesign.infoLight],
    ),
    _OnboardingPageData(
      icon: Icons.description_rounded,
      title: 'Contrato legal incluido',
      description:
          'Cada alquiler incluye un contrato con 5 cláusulas basadas en el Código Civil peruano. Precio fijo, depósito garantizado, sin cobros ocultos.',
      gradient: [WasiDesign.success, WasiDesign.success400],
    ),
    _OnboardingPageData(
      icon: Icons.shield_rounded,
      title: 'Trust Score transparente',
      description:
          'Nuestro sistema único de confianza mide 4 factores: verificación, contratos, reseñas verificadas y antigüedad. Tú decides con información real.',
      gradient: [WasiDesign.warning, WasiDesign.accentLight],
    ),
    _OnboardingPageData(
      icon: Icons.handshake_rounded,
      title: 'Comunidad protegida',
      description:
          'Estudiantes y propietarios verificados. Reseñas solo de inquilinos reales. WasiStudent es confianza mutua, no un portal más de avisos.',
      gradient: [WasiDesign.primary, WasiDesign.primaryLight],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: WasiDesign.durationSpring,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: WasiDesign.curveSpring,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: WasiDesign.durationSlow,
        curve: WasiDesign.curveStandard,
      );
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _goToPrev() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: WasiDesign.durationSlow,
        curve: WasiDesign.curveStandard,
      );
    }
  }

  void _skip() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pageCount - 1;
    final page = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: WasiDesign.durationSlow,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: page.gradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Barra superior ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: WasiDesign.spaceLg,
                  vertical: WasiDesign.spaceSm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón atrás
                    AnimatedOpacity(
                      opacity: _currentPage == 0 ? 0.0 : 1.0,
                      duration: WasiDesign.durationBase,
                      child: IconButton(
                        onPressed: _currentPage == 0 ? null : _goToPrev,
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: Colors.white),
                      ),
                    ),
                    // Logo + nombre
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius:
                                BorderRadius.circular(WasiDesign.radiusSm),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'W',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'WasiStudent',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    // Saltar
                    AnimatedOpacity(
                      opacity: isLastPage ? 0.0 : 1.0,
                      duration: WasiDesign.durationBase,
                      child: TextButton(
                        onPressed: isLastPage ? null : _skip,
                        child: const Text(
                          'Saltar',
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Indicadores de página ──
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: WasiDesign.spaceXxl),
                child: _PageIndicators(
                  pageCount: _pageCount,
                  currentPage: _currentPage,
                ),
              ),

              // ── Contenido ──
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _pageCount,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                    _fadeController.reset();
                    _fadeController.forward();
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPageContent(
                      data: _pages[index],
                      fadeAnimation: _fadeAnimation,
                    );
                  },
                ),
              ),

              // ── Botón inferior ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  WasiDesign.spaceXxl,
                  WasiDesign.spaceLg,
                  WasiDesign.spaceXxl,
                  WasiDesign.spaceXxl + 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(WasiDesign.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _goToNext,
                        borderRadius:
                            BorderRadius.circular(WasiDesign.radiusMd),
                        child: Center(
                          child: AnimatedSwitcher(
                            duration: WasiDesign.durationBase,
                            child: Row(
                              key: ValueKey(isLastPage),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isLastPage ? 'Comenzar ahora' : 'Continuar',
                                  style: TextStyle(
                                    color: WasiDesign.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isLastPage
                                      ? Icons.arrow_forward_rounded
                                      : Icons.arrow_forward_rounded,
                                  color: WasiDesign.primary,
                                  size: 20,
                                ),
                              ],
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
      ),
    );
  }
}

/// ── Datos de una página de onboarding ──
class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}

/// ── Contenido individual de cada página ──
class _OnboardingPageContent extends StatelessWidget {
  final _OnboardingPageData data;
  final Animation<double> fadeAnimation;

  const _OnboardingPageContent({
    required this.data,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: WasiDesign.spaceXxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),

          // ── Icono grande con halo ──
          FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: fadeAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Halo decorativo
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Icono
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                    child: Icon(
                      data.icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: WasiDesign.space5xl),

          // ── Título ──
          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
                height: 1.2,
              ),
            ),
          ),

          const SizedBox(height: WasiDesign.spaceXl),

          // ── Descripción ──
          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.6,
                letterSpacing: 0.1,
              ),
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
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        final isPast = index < currentPage;

        return Expanded(
          child: AnimatedContainer(
            duration: WasiDesign.durationBase,
            curve: WasiDesign.curveSpring,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WasiDesign.radiusFull),
              color: isActive
                  ? Colors.white
                  : isPast
                      ? Colors.white.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.25),
            ),
          ),
        );
      }),
    );
  }
}
