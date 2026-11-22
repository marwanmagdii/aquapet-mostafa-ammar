import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/notification_service.dart';
import 'data/repositories/app_providers.dart';
import 'data/repositories/local_storage_service.dart';
import 'data/repositories/repositories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorageService(prefs);
  final user = await MockUserRepository(storage).loadProfile();

  final nextRoute = !user.isOnboarded
      ? '/onboarding'
      : (!user.isLoggedIn ? '/auth' : '/home');

  final router = createAppRouter(initialLocation: '/splash?next=$nextRoute');

  await NotificationService.instance.init(
    onTap: (productId) {
      if (productId != null && productId.isNotEmpty) {
        router.push('/product/$productId');
      }
    },
  );

  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(storage),
      ],
      child: PetShopApp(router: router),
    ),
  );
}

class PetShopApp extends ConsumerWidget {
  const PetShopApp({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isDark = ref.watch(darkModeProvider);
    final effectiveRouter =
        router ?? createAppRouter(initialLocation: '/home');

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: locale,
      theme: AppTheme.light(locale: locale),
      darkTheme: AppTheme.dark(locale: locale),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      routerConfig: effectiveRouter,
    );
  }
}
