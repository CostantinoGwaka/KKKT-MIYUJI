import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<bool> setStringItem(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> setStringListItem(String key, List value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(key, value);
  }

  static Future<bool> setBoolItem(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }

  static Future<String> getStringItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  static Future<List<String>> getStringListItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? <String>[];
  }

  static Future<bool> getBoolItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<bool> removeItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

}
