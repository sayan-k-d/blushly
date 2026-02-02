import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      primary: const Color(0xFFE91E63),
      secondary: const Color(0xFFF8BBD0),
      // surface: const Color(0xFFFFF5F7),
      background: const Color(0xFFFFF5F7),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFF5F7),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFFFFEBEE), // soft blush pink
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(
        color: Color(0xFFC2185B), // dark pink icons
      ),
      titleTextStyle: const TextStyle(
        color: Color(0xFFC2185B),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}
