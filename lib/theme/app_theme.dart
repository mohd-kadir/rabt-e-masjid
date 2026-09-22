import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Central Material 3 theme for the app. Reused across all screens
/// so the splash screen and the rest of the app stay visually consistent.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreen,
      brightness: Brightness.light,
      primary: AppColors.primaryGreen,
      secondary: AppColors.gold,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryGreenLight,
      brightness: Brightness.dark,
      primary: AppColors.primaryGreenLight,
      secondary: AppColors.goldDarkMode,
      surface: AppColors.cardSurfaceDarkMode,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDarkMode,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimaryDarkMode,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimaryDarkMode,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondaryDarkMode,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cardSurfaceDarkMode,
        foregroundColor: AppColors.textPrimaryDarkMode,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreenLight,
          foregroundColor: AppColors.textPrimaryDarkMode,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  /// Reusable text style for the app name wordmark.
  static TextStyle appNameStyle(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 28,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: AppColors.primaryGreen,
    );
  }

  /// Reusable text style for Arabic script text.
  static TextStyle arabicStyle(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 22,
      fontWeight: FontWeight.w600,
      color: AppColors.goldMuted,
      height: 1.4,
    );
  }

  /// Reusable text style for taglines / captions.
  static TextStyle taglineStyle(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 13,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.8,
      color: AppColors.textSecondary,
    );
  }
}