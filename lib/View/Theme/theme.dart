import 'package:flutter/material.dart';

class ThemeColor {
  static final ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    // কালার স্কিম
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFCC18CA),
      onPrimary: Colors.white,
      secondary: Color(0xFFCC18CA),
      surface: Colors.white,
      onSurface: Colors.black87,
      surfaceContainerHighest: Color(0xFFF5F5F5),
      outline: Colors.grey,
    ),

    // ?Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(
        fontSize: 13,
        color: Colors.white,
      ),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: Colors.white), // Button text
      labelMedium: TextStyle(color: Color(0xFFCC18CA)), // TextButton
    ),

    // আইকন কালার
    iconTheme: const IconThemeData(color: Colors.black87),
    primaryIconTheme: const IconThemeData(color: Colors.white),

    // Elevated Button (তোমার লগইন বাটন)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCC18CA),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    // TextButton (Forgot Password?, Sign up)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFCC18CA),
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),

    // Input Field
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      hintStyle: TextStyle(color: Colors.grey.shade600),
      labelStyle: const TextStyle(color: Colors.black87),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFCC18CA), width: 1),
      ),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: const Color(0xFF140C22),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFCC18CA),
      onPrimary: Colors.white,
      secondary: Color(0xFFCC18CA),
      surface: Color(0xFF140C22),
      onSurface: Colors.white,
      onSurfaceVariant: Colors.grey, // ← এটাই তোমার গ্রে হিন্ট
      surfaceContainerHighest: Color(0xFF2A1E3F),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      labelLarge: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Color(0xFFCC18CA)),
    ),

    iconTheme: const IconThemeData(color: Colors.white),
    primaryIconTheme: const IconThemeData(color: Colors.white),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCC18CA),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFFCC18CA)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.09),
      hintStyle: TextStyle(color: Colors.white60),
      labelStyle: TextStyle(color: Colors.white70),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFCC18CA), width: 2),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF140C22),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
