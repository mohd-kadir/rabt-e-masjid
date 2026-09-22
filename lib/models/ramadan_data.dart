/// Mock data for the Ramadan Dashboard. UI only — no real date/time or
/// location-based calculation; all values are static mock content.
class RamadanData {
  RamadanData._();

  static const String hijriDate = '12 Ramadan 1448 AH';
  static const int currentDay = 12;
  static const int totalDays = 30;

  static const String sehriTime = '04:20 AM';
  static const String iftarTime = '06:45 PM';
  static const String taraweehTime = '08:45 PM';

  static const String iftarCountdownLabel = '01h 24m';
  // Fraction of the fasting day elapsed (Sehri -> Iftar), for the progress ring.
  static const double iftarCountdownProgress = 0.82;

  static const double daysCompletedFraction = currentDay / totalDays;

  // Quran khatm progress — one Juz per day is the traditional Ramadan pace,
  // so this intentionally mirrors [currentDay].
  static const int juzCompleted = 12;
  static const int juzTotal = 30;

  static const String dailyDuaArabic =
      'اللَّهُمَّ إِنِّي لَكَ صُمْتُ وَبِكَ آمَنْتُ وَعَلَيْكَ تَوَكَّلْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ';
  static const String dailyDuaTransliteration =
      "Allahumma inni laka sumtu, wa bika aamantu, wa 'alayka tawakkaltu, wa 'ala rizqika aftartu";
  static const String dailyDuaTranslation =
      'O Allah, I fasted for You, I believe in You, I put my trust in You, and I break my fast with '
      'Your sustenance.';
  static const String dailyDuaReference = 'Sunan Abi Dawud';
}
