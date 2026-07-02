import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/trust_score.dart';
import '../theme/design.dart';
import '../providers/auth_provider.dart';
import '../providers/role_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/contract_flow_screen.dart';
import '../screens/explore_map_screen.dart';
import '../screens/home_screen.dart';
import '../screens/publish_room_screen.dart';
import '../screens/room_detail_screen.dart';
import '../screens/splash_screen.dart';

// Todas las screens restantes
import '../screens/onboarding_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/discover_screen.dart';
import '../screens/chat_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/room_photos_screen.dart';
import '../screens/preferences_screen.dart';
import '../screens/comparison_screen.dart';
import '../screens/trust_score_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/chat_detail_screen.dart';
import '../screens/reviews_screen.dart';
import '../screens/add_review_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/payments_screen.dart';
import '../screens/payment_detail_screen.dart';
import '../screens/roommate_matching_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';

// Owner screens
import '../screens/owner/owner_dashboard_screen.dart';
import '../screens/owner/owner_rooms_list_screen.dart';
import '../screens/owner/owner_requests_screen.dart';
import '../screens/owner/owner_contracts_screen.dart';
import '../screens/owner/owner_payments_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String discover = '/discover';
  static const String messages = '/messages';
  static const String profile = '/profile';
  static const String roomDetail = '/room/:id';
  static const String roomPhotos = '/room/:id/photos';
  static const String preferences = '/preferences';
  static const String comparison = '/comparison';
  static const String trustScore = '/trust-score';
  static const String contract = '/contract/:id';
  static const String editProfile = '/edit-profile';
  static const String chatDetail = '/chat/:id';
  static const String reviews = '/reviews/:roomId';
  static const String addReview = '/add-review/:roomId';
  static const String notifications = '/notifications';
  static const String payments = '/payments';
  static const String paymentDetail = '/payment/:id';
  static const String roommateMatching = '/roommate';
  static const String favorites = '/favorites';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String map = '/map';
  static const String publishRoom = '/publish-room';

  // Owner
  static const String ownerDashboard = '/owner';
  static const String ownerRooms = '/owner/rooms';
  static const String ownerRequests = '/owner/requests';
  static const String ownerContracts = '/owner/contracts';
  static const String ownerPayments = '/owner/payments';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final authProvider = context.read<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;
    final isAuthRoute = state.uri.path == AppRoutes.auth;
    final isSplash = state.uri.path == AppRoutes.splash;

    // Si no está autenticado y no está en auth/splash → ir a auth
    if (!isAuthenticated && !isAuthRoute && !isSplash) {
      return AppRoutes.auth;
    }
    // Si está autenticado y está en auth → ir a home
    if (isAuthenticated && isAuthRoute) {
      return AppRoutes.home;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) => MainShell(
        currentLocation: state.uri.path,
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: AppRoutes.explore,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ExploreScreen()),
        ),
        GoRoute(
          path: AppRoutes.discover,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DiscoverScreen()),
        ),
        GoRoute(
          path: AppRoutes.messages,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ChatListScreen()),
        ),
        GoRoute(
          path: AppRoutes.profile,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.roomDetail,
      builder: (context, state) => RoomDetailScreen(
        roomId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.roomPhotos,
      builder: (context, state) => RoomPhotosScreen(
        roomId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.preferences,
      builder: (context, state) => const PreferencesScreen(),
    ),
    GoRoute(
      path: AppRoutes.comparison,
      builder: (context, state) => const ComparisonScreen(),
    ),
    GoRoute(
      path: AppRoutes.trustScore,
      builder: (context, state) => TrustScoreScreen(
        trustScore: state.extra is TrustScoreModel
            ? state.extra as TrustScoreModel
            : TrustScoreModel.mock(),
      ),
    ),
    GoRoute(
      path: AppRoutes.contract,
      builder: (context, state) => ContractFlowScreen(
        roomId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatDetail,
      builder: (context, state) => ChatDetailScreen(
        conversationId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.reviews,
      builder: (context, state) => ReviewsScreen(
        roomId: state.pathParameters['roomId'] ?? '',
        roomTitle: (state.extra is Map ? state.extra as Map : const {})['roomTitle'] as String? ?? 'Habitación',
      ),
    ),
    GoRoute(
      path: AppRoutes.addReview,
      builder: (context, state) => AddReviewScreen(
        roomId: state.pathParameters['roomId'] ?? '',
        roomTitle: (state.extra is Map ? state.extra as Map : const {})['roomTitle'] as String? ?? 'Habitación',
      ),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.payments,
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.paymentDetail,
      builder: (context, state) => PaymentDetailScreen(
        paymentId: state.pathParameters['id'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.roommateMatching,
      builder: (context, state) => const RoommateMatchingScreen(),
    ),
    GoRoute(
      path: AppRoutes.favorites,
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: AppRoutes.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.map,
      builder: (context, state) => const ExploreMapScreen(),
    ),
    GoRoute(
      path: AppRoutes.publishRoom,
      builder: (context, state) => const PublishRoomScreen(),
    ),

    // Owner
    GoRoute(
      path: AppRoutes.ownerDashboard,
      builder: (context, state) => const OwnerDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.ownerRooms,
      builder: (context, state) => const OwnerRoomsListScreen(),
    ),
    GoRoute(
      path: AppRoutes.ownerRequests,
      builder: (context, state) => const OwnerRequestsScreen(),
    ),
    GoRoute(
      path: AppRoutes.ownerContracts,
      builder: (context, state) => const OwnerContractsScreen(),
    ),
    GoRoute(
      path: AppRoutes.ownerPayments,
      builder: (context, state) => const OwnerPaymentsScreen(),
    ),
  ],
);

// ──────────────────────────────────────────────
//  MAIN SHELL - Bottom Navigation
// ──────────────────────────────────────────────

class _NavItem {
  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _NavItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class MainShell extends StatelessWidget {
  final String currentLocation;
  final Widget child;

  const MainShell({
    super.key,
    required this.currentLocation,
    required this.child,
  });

  static const List<_NavItem> _navItems = [
    _NavItem(path: AppRoutes.home, label: 'Inicio', icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
    _NavItem(path: AppRoutes.explore, label: 'Explorar', icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded),
    _NavItem(path: AppRoutes.discover, label: 'Descubrir', icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome_rounded),
    _NavItem(path: AppRoutes.messages, label: 'Mensajes', icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded),
    _NavItem(path: AppRoutes.profile, label: 'Perfil', icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded),
  ];

  int get _currentIndex {
    for (int i = 0; i < _navItems.length; i++) {
      if (currentLocation.startsWith(_navItems[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currentIndex = _currentIndex;

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1A14) : WasiDesign.surface,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? WasiDesign.outline.withValues(alpha: 0.3)
                  : WasiDesign.outline,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = index == currentIndex;
                return _NavTabButton(
                  item: item,
                  isSelected: isSelected,
                  colorScheme: colorScheme,
                  isDark: isDark,
                  onTap: () {
                    if (index != currentIndex) {
                      context.go(item.path);
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTabButton extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final ColorScheme colorScheme;
  final bool isDark;
  final VoidCallback onTap;

  const _NavTabButton({
    required this.item,
    required this.isSelected,
    required this.colorScheme,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? WasiDesign.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: 22,
                    color: isSelected
                        ? WasiDesign.primary
                        : (isDark ? WasiDesign.textTertiary : WasiDesign.textTertiary),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? WasiDesign.primary : WasiDesign.textTertiary,
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
