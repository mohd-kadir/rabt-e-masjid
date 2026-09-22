import 'dart:convert';

/// Type of bookmark.
enum BookmarkType { quranPage, surah, dua, announcement }

/// A single unified bookmark entry.
class Bookmark {
  final String id;
  final BookmarkType type;
  final String title;
  final String? arabicName;
  final String? preview;
  final String? category;
  final int? pageNumber;
  final int? surahNumber;
  final int? ayahNumber;
  final DateTime savedAt;

  const Bookmark({
    required this.id,
    required this.type,
    required this.title,
    this.arabicName,
    this.preview,
    this.category,
    this.pageNumber,
    this.surahNumber,
    this.ayahNumber,
    required this.savedAt,
  });

  /// For Quran bookmarks: "Surah" if opened from surah list, otherwise
  /// "Para". Used as a small tag on the bookmark card.
  String get quranTag {
    if (type != BookmarkType.quranPage) return '';
    return surahNumber != null ? 'Surah' : 'Para';
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.name,
    'title': title,
    'arabicName': arabicName,
    'preview': preview,
    'category': category,
    'pageNumber': pageNumber,
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'savedAt': savedAt.toIso8601String(),
  };

  factory Bookmark.fromMap(Map<String, dynamic> map) => Bookmark(
    id: map['id'] as String,
    type: BookmarkType.values.firstWhere(
          (t) => t.name == map['type'],
      orElse: () => BookmarkType.quranPage,
    ),
    title: map['title'] as String,
    arabicName: map['arabicName'] as String?,
    preview: map['preview'] as String?,
    category: map['category'] as String?,
    pageNumber: map['pageNumber'] as int?,
    surahNumber: map['surahNumber'] as int?,
    ayahNumber: map['ayahNumber'] as int?,
    savedAt: DateTime.parse(map['savedAt'] as String),
  );

  String toJson() => jsonEncode(toMap());

  factory Bookmark.fromJson(String source) =>
      Bookmark.fromMap(jsonDecode(source) as Map<String, dynamic>);
}