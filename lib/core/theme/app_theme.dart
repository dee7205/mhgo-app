import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Premium Light Theme Palette
  static const Color lightBg = Color(0xFFF9FAFB); // Slate 50
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF2E7D32); // Solar Green (#2E7D32)
  static const Color lightOnPrimary = Colors.white;
  static const Color lightPrimaryContainer = Color(
    0xFFE8F5E9,
  ); // Solar Green Container (Green 50)
  static const Color lightOnPrimaryContainer = Color(0xFF1B5E20); // Green 900
  static const Color lightSecondary = Color(0xFFFFB300); // Amber (#FFB300)
  static const Color lightSecondaryContainer = Color(
    0xFFFFF8E1,
  ); // Amber Container (Amber 50)
  static const Color lightTertiary = Color(
    0xFF2196F3,
  ); // Accent Sky Blue (#2196F3)
  static const Color lightError = Color(0xFFD32F2F); // Error Red (#D32F2F)
  static const Color lightBorder = Color(0xFFE5E7EB); // Slate 200
  static const Color lightTextPrimary = Color(0xFF111827); // Slate 900
  static const Color lightTextSecondary = Color(0xFF4B5563); // Slate 600
  static const Color lightTextMuted = Color(0xFF9CA3AF); // Slate 400

  // Premium Dark Theme Palette
  static const Color darkBg = Color(0xFF070A0F); // Deep Dark Slate/Black
  static const Color darkSurface = Color(0xFF0C1322); // Slate 900
  static const Color darkSurfaceCard = Color(0xFF162032); // Slate 800
  static const Color darkPrimary = Color(
    0xFF4CAF50,
  ); // Solar Green Light (for dark contrast)
  static const Color darkOnPrimary = Colors.white;
  static const Color darkPrimaryContainer = Color(
    0xFF1B5E20,
  ); // Dark Green Container
  static const Color darkOnPrimaryContainer = Color(
    0xFFE8F5E9,
  ); // Light Green Text
  static const Color darkSecondary = Color(0xFFFFCA28); // Amber Light
  static const Color darkSecondaryContainer = Color(
    0xFFFF8F00,
  ); // Dark Amber Container
  static const Color darkTertiary = Color(0xFF64B5F6); // Accent Sky Blue Light
  static const Color darkError = Color(0xFFEF5350); // Error Red Light
  static const Color darkBorder = Color(0xFF334155); // Slate 700
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextMuted = Color(0xFF64748B); // Slate 500

  // Theme Constants
  static const double borderRadiusSmall = 6.0;
  static const double borderRadiusMedium = 10.0;
  static const double borderRadiusLarge = 20.0;
  static const double paddingUnit = 8.0;

  // Custom shadows
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get darkShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        onPrimary: lightOnPrimary,
        primaryContainer: lightPrimaryContainer,
        onPrimaryContainer: lightOnPrimaryContainer,
        secondary: lightSecondary,
        onSecondary: Colors.white,
        secondaryContainer: lightSecondaryContainer,
        tertiary: lightTertiary,
        error: lightError,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        outline: lightBorder,
      ),
      scaffoldBackgroundColor: lightBg,
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: lightBorder, width: 1),
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: lightBorder,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingUnit * 2,
          vertical: paddingUnit * 1.75,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: lightBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: lightPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: lightError, width: 1),
        ),
        labelStyle: const TextStyle(color: lightTextSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: lightTextMuted, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: lightOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingUnit * 2.5,
            vertical: paddingUnit * 1.75,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightTextPrimary,
          side: const BorderSide(color: lightBorder, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingUnit * 2.5,
            vertical: paddingUnit * 1.75,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingUnit * 1.5,
            vertical: paddingUnit * 1.25,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 57,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 45,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          color: lightTextSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          color: lightTextMuted,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          color: lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Inter',
          color: lightTextSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Inter',
          color: lightTextMuted,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        primaryContainer: darkPrimaryContainer,
        onPrimaryContainer: darkOnPrimaryContainer,
        secondary: darkSecondary,
        onSecondary: Colors.white,
        secondaryContainer: darkSecondaryContainer,
        tertiary: darkTertiary,
        error: darkError,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        outline: darkBorder,
      ),
      scaffoldBackgroundColor: darkBg,
      cardTheme: CardThemeData(
        color: darkSurfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: darkBorder, width: 1),
          borderRadius: BorderRadius.circular(borderRadiusLarge),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: darkBorder,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: paddingUnit * 2,
          vertical: paddingUnit * 1.75,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: darkBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: darkPrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: const BorderSide(color: darkError, width: 1),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: darkTextMuted, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingUnit * 2.5,
            vertical: paddingUnit * 1.75,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkTextPrimary,
          side: const BorderSide(color: darkBorder, width: 1),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingUnit * 2.5,
            vertical: paddingUnit * 1.75,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: paddingUnit * 1.5,
            vertical: paddingUnit * 1.25,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusSmall),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 57,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 45,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 32,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          color: darkTextSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          color: darkTextMuted,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          color: darkTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Inter',
          color: darkTextSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Inter',
          color: darkTextMuted,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }
}
