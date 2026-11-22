import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../features/blog/blog_screen.dart';
import '../../features/cart/cart_checkout_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/home/onboarding_auth_screens.dart';
import '../../features/home/splash_screen.dart';
import '../../features/loyalty/rewards_hub_screen.dart';
import '../../features/orders/orders_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reminders/reminders_screen.dart';
import '../../features/shop/product_detail_screen.dart';
import '../../features/shop/shop_screen.dart';
import '../../features/tanks/tanks_screen.dart';
import '../../features/vets/trusted_vets_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createAppRouter({required String initialLocation}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(
          nextRoute: state.uri.queryParameters['next'],
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductDetailScreen(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartCheckoutScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/tanks',
        builder: (context, state) => const TanksScreen(),
      ),
      GoRoute(
        path: '/vets',
        builder: (context, state) => const TrustedVetsScreen(),
      ),
      GoRoute(
        path: '/blog',
        builder: (context, state) => const BlogListScreen(),
      ),
      GoRoute(
        path: '/blog/:id',
        builder: (context, state) => BlogDetailScreen(
          postId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/cashier',
        builder: (context, state) => const CashierDemoScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _AppShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/shop',
                builder: (context, state) => ShopScreen(
                  initialCategory: state.uri.queryParameters['cat'],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rewards',
                builder: (context, state) => const RewardsHubScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reminders',
                builder: (context, state) => const RemindersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AppShellScaffold extends StatelessWidget {
  const _AppShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    final scaffold = Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: colors.outline.withOpacity(0.7)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.house()),
              selectedIcon:
                  PhosphorIcon(PhosphorIcons.house(PhosphorIconsStyle.fill)),
              label: l10n.navHome,
            ),
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.storefront()),
              selectedIcon: PhosphorIcon(
                PhosphorIcons.storefront(PhosphorIconsStyle.fill),
              ),
              label: l10n.navShop,
            ),
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.crownSimple()),
              selectedIcon: PhosphorIcon(
                PhosphorIcons.crownSimple(PhosphorIconsStyle.fill),
              ),
              label: l10n.navRewards,
            ),
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.bell()),
              selectedIcon:
                  PhosphorIcon(PhosphorIcons.bell(PhosphorIconsStyle.fill)),
              label: l10n.navReminders,
            ),
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.user()),
              selectedIcon:
                  PhosphorIcon(PhosphorIcons.user(PhosphorIconsStyle.fill)),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 520) return scaffold;
        return Container(
          color: const Color(0xFFE4F1F1),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            width: 430,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.outline, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x180F2A2E),
                  blurRadius: 32,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: scaffold,
          ),
        );
      },
    );
  }
}
