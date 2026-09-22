/// App-wide appearance preference.
enum AppThemeMode { light, dark, system }

extension AppThemeModeLabel on AppThemeMode {
  String get label {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System Default';
    }
  }
}

/// Madhab used for Asr calculation timing.
enum Madhab { shafi, hanafi }

extension MadhabLabel on Madhab {
  String get label => this == Madhab.shafi ? "Shafi'i (Standard)" : 'Hanafi';
}

/// Quran reading mode preference.
enum QuranReadingMode { light, dark, sepia }

extension QuranReadingModeLabel on QuranReadingMode {
  String get label {
    switch (this) {
      case QuranReadingMode.light:
        return 'Light';
      case QuranReadingMode.dark:
        return 'Dark';
      case QuranReadingMode.sepia:
        return 'Sepia';
    }
  }
}

/// App display language.
enum AppLanguage { english, urdu, hindi, arabic }

extension AppLanguageLabel on AppLanguage {
  String get label {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.urdu:
        return 'اردو (Urdu)';
      case AppLanguage.hindi:
        return 'हिन्दी (Hindi)';
      case AppLanguage.arabic:
        return 'العربية (Arabic)';
    }
  }
}

/// Available prayer time calculation methods (standard, widely used sets).
const List<String> prayerCalculationMethods = [
  'Muslim World League',
  'Islamic Society of North America (ISNA)',
  'Egyptian General Authority',
  'Umm al-Qura, Makkah',
  'University of Islamic Sciences, Karachi',
];

const String appVersion = '1.0.0 (Build 1)';