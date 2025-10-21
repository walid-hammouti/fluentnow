import 'package:shared_preferences/shared_preferences.dart';

class CacheData {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> initializeCache() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Generic setter with type checking
  static Future<bool> setData({
    required String key,
    required dynamic value,
  }) async {
    await _ensureInitialized();
    if (value is int) return _prefs!.setInt(key, value);
    if (value is bool) return _prefs!.setBool(key, value);
    if (value is String) return _prefs!.setString(key, value);
    if (value is double) return _prefs!.setDouble(key, value);
    if (value is List<String>) return _prefs!.setStringList(key, value);
    throw Exception("Unsupported type: ${value.runtimeType}");
  }

  // Type-safe getters with default values
  static bool getBool(String key, [bool defaultValue = false]) {
    _ensureInitializedSync();
    return _prefs!.getBool(key) ?? defaultValue;
  }

  static int getInt(String key, [int defaultValue = 0]) {
    _ensureInitializedSync();
    return _prefs!.getInt(key) ?? defaultValue;
  }

  static double getDouble(String key, [double defaultValue = 0.0]) {
    _ensureInitializedSync();
    return _prefs!.getDouble(key) ?? defaultValue;
  }

  static String getString(String key, [String defaultValue = '']) {
    _ensureInitializedSync();
    return _prefs!.getString(key) ?? defaultValue;
  }

  static List<String> getStringList(
    String key, [
    List<String> defaultValue = const [],
  ]) {
    _ensureInitializedSync();
    return _prefs!.getStringList(key) ?? defaultValue;
  }

  // Generic getter (less type-safe)
  static dynamic getData({required String key}) {
    _ensureInitializedSync();
    return _prefs!.get(key);
  }

  // Removal methods
  static Future<bool> deleteItem(String key) async {
    await _ensureInitialized();
    return await _prefs!.remove(key);
  }

  static Future<bool> clearAll() async {
    await _ensureInitialized();
    return await _prefs!.clear();
  }

  // Check if key exists
  static bool containsKey(String key) {
    _ensureInitializedSync();
    return _prefs!.containsKey(key);
  }

  // Private initialization check methods
  static Future<void> _ensureInitialized() async {
    if (_prefs == null) {
      await initializeCache();
    }
  }

  static void _ensureInitializedSync() {
    if (_prefs == null) {
      throw Exception(
        "SharedPreferences not initialized. Call initializeCache() first.",
      );
    }
  }
}
