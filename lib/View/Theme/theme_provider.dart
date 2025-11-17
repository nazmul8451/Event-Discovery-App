import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    print("Theme toggled → Dark mode: $_isDarkMode"); // চেক করার জন্য
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}