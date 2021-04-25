import 'package:shared_preferences/shared_preferences.dart';

class SPref{
  SPref._internal();

  static final SPref instance = SPref._internal();

  Future set(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  dynamic get(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  dynamic getOrDefault(String key, Object defaultValue) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) ?? defaultValue;
  }
}