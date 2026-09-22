import 'package:shared_preferences/shared_preferences.dart';

class QuranPdfService {
  QuranPdfService._();

  static const String _lastParaPageKey = 'quran_last_para_page';
  static const String _lastSurahPageKey = 'quran_last_surah_page';
  static const String _lastReadModeKey = 'quran_last_read_mode';

  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // --- PARA ---
  static Future<void> saveLastParaPage(int page) async {
    await _prefs.setInt(_lastParaPageKey, page);
  }

  static Future<int> getLastParaPage() async {
    return await _prefs.getInt(_lastParaPageKey) ?? 1;
  }

  // --- SURAH ---
  static Future<void> saveLastSurahPage(int page) async {
    await _prefs.setInt(_lastSurahPageKey, page);
  }

  static Future<int> getLastSurahPage() async {
    return await _prefs.getInt(_lastSurahPageKey) ?? 1;
  }

  // --- MODE ---
  static Future<void> saveLastReadMode(bool isParaMode) async {
    await _prefs.setBool(_lastReadModeKey, isParaMode);
  }

  static Future<bool> getLastReadMode() async {
    return await _prefs.getBool(_lastReadModeKey) ?? true;
  }

  // --- CONTINUE READING ---
  static Future<int> getContinueReadingPage() async {
    final paraPage = await getLastParaPage();
    if (paraPage > 1) {
      return paraPage;
    }
    return await getLastSurahPage();
  }

  static Future<void> clearAll() async {
    await _prefs.remove(_lastParaPageKey);
    await _prefs.remove(_lastSurahPageKey);
    await _prefs.remove(_lastReadModeKey);
  }
}