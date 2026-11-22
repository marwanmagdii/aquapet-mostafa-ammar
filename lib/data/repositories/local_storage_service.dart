import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Thin persistence wrapper over SharedPreferences so all mock repositories
/// survive app restarts cleanly.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const String keyLocale = 'aquapet_locale';
  static const String keyDarkMode = 'aquapet_dark_mode';
  static const String keyUser = 'aquapet_user';
  static const String keyCart = 'aquapet_cart';
  static const String keyFavorites = 'aquapet_favorites';
  static const String keyLoyalty = 'aquapet_loyalty';
  static const String keyCoupons = 'aquapet_coupons';
  static const String keyStamps = 'aquapet_stamps';
  static const String keyOrders = 'aquapet_orders';
  static const String keyReminders = 'aquapet_reminders';
  static const String keyTanks = 'aquapet_tanks';
  static const String keySimulatedDays = 'aquapet_simulated_days';

  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  int getInt(String key, {int fallback = 0}) => _prefs.getInt(key) ?? fallback;
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  bool getBool(String key, {bool fallback = false}) =>
      _prefs.getBool(key) ?? fallback;
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  List<String> getStringList(String key) =>
      _prefs.getStringList(key) ?? const [];
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  Map<String, dynamic>? getJsonMap(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> setJsonMap(String key, Map<String, dynamic> map) =>
      _prefs.setString(key, jsonEncode(map));

  List<Map<String, dynamic>>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  Future<bool> setJsonList(String key, List<Map<String, dynamic>> list) =>
      _prefs.setString(key, jsonEncode(list));

  Future<bool> clearAll() => _prefs.clear();
}
