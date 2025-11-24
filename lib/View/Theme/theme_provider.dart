// theme_provider.dart (GetStorage version – onek clean)

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider with ChangeNotifier {
  final box = GetStorage();
  bool get isDarkMode => box.read('isDarkMode') ?? false;
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    box.write('isDarkMode', !isDarkMode);
    notifyListeners();
    print("Theme toggled → Dark mode: $isDarkMode");
  }

  void setDarkMode(bool value) {
    box.write('isDarkMode', value);
    notifyListeners();
  }
}