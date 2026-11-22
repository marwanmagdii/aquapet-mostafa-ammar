import '../mock/blog_posts.dart';
import '../mock/mock_catalog_data.dart';
import '../mock/vets.dart';
import '../models/blog_post.dart';
import '../models/cart_order.dart';
import '../models/coupon.dart';
import '../models/loyalty.dart';
import '../models/product.dart';
import '../models/reminder_tank.dart';
import '../models/user_profile.dart';
import '../models/vet.dart';
import 'local_storage_service.dart';

// ── Repository Interfaces (swap with real API/Firebase later) ─────────────

abstract interface class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product?> getById(String id);
}

abstract interface class UserRepository {
  Future<UserProfile> loadProfile();
  Future<void> saveProfile(UserProfile profile);
}

abstract interface class CartRepository {
  Future<List<CartItem>> loadCart();
  Future<void> saveCart(List<CartItem> items);
  Future<List<String>> loadFavorites();
  Future<void> saveFavorites(List<String> productIds);
}

abstract interface class LoyaltyRepository {
  Future<LoyaltyState> loadLoyalty(DateTime now);
  Future<void> saveLoyalty(LoyaltyState state);
}

abstract interface class CouponRepository {
  Future<List<CouponModel>> loadCoupons(DateTime now);
  Future<void> saveCoupons(List<CouponModel> coupons);
  Future<int> loadStamps();
  Future<void> saveStamps(int count);
}

abstract interface class OrderRepository {
  Future<List<OrderModel>> loadOrders(DateTime now);
  Future<void> saveOrders(List<OrderModel> orders);
}

abstract interface class ReminderRepository {
  Future<List<ReminderModel>> loadReminders(DateTime now);
  Future<void> saveReminders(List<ReminderModel> reminders);
}

abstract interface class TankRepository {
  Future<List<TankModel>> loadTanks();
  Future<void> saveTanks(List<TankModel> tanks);
}

abstract interface class VetRepository {
  Future<List<VetModel>> getTrustedVets();
}

abstract interface class BlogRepository {
  Future<List<BlogPost>> getPosts();
}

// ── Mock Implementations (local device storage) ───────────────────────────

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    return MockCatalogData.products;
  }

  @override
  Future<Product?> getById(String id) async {
    for (final p in MockCatalogData.products) {
      if (p.id == id) return p;
    }
    return null;
  }
}

class MockUserRepository implements UserRepository {
  MockUserRepository(this._storage);
  final LocalStorageService _storage;

  @override
  Future<UserProfile> loadProfile() async {
    final map = _storage.getJsonMap(LocalStorageService.keyUser);
    if (map == null) return MockCatalogData.initialUser();
    return UserProfile.fromJson(map);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _storage.setJsonMap(LocalStorageService.keyUser, profile.toJson());
  }
}

class MockCartRepository implements CartRepository {
  MockCartRepository(this._storage);
  final LocalStorageService _storage;

  @override
  Future<List<CartItem>> loadCart() async {
    final list = _storage.getJsonList(LocalStorageService.keyCart);
    if (list == null) return const [];
    return list.map(CartItem.fromJson).toList();
  }

  @override
  Future<void> saveCart(List<CartItem> items) async {
    await _storage.setJsonList(
      LocalStorageService.keyCart,
      items.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<List<String>> loadFavorites() async =>
      _storage.getStringList(LocalStorageService.keyFavorites);

  @override
  Future<void> saveFavorites(List<String> productIds) async {
    await _storage.setStringList(LocalStorageService.keyFavorites, productIds);
  }
}

class MockLoyaltyRepository implements LoyaltyRepository {
  MockLoyaltyRepository(this._storage);
  final LocalStorageService _storage;

  @override
  Future<LoyaltyState> loadLoyalty(DateTime now) async {
    final map = _storage.getJsonMap(LocalStorageService.keyLoyalty);
    if (map == null) {
      final initial = MockCatalogData.initialLoyalty(now);
      await saveLoyalty(initial);
      return initial;
    }
    return LoyaltyState.fromJson(map);
  }

  @override
  Future<void> saveLoyalty(LoyaltyState state) async {
    await _storage.setJsonMap(LocalStorageService.keyLoyalty, state.toJson());
  }
}

class MockCouponRepository implements CouponRepository {
  MockCouponRepository(this._storage);
  final LocalStorageService _storage;

  @override
  Future<List<CouponModel>> loadCoupons(DateTime now) async {
    final list = _storage.getJsonList(LocalStorageService.keyCoupons);
    if (list == null) {
      final initial = MockCatalogData.initialCoupons(now);
      await saveCoupons(initial);
      return initial;
    }
    return list.map(CouponModel.fromJson).toList();
  }

  @override
  Future<void> saveCoupons(List<CouponModel> coupons) async {
    await _storage.setJsonList(
      LocalStorageService.keyCoupons,
      coupons.map((e) => e.toJson()).toList(),
    );
  }

  @override
  Future<int> loadStamps() async {
    if (_storage.getString(LocalStorageService.keyCoupons) == null) {
      await _storage.setInt(LocalStorageService.keyStamps, 7);
      return 7;
    }
    return _storage.getInt(LocalStorageService.keyStamps, fallback: 7);
  }

  @override
  Future<void> saveStamps(int count) async {
    await _storage.setInt(LocalStorageService.keyStamps, count);
  }
}

class MockOrderRepository implements OrderRepository {
  MockOrderRepository(this._storage);
  final LocalStorageService _storage;

  @override
  Future<List<OrderModel>> loadOrders(DateTime now) async {
    final list = _storage.getJsonList(LocalStorageService.keyOrders);
    if (list == null) {
      final initial = MockCatalogData.initialOrders(now);
      await saveOrders(initial);
      return initial;
    }
    return list.map(OrderModel.fromJson).toList();
  }

  @override
  Future<void> saveOrders(List<OrderModel> orders) async {
    await _storage.setJsonList(
      LocalStorageService.keyOrders,
      orders.map((e) => e.toJson()).toList(),
    );
  }
}

class MockReminderRepository implements ReminderRepository {
  MockReminderRepository(this._storage);
  final LocalStorageService _storage;

  @override
  Future<List<ReminderModel>> loadReminders(DateTime now) async {
    final list = _storage.getJsonList(LocalStorageService.keyReminders);
    if (list == null) {
      final initial = MockCatalogData.initialReminders(now);
      await saveReminders(initial);
      return initial;
    }
    return list.map(ReminderModel.fromJson).toList();
  }

  @override
  Future<void> saveReminders(List<ReminderModel> reminders) async {
    await _storage.setJsonList(
      LocalStorageService.keyReminders,
      reminders.map((e) => e.toJson()).toList(),
    );
  }
}

class MockTankRepository implements TankRepository {
  MockTankRepository(this._storage);
  final LocalStorageService _storage;

  @override
  Future<List<TankModel>> loadTanks() async {
    final list = _storage.getJsonList(LocalStorageService.keyTanks);
    if (list == null) {
      final initial = [MockCatalogData.initialTank];
      await saveTanks(initial);
      return initial;
    }
    return list.map(TankModel.fromJson).toList();
  }

  @override
  Future<void> saveTanks(List<TankModel> tanks) async {
    await _storage.setJsonList(
      LocalStorageService.keyTanks,
      tanks.map((e) => e.toJson()).toList(),
    );
  }
}

class MockVetRepository implements VetRepository {
  @override
  Future<List<VetModel>> getTrustedVets() async {
    return MockVetsData.vets;
  }
}

class MockBlogRepository implements BlogRepository {
  @override
  Future<List<BlogPost>> getPosts() async {
    return MockBlogData.posts;
  }
}
