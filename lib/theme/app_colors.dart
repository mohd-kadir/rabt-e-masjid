import 'package:flutter/material.dart';

/// Centralized color palette for Rabt-e-Masjid.
/// Deep Islamic green + muted gold, on a warm off-white base.
class AppColors {
  AppColors._();

  // Base
  static const Color background = Color(0xFFFAF6EF); // warm off-white
  static const Color surface = Color(0xFFFFFFFF);

  // Deep Islamic green
  static const Color primaryGreen = Color(0xFF0B4632);
  static const Color primaryGreenDark = Color(0xFF072E20);
  static const Color primaryGreenLight = Color(0xFF1C6B4C);

  // Muted gold
  static const Color gold = Color(0xFFC9A24B);
  static const Color goldLight = Color(0xFFE1C784);
  static const Color goldMuted = Color(0xFFAD8F51);

  // Supporting neutrals
  static const Color textPrimary = Color(0xFF1F2A24);
  static const Color textSecondary = Color(0xFF5C6B62);
  static const Color divider = Color(0xFFE4DCC8);

  // Pattern / decorative
  static const Color patternLine = Color(0x140B4632); // ~8% opacity green

  // Dashboard surfaces & status accents
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color cardSurfaceAlt = Color(0xFFF3EEE1); // soft gold-tinted card
  static const Color shadowColor = Color(0x1A0B4632); // soft green-tinted shadow
  static const Color success = Color(0xFF2E7D5B);
  static const Color warning = Color(0xFFB0432B); // for "Important" badges
  static const Color iconInactive = Color(0xFFB8AE96);

  static const LinearGradient nextPrayerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryGreenDark],
  );

  static const LinearGradient goldAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, gold],
  );

  static const LinearGradient splashBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFCF9F3),
      Color(0xFFFAF6EF),
      Color(0xFFF6EFDF),
    ],
  );

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryGreenLight, primaryGreen, primaryGreenDark],
  );

  // ---------------------------------------------------------------------
  // Dark mode surfaces
  // ---------------------------------------------------------------------
  static const Color backgroundDarkMode = Color(0xFF0C1712); // deep green-black
  static const Color cardSurfaceDarkMode = Color(0xFF16261F);
  static const Color cardSurfaceAltDarkMode = Color(0xFF1C2E25);
  static const Color textPrimaryDarkMode = Color(0xFFF3EFE3);
  static const Color textSecondaryDarkMode = Color(0xFFAEB8AF);
  static const Color dividerDarkMode = Color(0xFF294438);
  static const Color shadowColorDarkMode = Color(0x40000000);
  static const Color iconInactiveDarkMode = Color(0xFF5A6A5F);
  // Gold reads brighter on dark surfaces for contrast.
  static const Color goldDarkMode = Color(0xFFE0C077);

  static const AppPalette lightPalette = AppPalette(
    background: background,
    cardSurface: cardSurface,
    cardSurfaceAlt: cardSurfaceAlt,
    textPrimary: textPrimary,
    textSecondary: textSecondary,
    divider: divider,
    shadowColor: shadowColor,
    iconInactive: iconInactive,
    gold: gold,
    goldMuted: goldMuted,
  );

  static const AppPalette darkPalette = AppPalette(
    background: backgroundDarkMode,
    cardSurface: cardSurfaceDarkMode,
    cardSurfaceAlt: cardSurfaceAltDarkMode,
    textPrimary: textPrimaryDarkMode,
    textSecondary: textSecondaryDarkMode,
    divider: dividerDarkMode,
    shadowColor: shadowColorDarkMode,
    iconInactive: iconInactiveDarkMode,
    gold: goldDarkMode,
    goldMuted: goldDarkMode,
  );
}

/// A resolved set of surface/text colors for the current brightness.
/// Accent colors (deep green, gold gradients) stay constant across modes —
/// only base surfaces, text, and dividers adapt.
class AppPalette {
  final Color background;
  final Color cardSurface;
  final Color cardSurfaceAlt;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;
  final Color shadowColor;
  final Color iconInactive;
  final Color gold;
  final Color goldMuted;

  const AppPalette({
    required this.background,
    required this.cardSurface,
    required this.cardSurfaceAlt,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
    required this.shadowColor,
    required this.iconInactive,
    required this.gold,
    required this.goldMuted,
  });
}

/// Convenience accessor: `context.palette` resolves the correct
/// light/dark [AppPalette] based on the current [Theme] brightness.
extension AppPaletteContext on BuildContext {
  AppPalette get palette {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark ? AppColors.darkPalette : AppColors.lightPalette;
  }
}