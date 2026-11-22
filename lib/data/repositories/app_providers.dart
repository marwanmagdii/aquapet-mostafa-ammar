import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/loyalty_rules.dart';
import '../../core/utils/notification_service.dart';
import '../mock/mock_catalog_data.dart';
import '../models/blog_post.dart';
import '../models/cart_order.dart';
import '../models/coupon.dart';
import '../models/loyalty.dart';
import '../models/product.dart';
import '../models/reminder_tank.dart';
import '../models/user_profile.dart';
import '../models/vet.dart';
import 'local_storage_service.dart';
import 'repositories.dart';

/// Overridden in main() after SharedPreferences.getInstance().
final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('localStorageProvider must be overridden in main');
});

// ── Repository Providers (swap Mock* for real API implementations) ────────

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => MockProductRepository(),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => MockUserRepository(ref.watch(localStorageProvider)),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => MockCartRepository(ref.watch(localStorageProvider)),
);

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>(
  (ref) => MockLoyaltyRepository(ref.watch(localStorageProvider)),
);

final couponRepositoryProvider = Provider<CouponRepository>(
  (ref) => MockCouponRepository(ref.watch(localStorageProvider)),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => MockOrderRepository(ref.watch(localStorageProvider)),
);

final reminderRepositoryProvider = Provider<ReminderRepository>(
  (ref) => MockReminderRepository(ref.watch(localStorageProvider)),
);

final tankRepositoryProvider = Provider<TankRepository>(
  (ref) => MockTankRepository(ref.watch(localStorageProvider)),
);

final vetRepositoryProvider = Provider<VetRepository>(
  (ref) => MockVetRepository(),
);

final vetsProvider = FutureProvider<List<VetModel>>((ref) async {
  return ref.watch(vetRepositoryProvider).getTrustedVets();
});

final blogRepositoryProvider = Provider<BlogRepository>(
  (ref) => MockBlogRepository(),
);

final blogPostsProvider = FutureProvider<List<BlogPost>>((ref) async {
  return ref.watch(blogRepositoryProvider).getPosts();
});

// ── App Settings & Simulated Clock ────────────────────────────────────────

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage)
      : super(
          Locale(
            _storage.getString(LocalStorageService.keyLocale) ?? 'en',
          ),
        );

  final LocalStorageService _storage;

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _storage.setString(
      LocalStorageService.keyLocale,
      locale.languageCode,
    );
  }

  Future<void> toggle() =>
      setLocale(state.languageCode == 'en' ? const Locale('ar') : const Locale('en'));
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(ref.watch(localStorageProvider)),
);

class DarkModeNotifier extends StateNotifier<bool> {
  DarkModeNotifier(this._storage)
      : super(_storage.getBool(LocalStorageService.keyDarkMode));

  final LocalStorageService _storage;

  Future<void> setDark(bool value) async {
    state = value;
    await _storage.setBool(LocalStorageService.keyDarkMode, value);
  }
}

final darkModeProvider = StateNotifierProvider<DarkModeNotifier, bool>(
  (ref) => DarkModeNotifier(ref.watch(localStorageProvider)),
);

class SimulatedDaysNotifier extends StateNotifier<int> {
  SimulatedDaysNotifier(this._storage)
      : super(_storage.getInt(LocalStorageService.keySimulatedDays));

  final LocalStorageService _storage;

  Future<void> advanceDays(int days) async {
    state = state + days;
    await _storage.setInt(LocalStorageService.keySimulatedDays, state);
  }

  Future<void> reset() async {
    state = 0;
    await _storage.setInt(LocalStorageService.keySimulatedDays, 0);
  }
}

final simulatedDaysProvider = StateNotifierProvider<SimulatedDaysNotifier, int>(
  (ref) => SimulatedDaysNotifier(ref.watch(localStorageProvider)),
);

final appNowProvider = Provider<DateTime>((ref) {
  final offset = ref.watch(simulatedDaysProvider);
  return DateTime.now().add(Duration(days: offset));
});

// ── Products ──────────────────────────────────────────────────────────────

final productsProvider = FutureProvider<List<Product>>((ref) async {
  return ref.watch(productRepositoryProvider).getProducts();
});

// ── User Profile & Auth ───────────────────────────────────────────────────

class UserNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  UserNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final UserRepository _repo;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _repo.loadProfile();
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> completeOnboarding() async {
    final current = state.valueOrNull ?? MockCatalogData.initialUser();
    final updated = current.copyWith(isOnboarded: true);
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);
  }

  Future<void> loginWithPhone({
    required String phone,
    String? name,
  }) async {
    final current = state.valueOrNull ?? MockCatalogData.initialUser();
    final isFirstLogin = !current.isLoggedIn;
    final updated = current.copyWith(
      phone: phone,
      name: (name != null && name.trim().isNotEmpty) ? name.trim() : current.name,
      isOnboarded: true,
      isLoggedIn: true,
    );
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);

    if (isFirstLogin) {
      await _ref.read(loyaltyProvider.notifier).addPoints(
            points: LoyaltyRules.welcomeBonusPoints,
            titleEn: 'New Account Welcome Bonus',
            titleAr: 'مكافأة الترحيب بالحساب الجديد',
          );
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    DateTime? birthday,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final shouldGrantProfileBonus =
        !current.profileBonusClaimed && name.trim().isNotEmpty && birthday != null;
    final updated = current.copyWith(
      name: name.trim(),
      phone: phone.trim(),
      birthday: birthday,
      profileBonusClaimed:
          current.profileBonusClaimed || shouldGrantProfileBonus,
    );
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);

    if (shouldGrantProfileBonus) {
      await _ref.read(loyaltyProvider.notifier).addPoints(
            points: LoyaltyRules.profileCompleteBonusPoints,
            titleEn: 'Completed Profile Bonus',
            titleAr: 'مكافأة إكمال الملف الشخصي',
          );
    }
  }

  Future<void> addAddress(UserAddress address) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final list = address.isDefault
        ? current.addresses.map((a) => a.copyWith(isDefault: false)).toList()
        : [...current.addresses];
    list.add(address);
    final updated = current.copyWith(addresses: list);
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);
  }

  Future<void> removeAddress(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final list = current.addresses.where((a) => a.id != id).toList();
    final updated = current.copyWith(addresses: list);
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);
  }

  Future<void> toggleNotifications(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(notificationsEnabled: enabled);
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);
  }

  Future<void> markFirstTankBonus() async {
    final current = state.valueOrNull;
    if (current == null || current.firstTankBonusClaimed) return;
    final updated = current.copyWith(firstTankBonusClaimed: true);
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);
    await _ref.read(loyaltyProvider.notifier).addPoints(
          points: LoyaltyRules.firstTankBonusPoints,
          titleEn: 'First Tank Bonus',
          titleAr: 'مكافأة إضافة أول حوض',
        );
  }

  Future<void> logout() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(isLoggedIn: false);
    state = AsyncValue.data(updated);
    await _repo.saveProfile(updated);
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserProfile>>(
  (ref) => UserNotifier(ref.watch(userRepositoryProvider), ref),
);

// ── Cart & Favorites ──────────────────────────────────────────────────────

class CartNotifier extends StateNotifier<AsyncValue<List<CartItem>>> {
  CartNotifier(this._repo) : super(const AsyncValue.loading()) {
    load();
  }

  final CartRepository _repo;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _repo.loadCart());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addItem(String productId, String variantId, {int qty = 1}) async {
    final list = [...(state.valueOrNull ?? const <CartItem>[])];
    final idx = list.indexWhere(
      (i) => i.productId == productId && i.variantId == variantId,
    );
    if (idx >= 0) {
      list[idx] = list[idx].copyWith(quantity: list[idx].quantity + qty);
    } else {
      list.add(CartItem(productId: productId, variantId: variantId, quantity: qty));
    }
    state = AsyncValue.data(list);
    await _repo.saveCart(list);
  }

  Future<void> updateQuantity(
    String productId,
    String variantId,
    int newQty,
  ) async {
    final list = [...(state.valueOrNull ?? const <CartItem>[])];
    if (newQty <= 0) {
      list.removeWhere(
        (i) => i.productId == productId && i.variantId == variantId,
      );
    } else {
      final idx = list.indexWhere(
        (i) => i.productId == productId && i.variantId == variantId,
      );
      if (idx >= 0) {
        list[idx] = list[idx].copyWith(quantity: newQty);
      }
    }
    state = AsyncValue.data(list);
    await _repo.saveCart(list);
  }

  Future<void> clear() async {
    state = const AsyncValue.data([]);
    await _repo.saveCart(const []);
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<List<CartItem>>>(
  (ref) => CartNotifier(ref.watch(cartRepositoryProvider)),
);

final cartCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider).valueOrNull ?? const [];
  return items.fold<int>(0, (sum, e) => sum + e.quantity);
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier(this._repo) : super(const []) {
    load();
  }

  final CartRepository _repo;

  Future<void> load() async {
    state = await _repo.loadFavorites();
  }

  Future<void> toggle(String productId) async {
    final next = state.contains(productId)
        ? state.where((id) => id != productId).toList()
        : [...state, productId];
    state = next;
    await _repo.saveFavorites(next);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>(
  (ref) => FavoritesNotifier(ref.watch(cartRepositoryProvider)),
);

// ── Loyalty ───────────────────────────────────────────────────────────────

class LoyaltyNotifier extends StateNotifier<AsyncValue<LoyaltyState>> {
  LoyaltyNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final LoyaltyRepository _repo;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final now = _ref.read(appNowProvider);
      state = AsyncValue.data(await _repo.loadLoyalty(now));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addPoints({
    required int points,
    required String titleEn,
    required String titleAr,
  }) async {
    final current = state.valueOrNull;
    if (current == null || points <= 0) return;
    final now = _ref.read(appNowProvider);
    final tx = PointsTransaction(
      id: 'pt_${now.microsecondsSinceEpoch}',
      titleEn: titleEn,
      titleAr: titleAr,
      points: points,
      createdAt: now,
    );
    final updated = current.copyWith(
      balancePoints: current.balancePoints + points,
      lifetimePoints: current.lifetimePoints + points,
      transactions: [tx, ...current.transactions],
    );
    state = AsyncValue.data(updated);
    await _repo.saveLoyalty(updated);
  }

  Future<bool> spendPoints({
    required int points,
    required String titleEn,
    required String titleAr,
  }) async {
    final current = state.valueOrNull;
    if (current == null || points <= 0 || current.balancePoints < points) {
      return false;
    }
    final now = _ref.read(appNowProvider);
    final tx = PointsTransaction(
      id: 'pt_${now.microsecondsSinceEpoch}',
      titleEn: titleEn,
      titleAr: titleAr,
      points: -points,
      createdAt: now,
    );
    final updated = current.copyWith(
      balancePoints: current.balancePoints - points,
      transactions: [tx, ...current.transactions],
    );
    state = AsyncValue.data(updated);
    await _repo.saveLoyalty(updated);
    return true;
  }
}

final loyaltyProvider =
    StateNotifierProvider<LoyaltyNotifier, AsyncValue<LoyaltyState>>(
  (ref) => LoyaltyNotifier(ref.watch(loyaltyRepositoryProvider), ref),
);

// ── Coupons & Stamp Card ──────────────────────────────────────────────────

class CouponsNotifier extends StateNotifier<AsyncValue<List<CouponModel>>> {
  CouponsNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final CouponRepository _repo;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final now = _ref.read(appNowProvider);
      state = AsyncValue.data(await _repo.loadCoupons(now));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addCoupon(CouponModel coupon) async {
    final list = [...(state.valueOrNull ?? const <CouponModel>[])];
    list.insert(0, coupon);
    state = AsyncValue.data(list);
    await _repo.saveCoupons(list);
  }

  Future<void> markUsed(String couponId) async {
    final list = [...(state.valueOrNull ?? const <CouponModel>[])];
    final idx = list.indexWhere((c) => c.id == couponId);
    if (idx < 0) return;
    list[idx] = list[idx].copyWith(status: CouponStatus.used);
    state = AsyncValue.data(list);
    await _repo.saveCoupons(list);
  }

  CouponModel? findAvailableByCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final c in state.valueOrNull ?? const <CouponModel>[]) {
      if (c.code.toUpperCase() == normalized &&
          c.status == CouponStatus.available) {
        return c;
      }
    }
    return null;
  }
}

final couponsProvider =
    StateNotifierProvider<CouponsNotifier, AsyncValue<List<CouponModel>>>(
  (ref) => CouponsNotifier(ref.watch(couponRepositoryProvider), ref),
);

class StampsNotifier extends StateNotifier<int> {
  StampsNotifier(this._repo, this._ref) : super(7) {
    load();
  }

  final CouponRepository _repo;
  final Ref _ref;

  Future<void> load() async {
    state = await _repo.loadStamps();
  }

  Future<bool> addFoodBagStamps(int count) async {
    var next = state + count;
    var unlockedFreeBag = false;
    while (next >= LoyaltyRules.stampsForFreeBag) {
      next -= LoyaltyRules.stampsForFreeBag;
      unlockedFreeBag = true;
      final now = _ref.read(appNowProvider);
      await _ref.read(couponsProvider.notifier).addCoupon(
            CouponModel(
              id: 'cpn_stamp_${now.microsecondsSinceEpoch}',
              code: 'FREEBAG10',
              titleEn: 'Free Fish Food Bag (Stamp Reward)',
              titleAr: 'كيس طعام أسماك مجاني (مكافأة الأختام)',
              conditionEn: 'Unlocked by 10 fish food stamps • Up to 185 EGP',
              conditionAr: 'مكافأة إكمال ١٠ أختام طعام • حتى ١٨٥ ج.م',
              type: CouponType.freeItem,
              value: 185,
              minOrderEgp: 0,
              expiresAt: now.add(const Duration(days: 60)),
              status: CouponStatus.available,
            ),
          );
    }
    state = next;
    await _repo.saveStamps(next);
    return unlockedFreeBag;
  }
}

final stampsProvider = StateNotifierProvider<StampsNotifier, int>(
  (ref) => StampsNotifier(ref.watch(couponRepositoryProvider), ref),
);

// ── Orders ────────────────────────────────────────────────────────────────

class OrdersNotifier extends StateNotifier<AsyncValue<List<OrderModel>>> {
  OrdersNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final OrderRepository _repo;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final now = _ref.read(appNowProvider);
      state = AsyncValue.data(await _repo.loadOrders(now));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> placeOrder(OrderModel order) async {
    final list = [order, ...(state.valueOrNull ?? const <OrderModel>[])];
    state = AsyncValue.data(list);
    await _repo.saveOrders(list);
  }

  Future<void> advanceStatus(String orderId) async {
    final list = [...(state.valueOrNull ?? const <OrderModel>[])];
    final idx = list.indexWhere((o) => o.id == orderId);
    if (idx < 0) return;
    final current = list[idx];
    final nextStatus = switch (current.status) {
      OrderStatus.received => OrderStatus.preparing,
      OrderStatus.preparing => current.fulfillmentType == FulfillmentType.pickup
          ? OrderStatus.readyForPickup
          : OrderStatus.outForDelivery,
      OrderStatus.outForDelivery => OrderStatus.delivered,
      OrderStatus.readyForPickup => OrderStatus.delivered,
      OrderStatus.delivered => OrderStatus.delivered,
    };
    list[idx] = current.copyWith(status: nextStatus);
    state = AsyncValue.data(list);
    await _repo.saveOrders(list);
  }
}

final ordersProvider =
    StateNotifierProvider<OrdersNotifier, AsyncValue<List<OrderModel>>>(
  (ref) => OrdersNotifier(ref.watch(orderRepositoryProvider), ref),
);

// ── Reminders & Tanks ─────────────────────────────────────────────────────

class RemindersNotifier extends StateNotifier<AsyncValue<List<ReminderModel>>> {
  RemindersNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final ReminderRepository _repo;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final now = _ref.read(appNowProvider);
      state = AsyncValue.data(await _repo.loadReminders(now));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addReminder(ReminderModel reminder) async {
    final list = [reminder, ...(state.valueOrNull ?? const <ReminderModel>[])];
    state = AsyncValue.data(list);
    await _repo.saveReminders(list);
    if (reminder.type == ReminderType.foodRunOut) {
      final isAr = _ref.read(localeProvider).languageCode == 'ar';
      await NotificationService.instance.scheduleFoodRunOutNotifications(
        reminder: reminder,
        now: _ref.read(appNowProvider),
        isArabic: isAr,
      );
    }
  }

  Future<void> toggleReminder(String id, bool enabled) async {
    final list = [...(state.valueOrNull ?? const <ReminderModel>[])];
    final idx = list.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    list[idx] = list[idx].copyWith(isEnabled: enabled);
    state = AsyncValue.data(list);
    await _repo.saveReminders(list);
  }

  Future<void> snoozeReminder(String id, {int days = 3}) async {
    final list = [...(state.valueOrNull ?? const <ReminderModel>[])];
    final idx = list.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    list[idx] = list[idx].copyWith(snoozedDays: list[idx].snoozedDays + days);
    state = AsyncValue.data(list);
    await _repo.saveReminders(list);
  }

  Future<void> markDone(String id) async {
    final list = [...(state.valueOrNull ?? const <ReminderModel>[])];
    final idx = list.indexWhere((r) => r.id == id);
    if (idx < 0) return;
    final now = _ref.read(appNowProvider);
    list[idx] = list[idx].copyWith(
      lastCompletedAt: now,
      snoozedDays: 0,
    );
    state = AsyncValue.data(list);
    await _repo.saveReminders(list);
  }

  Future<void> deleteReminder(String id) async {
    final list = (state.valueOrNull ?? const <ReminderModel>[])
        .where((r) => r.id != id)
        .toList();
    state = AsyncValue.data(list);
    await _repo.saveReminders(list);
  }
}

final remindersProvider =
    StateNotifierProvider<RemindersNotifier, AsyncValue<List<ReminderModel>>>(
  (ref) => RemindersNotifier(ref.watch(reminderRepositoryProvider), ref),
);

class TanksNotifier extends StateNotifier<AsyncValue<List<TankModel>>> {
  TanksNotifier(this._repo, this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final TankRepository _repo;
  final Ref _ref;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      state = AsyncValue.data(await _repo.loadTanks());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTank(TankModel tank) async {
    final list = [...(state.valueOrNull ?? const <TankModel>[])];
    list.add(tank);
    state = AsyncValue.data(list);
    await _repo.saveTanks(list);
    await _ref.read(userProvider.notifier).markFirstTankBonus();
  }

  Future<void> removeTank(String id) async {
    final list =
        (state.valueOrNull ?? const <TankModel>[]).where((t) => t.id != id).toList();
    state = AsyncValue.data(list);
    await _repo.saveTanks(list);
  }
}

final tanksProvider =
    StateNotifierProvider<TanksNotifier, AsyncValue<List<TankModel>>>(
  (ref) => TanksNotifier(ref.watch(tankRepositoryProvider), ref),
);
