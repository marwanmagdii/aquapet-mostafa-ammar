import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_shop/core/theme/app_theme.dart';
import 'package:pet_shop/core/utils/loyalty_rules.dart';
import 'package:pet_shop/data/models/coupon.dart';
import 'package:pet_shop/data/models/loyalty.dart';
import 'package:pet_shop/data/models/reminder_tank.dart';
import 'package:pet_shop/data/repositories/app_providers.dart';
import 'package:pet_shop/data/repositories/local_storage_service.dart';
import 'package:pet_shop/features/blog/blog_screen.dart';
import 'package:pet_shop/features/vets/trusted_vets_screen.dart';
import 'package:pet_shop/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Loyalty math', () {
    test('calculates earned points with tier multipliers', () {
      expect(LoyaltyRules.calculateEarnedPoints(100, 1.0), 10);
      expect(LoyaltyRules.calculateEarnedPoints(100, 1.25), 12);
      expect(LoyaltyRules.calculateEarnedPoints(100, 1.5), 15);
      expect(LoyaltyRules.calculateEarnedPoints(0, 1.5), 0);
    });

    test('converts 100 points to 10 EGP discount', () {
      expect(LoyaltyRules.pointsToEgp(100), 10.0);
      expect(LoyaltyRules.pointsToEgp(550), 55.0);
    });

    test('resolves tiers from lifetime points', () {
      expect(LoyaltyTier.fromLifetimePoints(0), LoyaltyTier.bronze);
      expect(LoyaltyTier.fromLifetimePoints(999), LoyaltyTier.bronze);
      expect(LoyaltyTier.fromLifetimePoints(1000), LoyaltyTier.silver);
      expect(LoyaltyTier.fromLifetimePoints(2999), LoyaltyTier.silver);
      expect(LoyaltyTier.fromLifetimePoints(3000), LoyaltyTier.gold);
    });
  });

  group('Coupon logic', () {
    final now = DateTime(2026, 11, 16);

    test('applies percent, fixed, and respects minimum order', () {
      final percentCoupon = CouponModel(
        id: '1',
        code: 'FISH20',
        titleEn: '20% Off',
        titleAr: '٢٠٪',
        conditionEn: '',
        conditionAr: '',
        type: CouponType.percent,
        value: 20,
        minOrderEgp: 300,
        expiresAt: now.add(const Duration(days: 10)),
        status: CouponStatus.available,
      );

      expect(percentCoupon.computeDiscount(250), 0);
      expect(percentCoupon.computeDiscount(500), 100);

      final usedCoupon = percentCoupon.copyWith(status: CouponStatus.used);
      expect(usedCoupon.computeDiscount(500), 0);
    });
  });

  group('Reminder date calculation', () {
    test('computes days left and snooze offset accurately', () {
      final start = DateTime(2026, 11, 1);
      final rem = ReminderModel(
        id: 'r1',
        type: ReminderType.foodRunOut,
        titleEn: 'Flakes',
        titleAr: 'رقائق',
        isEnabled: true,
        createdAt: start,
        bagGrams: 100,
        dailyGrams: 4.0,
      );

      // 100 / 4 = 25 days total. On day 20 -> 5 days left.
      expect(rem.daysLeftAt(start.add(const Duration(days: 20))), 5);

      final snoozed = rem.copyWith(snoozedDays: 3);
      expect(snoozed.daysLeftAt(start.add(const Duration(days: 20))), 8);
    });
  });

  group('App widget tests', () {
    testWidgets('renders bottom navigation in English and switches to Arabic RTL',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageService(prefs);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [localStorageProvider.overrideWithValue(storage)],
          child: const PetShopApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsWidgets);
      expect(find.text('Shop'), findsWidgets);
      expect(find.text('Rewards'), findsOneWidget);
      expect(find.text('Reminders'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Switch to Arabic RTL via provider
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PetShopApp)),
      );
      await container.read(localeProvider.notifier).setLocale(const Locale('ar'));
      await tester.pumpAndSettle();

      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('المتجر'), findsOneWidget);
    });

    testWidgets('renders mobile pitch frame cleanly on wide desktop viewport',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageService(prefs);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [localStorageProvider.overrideWithValue(storage)],
          child: const PetShopApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsWidgets);
    });

    testWidgets('TrustedVetsScreen renders in English and Arabic RTL',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageService(prefs);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [localStorageProvider.overrideWithValue(storage)],
          child: Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(localeProvider);
              return MaterialApp(
                locale: locale,
                theme: AppTheme.light(locale: locale),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('ar')],
                home: const TrustedVetsScreen(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Trusted Vets'), findsOneWidget);
      expect(find.text('Dr. Karim El-Sayed'), findsOneWidget);
      expect(find.text('Trusted by the shop'), findsNWidgets(4));

      final container = ProviderScope.containerOf(
        tester.element(find.byType(TrustedVetsScreen)),
      );
      await container.read(localeProvider.notifier).setLocale(const Locale('ar'));
      await tester.pumpAndSettle();

      expect(find.text('أطباء بيطريون موثوقون'), findsOneWidget);
      expect(find.text('د. كريم السيد'), findsOneWidget);
      expect(find.text('موثوق من المتجر'), findsNWidgets(4));
    });

    testWidgets('BlogListScreen renders in English and Arabic RTL',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = LocalStorageService(prefs);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [localStorageProvider.overrideWithValue(storage)],
          child: Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(localeProvider);
              return MaterialApp(
                locale: locale,
                theme: AppTheme.light(locale: locale),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('ar')],
                home: const BlogListScreen(),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Care Blog'), findsOneWidget);
      expect(find.text('Cycling Your First Freshwater Tank'), findsOneWidget);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(BlogListScreen)),
      );
      await container.read(localeProvider.notifier).setLocale(const Locale('ar'));
      await tester.pumpAndSettle();

      expect(find.text('مدونة العناية'), findsOneWidget);
      expect(find.text('تجهيز الدورة البيولوجية لأول حوض مياه عذبة'), findsOneWidget);
    });
  });
}
