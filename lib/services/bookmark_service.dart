import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark.dart';

/// Local persistence for bookmarks using SharedPreferences.
class BookmarkService {
  static const String _key = 'bookmarks_v1';

  /// Saves a new bookmark. If the same id exists, it's replaced.
  static Future<void> add(Bookmark bookmark) async {
    final all = await getAll();
    all.removeWhere((b) => b.id == bookmark.id);
    all.add(bookmark);
    await _saveAll(all);
  }

  /// Removes a bookmark by id.
  static Future<void> remove(String id) async {
    final all = await getAll();
    all.removeWhere((b) => b.id == id);
    await _saveAll(all);
  }

  /// Toggles a bookmark — adds if not present, removes if present.
  /// Returns true if now bookmarked.
  static Future<bool> toggle(Bookmark bookmark) async {
    final all = await getAll();
    final exists = all.any((b) => b.id == bookmark.id);
    if (exists) {
      all.removeWhere((b) => b.id == bookmark.id);
      await _saveAll(all);
      return false;
    } else {
      all.add(bookmark);
      await _saveAll(all);
      return true;
    }
  }

  /// Returns true if a bookmark with this id exists.
  static Future<bool> isBookmarked(String id) async {
    final all = await getAll();
    return all.any((b) => b.id == id);
  }

  /// All bookmarks, newest first.
  static Future<List<Bookmark>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];
    final list = raw
        .map((s) {
      try {
        return Bookmark.fromJson(s);
      } catch (_) {
        return null;
      }
    })
        .whereType<Bookmark>()
        .toList();
    list.sort((a, b) => b.savedAt.compareTo(a.savedAt));
    return list;
  }

  /// Bookmarks of a given type only.
  static Future<List<Bookmark>> getByType(BookmarkType type) async {
    final all = await getAll();
    return all.where((b) => b.type == type).toList();
  }

  /// Removes all bookmarks.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // ─── internal ───────────────────────────────────────────
  static Future<void> _saveAll(List<Bookmark> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, list.map((b) => b.toJson()).toList());
  }
}