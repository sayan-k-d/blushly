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
      surface: Colors.grey.shade100,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF713240),
        foregroundColor: Color(0xFFF8BBD0),
      ),
    ),
  );

  // 🌙 DARK THEME
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE91E63),
      primary: const Color(0xFFF48FB1),
      secondary: const Color(0xFFF8BBD0),
      background: const Color(0xFF121212),
      // surface: const Color(0xFF1E1E1E),
      surface: const Color(0xFF1E1E1E),
      onPrimary: Color(0xFF282828),
      onTertiaryFixed: Color(0xFF713240),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A1A1A),
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Color(0xFFF8BBD0)),
      titleTextStyle: TextStyle(
        color: Color(0xFFF8BBD0),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dividerColor: Colors.white12,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF470A1F),
        foregroundColor: Color(0xFFF8BBD0),
      ),
    ),
  );
}
