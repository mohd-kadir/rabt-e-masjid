/// A single Ayah for the Quran Reader — Arabic text, an illustrative
/// English rendering (written for this demo, not quoting any specific
/// published translation), and an optional transliteration.
///
/// The Arabic text is the Quran's own wording (religious scripture, not
/// subject to copyright); the English lines here are simplified/paraphrased
/// for UI demonstration only — swap in a licensed translation source for
/// production use.
class AyahData {
  final int number;
  final String arabic;
  final String translation;
  final String transliteration;

  const AyahData({
    required this.number,
    required this.arabic,
    required this.translation,
    required this.transliteration,
  });
}

/// Sample reader content for Al-Fatihah, used as demo/fallback content
/// for the Quran Reader screen regardless of which surah was tapped.
/// Bismillah is shown as a separate decorative banner (common app
/// convention); the ayahs below begin with "Alhamdu lillahi...".
const List<AyahData> sampleReaderAyahs = [
  AyahData(
    number: 1,
    arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    translation: 'All praise is for Allah, Lord of all the worlds.',
    transliteration: "Alhamdu lillahi rabbil 'alameen",
  ),
  AyahData(
    number: 2,
    arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
    translation: 'The Most Compassionate, Most Merciful.',
    transliteration: 'Ar-Rahmanir-Raheem',
  ),
  AyahData(
    number: 3,
    arabic: 'مَالِكِ يَوْمِ الدِّينِ',
    translation: 'Master of the Day of Judgment.',
    transliteration: 'Maliki yawmid-deen',
  ),
  AyahData(
    number: 4,
    arabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    translation: 'You alone we worship, and You alone we ask for help.',
    transliteration: "Iyyaka na'budu wa iyyaka nasta'een",
  ),
  AyahData(
    number: 5,
    arabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    translation: 'Guide us along the straight path.',
    transliteration: 'Ihdinas-siratal-mustaqeem',
  ),
  AyahData(
    number: 6,
    arabic:
        'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
    translation:
        'The path of those You have blessed — not of those who have earned Your anger, nor of those who have gone astray.',
    transliteration:
        "Siratal-ladhina an'amta 'alayhim ghayril-maghdoobi 'alayhim wa lad-dalleen",
  ),
];

const String bismillahArabic = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
const String bismillahTranslation =
    'In the name of Allah, the Most Compassionate, the Most Merciful.';
