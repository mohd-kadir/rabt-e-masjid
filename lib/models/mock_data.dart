import 'package:flutter/material.dart';

/// A single daily prayer with its azan (call) and jamaat (congregation) times.
class PrayerTime {
  final String name;
  final IconData icon;
  final String azanTime;
  final String jamaatTime;
  final bool isNext;

  const PrayerTime({
    required this.name,
    required this.icon,
    required this.azanTime,
    required this.jamaatTime,
    this.isNext = false,
  });
}

/// A mosque announcement / notice board entry.
class Announcement {
  final String title;
  final String description;
  final String date;
  final bool isImportant;

  const Announcement({
    required this.title,
    required this.description,
    required this.date,
    this.isImportant = false,
  });
}

/// A single daily prayer for the detailed Prayer Times screen
class PrayerEntry {
  final String name;
  final IconData icon;
  final String azanTime;
  final String jamaatTime;
  final bool isCurrent;

  const PrayerEntry({
    required this.name,
    required this.icon,
    required this.azanTime,
    required this.jamaatTime,
    this.isCurrent = false,
  });
}

/// Jumu'ah (Friday prayer) khutbah and salah timing.
class JumuahInfo {
  final String khutbahTime;
  final String salahTime;

  const JumuahInfo({required this.khutbahTime, required this.salahTime});
}

/// A single Para/Juz entry for the Quran "Read by Para" list.
class ParaInfo {
  final int number;
  final String arabicName;
  final String paraName;
  final int startPage;
  final int endPage;

  const ParaInfo({
    required this.number,
    required this.arabicName,
    required this.paraName,
    required this.startPage,
    required this.endPage,
  });

  String get pageRangeLabel => 'Pages $startPage-$endPage';
  String get label => 'Para $number';
}

/// Mock reading progress for the "Continue Reading" card on the Quran screen.
class QuranProgress {
  final String paraName;
  final String paraArabicName;
  final int lastPara;
  final int totalPara;
  final int pageNumber;
  final double progress;

  const QuranProgress({
    required this.paraName,
    required this.paraArabicName,
    required this.lastPara,
    required this.totalPara,
    required this.pageNumber,
    required this.progress,
  });
}

/// A quick-action shortcut tile.
class QuickAction {
  final String label;
  final IconData icon;

  const QuickAction({required this.label, required this.icon});
}

/// Centralized mock dataset for the Home Dashboard.
class MockData {
  MockData._();

  static const String userName = 'Brother Ahmed';
  static const String masjidName = 'Masjid Al-Noor';
  static const String locationLabel = 'Sector G-9, Islamabad';

  static const String hijriDate = '12 Safar 1448 AH';
  static const String gregorianDate = 'Friday, 15 August 2026';

  static const String nextPrayerName = 'Maghrib';
  static const String nextPrayerTime = '06:42 PM';
  static const String nextPrayerCountdown = '01h 24m remaining';
  static const double nextPrayerProgress = 0.62;

  static String greetingForMockHour(int hour) {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 20) return 'Good Evening';
    return 'Good Night';
  }

  static const List<PrayerTime> prayers = [
    PrayerTime(
      name: 'Fajr',
      icon: Icons.nights_stay_outlined,
      azanTime: '05:12 AM',
      jamaatTime: '05:30 AM',
    ),
    PrayerTime(
      name: 'Dhuhr',
      icon: Icons.wb_sunny_outlined,
      azanTime: '01:15 PM',
      jamaatTime: '01:30 PM',
    ),
    PrayerTime(
      name: 'Asr',
      icon: Icons.wb_twilight_outlined,
      azanTime: '04:45 PM',
      jamaatTime: '05:00 PM',
    ),
    PrayerTime(
      name: 'Maghrib',
      icon: Icons.dark_mode_outlined,
      azanTime: '06:42 PM',
      jamaatTime: '06:47 PM',
      isNext: true,
    ),
    PrayerTime(
      name: 'Isha',
      icon: Icons.bedtime_outlined,
      azanTime: '08:05 PM',
      jamaatTime: '08:20 PM',
    ),
  ];

  static const List<Announcement> announcements = [
    Announcement(
      title: 'Jumma Khutbah Topic: Patience in Trials',
      description:
      'Join us this Friday as Imam Sahib discusses the virtue of sabr and its role in strengthening faith.',
      date: 'Today',
      isImportant: true,
    ),
    Announcement(
      title: 'Weekend Quran Tafseer Circle',
      description:
      'A weekly gathering after Asr for reflection on Surah Al-Kahf. Open to brothers and sisters.',
      date: '2 days ago',
    ),
  ];

  static const List<QuickAction> quickActions = [
    QuickAction(label: 'Quran', icon: Icons.menu_book_outlined),
    QuickAction(label: 'Tasbeeh', icon: Icons.fingerprint),
    QuickAction(label: 'Dua & Azkar', icon: Icons.auto_stories_outlined),
    QuickAction(label: 'Qibla', icon: Icons.explore_outlined),
    QuickAction(label: 'Hijri Calendar', icon: Icons.calendar_month_outlined),
    QuickAction(label: 'Masjid Info', icon: Icons.mosque_outlined),
  ];

  // --- Prayer Times screen ---------------------------------------------

  static const String sunriseTime = '05:55 AM';

  static const List<PrayerEntry> detailedPrayers = [
    PrayerEntry(
      name: 'Fajr',
      icon: Icons.nights_stay_outlined,
      azanTime: '04:38 AM',
      jamaatTime: '05:15 AM',
      isCurrent: false,
    ),
    PrayerEntry(
      name: 'Dhuhr',
      icon: Icons.wb_sunny_outlined,
      azanTime: '12:28 PM',
      jamaatTime: '01:15 PM',
      isCurrent: false,
    ),
    PrayerEntry(
      name: 'Asr',
      icon: Icons.wb_twilight_outlined,
      azanTime: '04:02 PM',
      jamaatTime: '04:30 PM',
      isCurrent: false,
    ),
    PrayerEntry(
      name: 'Maghrib',
      icon: Icons.dark_mode_outlined,
      azanTime: '06:42 PM',
      jamaatTime: '06:50 PM',
      isCurrent: true,
    ),
    PrayerEntry(
      name: 'Isha',
      icon: Icons.bedtime_outlined,
      azanTime: '08:05 PM',
      jamaatTime: '08:30 PM',
      isCurrent: false,
    ),
  ];

  static const JumuahInfo jumuah = JumuahInfo(
    khutbahTime: '01:15 PM',
    salahTime: '01:35 PM',
  );

  // --- Quran screen -------------------------------------------------------

  static const QuranProgress quranProgress = QuranProgress(
    paraName: 'Sayaqool',
    paraArabicName: 'سيقول',
    lastPara: 2,
    totalPara: 30,
    pageNumber: 30,
    progress: 0.34,
  );

  static const List<ParaInfo> paras = [
    ParaInfo(
      number: 1,
      arabicName: 'الم',
      paraName: 'Alif-Lam-Meem',
      startPage: 2,
      endPage: 28,
    ),
    ParaInfo(
      number: 2,
      arabicName: 'سيقول',
      paraName: 'Sayaqool',
      startPage: 29,
      endPage: 56,
    ),
    ParaInfo(
      number: 3,
      arabicName: 'تلك الرسل',
      paraName: 'Tilka-Rasool',
      startPage: 57,
      endPage: 84,
    ),
    ParaInfo(
      number: 4,
      arabicName: 'لن تنالوا',
      paraName: "Lan-Tana_Loo",
      startPage: 85,
      endPage: 112,
    ),
    ParaInfo(
      number: 5,
      arabicName: 'والمحصنات',
      paraName: 'Wal-Mohsanat',
      startPage: 113,
      endPage: 140,
    ),
    ParaInfo(
      number: 6,
      arabicName: 'لا يحب الله',
      paraName: 'La-Yuhibbullah',
      startPage: 141,
      endPage: 168,
    ),
    ParaInfo(
      number: 7,
      arabicName: 'وإذا سمعوا',
      paraName: "Wa-Iza-Samiu",
      startPage: 169,
      endPage: 196,
    ),
    ParaInfo(
      number: 8,
      arabicName: 'ولو أننا',
      paraName: "Wa-lau-Annana",
      startPage: 197,
      endPage: 224,
    ),
    ParaInfo(
      number: 9,
      arabicName: 'قال الملأ',
      paraName: "Qalal-Malao",
      startPage: 225,
      endPage: 252,
    ),
    ParaInfo(
      number: 10,
      arabicName: 'واعلموا',
      paraName: 'Wa-Alamu',
      startPage: 253,
      endPage: 280,
    ),
    ParaInfo(
      number: 11,
      arabicName: 'يعتذرون',
      paraName: 'Ya-Tazeroon',
      startPage: 281,
      endPage: 308,
    ),
    ParaInfo(
      number: 12,
      arabicName: 'وما من دابة',
      paraName: 'Wa-Mamin-Dabbah',
      startPage: 309,
      endPage: 336,
    ),
    ParaInfo(
      number: 13,
      arabicName: 'وما أبرئ',
      paraName: 'Wa-Ma-Ubarriu',
      startPage: 337,
      endPage: 364,
    ),
    ParaInfo(
      number: 14,
      arabicName: 'ربما',
      paraName: 'Rubama',
      startPage: 365,
      endPage: 392,
    ),
    ParaInfo(
      number: 15,
      arabicName: 'سبحان الذي',
      paraName: 'Subhanallazi',
      startPage: 393,
      endPage: 420,
    ),
    ParaInfo(
      number: 16,
      arabicName: 'قال ألم',
      paraName: 'Qala-Alam',
      startPage: 421,
      endPage: 448,
    ),
    ParaInfo(
      number: 17,
      arabicName: 'اقترب',
      paraName: 'Iqtaraba',
      startPage: 449,
      endPage: 476,
    ),
    ParaInfo(
      number: 18,
      arabicName: 'قد أفلح',
      paraName: "Qadd-Aflaha",
      startPage: 477,
      endPage: 504,
    ),
    ParaInfo(
      number: 19,
      arabicName: 'وقال الذين',
      paraName: 'Wa-Qalallazina',
      startPage: 505,
      endPage: 532,
    ),
    ParaInfo(
      number: 20,
      arabicName: 'أمن خلق',
      paraName: 'Aman-Khalaq',
      startPage: 533,
      endPage: 558,
    ),
    ParaInfo(
      number: 21,
      arabicName: 'اتل ما أوحي',
      paraName: 'Utlu-Ma-Oohi',
      startPage: 559,
      endPage: 586,
    ),
    ParaInfo(
      number: 22,
      arabicName: 'ومن يقنت',
      paraName: 'Wa-Manyaqnut',
      startPage: 587,
      endPage: 612,
    ),
    ParaInfo(
      number: 23,
      arabicName: 'وما لي',
      paraName: 'Wa-Mali',
      startPage: 613,
      endPage: 640,
    ),
    ParaInfo(
      number: 24,
      arabicName: 'فمن أظلم',
      paraName: 'Faman-Azlam',
      startPage: 641,
      endPage: 666,
    ),
    ParaInfo(
      number: 25,
      arabicName: 'إليه يرد',
      paraName: 'Ilahi-Yuraddu',
      startPage: 667,
      endPage: 696,
    ),
    ParaInfo(
      number: 26,
      arabicName: 'حم',
      paraName: 'Ha-meem',
      startPage: 697,
      endPage: 726,
    ),
    ParaInfo(
      number: 27,
      arabicName: 'قال فما خطبكم',
      paraName: 'Qala-Fama-Khatbukum',
      startPage: 727,
      endPage: 756,
    ),
    ParaInfo(
      number: 28,
      arabicName: "قد سمع الله",
      paraName: 'Qadd-Sami-Allah',
      startPage: 757,
      endPage: 786,
    ),
    ParaInfo(
      number: 29,
      arabicName: 'تبارك الذي',
      paraName: 'Tabarakallazi',
      startPage: 787,
      endPage: 818,
    ),
    ParaInfo(
      number: 30,
      arabicName: 'عم يتساءلون',
      paraName: 'Amma',
      startPage: 819,
      endPage: 848,
    ),
  ];
}