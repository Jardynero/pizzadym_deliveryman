import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockLocalData extends ChangeNotifier {
  static late SharedPreferences _prefs;

  ThemeMode themeMode = getBoolData('dark_theme') == false
      ? ThemeMode.light
      : getBoolData('dark_theme') == true
          ? ThemeMode.dark
          : ThemeMode.light;

  ThemeMode get currentThemeMode => themeMode;

  void changeThemeMode() {
    if (getBoolData("dark_theme") == true) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static saveBoolData(key, value) async {
    await _prefs.setBool(key, value);
  }

  static bool? getBoolData(key) => _prefs.getBool(key);
}