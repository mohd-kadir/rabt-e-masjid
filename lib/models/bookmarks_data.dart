import '../models/dua_data.dart';
import '../models/announcement_data.dart';

/// A bookmarked Ayah within a Surah.
class QuranBookmark {
  final String surahName;
  final String surahArabicName;
  final int ayahNumber;
  final String arabicPreview;
  final int pageNumber;

  const QuranBookmark({
    required this.surahName,
    required this.surahArabicName,
    required this.ayahNumber,
    required this.arabicPreview,
    required this.pageNumber,
  });
}

/// A bookmarked Dua.
class DuaBookmark {
  final String title;
  final String arabicPreview;
  final String category;

  const DuaBookmark({required this.title, required this.arabicPreview, required this.category});
}

/// A bookmarked Announcement.
class AnnouncementBookmark {
  final String title;
  final String dateLabel;

  const AnnouncementBookmark({required this.title, required this.dateLabel});
}

/// Mock Quran bookmarks — Arabic text taken from well-known, unmistakably
/// accurate verses (the opening of Al-Fatihah's fifth ayah, the opening of
/// Ayat al-Kursi, and the opening of Al-Ikhlas) rather than arbitrary ayahs.
const List<QuranBookmark> mockQuranBookmarks = [
  QuranBookmark(
    surahName: 'Al-Fatihah',
    surahArabicName: 'الفاتحة',
    ayahNumber: 5,
    arabicPreview: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    pageNumber: 1,
  ),
  QuranBookmark(
    surahName: 'Al-Baqarah',
    surahArabicName: 'البقرة',
    ayahNumber: 255,
    arabicPreview: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
    pageNumber: 42,
  ),
  QuranBookmark(
    surahName: 'Al-Ikhlas',
    surahArabicName: 'الإخلاص',
    ayahNumber: 1,
    arabicPreview: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
    pageNumber: 604,
  ),
];

/// Mock Dua bookmarks, built from the app's existing favorited/full duas
/// so the Arabic text stays consistent with what's shown elsewhere.

/// Mock Announcement bookmarks, drawn from the app's existing announcements.
final List<AnnouncementBookmark> mockAnnouncementBookmarks = mockAnnouncements
    .where((a) => a.isImportant)
    .map((a) => AnnouncementBookmark(title: a.title, dateLabel: a.dateLabel))
    .toList();