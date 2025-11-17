import 'package:flutter/material.dart';

class ThemeColor {
  static final ThemeData lightMode = ThemeData(
    brightness: Brightness.light,                    // এটা মাস্ট
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Color(0xFFCC18CA),
      onBackground: Colors.black,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFFCC18CA),
      elevation: 0,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFFF5F5F5),
      filled: true,
    ),
  );

  static final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,                     // এটাও মাস্ট
    scaffoldBackgroundColor: Color(0xFF140C22),
    colorScheme: const ColorScheme.dark(
      background: Color(0xFF140C22),
      primary: Color(0xFFCC18CA),
      onBackground: Colors.white,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF140C22),
      foregroundColor: Color(0xFFCC18CA),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF2A1E3F),
      filled: true,
    ),
  );
}