import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _instance;

  static Future<SharedPreferences> get instance async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await instance;
    await prefs.setString(key, value);
  }

  static Future<void> remove(String key) async {
    final prefs = await instance;
    await prefs.remove(key);
  }

  static Future<String?> getString(String key) async {
    final prefs = await instance;
    return prefs.getString(key);
  }

  static Future<void> clearAll() async {
    final prefs = await instance;
    await prefs.clear();
  }
}
