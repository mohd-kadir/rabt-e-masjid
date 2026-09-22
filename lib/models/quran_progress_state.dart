import 'package:shared_preferences/shared_preferences.dart';
import 'mock_data.dart';

class QuranProgressState {
  static const String _keyLastPage = 'quran_last_page';
  static const String _keyParaNumber = 'quran_para_number';
  static const String _keyParaArabic = 'quran_para_arabic';
  static const String _keyParaName = 'quran_para_name';
  static const String _keyProgress = 'quran_progress';

  static int _cachedPage = 30;
  static int _cachedParaNumber = 2;
  static String _cachedParaArabic = 'سيقول';
  static String _cachedParaName = 'Sayaqool';
  static double _cachedProgress = 0.34;

  // Initialize from SharedPreferences
  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedPage = prefs.getInt(_keyLastPage) ?? 30;
      _cachedParaNumber = prefs.getInt(_keyParaNumber) ?? 2;
      _cachedParaArabic = prefs.getString(_keyParaArabic) ?? 'سيقول';
      _cachedParaName = prefs.getString(_keyParaName) ?? 'Sayaqool';
      _cachedProgress = prefs.getDouble(_keyProgress) ?? 0.34;
    } catch (e) {
      print('Error loading progress: $e');
    }
  }

  static Future<void> saveProgress({
    required int page,
    required int paraNumber,
    required String paraArabicName,
    required String paraName,
    required double progress,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedPage = page;
      _cachedParaNumber = paraNumber;
      _cachedParaArabic = paraArabicName;
      _cachedParaName = paraName;
      _cachedProgress = progress;

      await prefs.setInt(_keyLastPage, page);
      await prefs.setInt(_keyParaNumber, paraNumber);
      await prefs.setString(_keyParaArabic, paraArabicName);
      await prefs.setString(_keyParaName, paraName);
      await prefs.setDouble(_keyProgress, progress);
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  // Get current progress
  static QuranProgress getCurrentProgress() {
    return QuranProgress(
      paraName: _cachedParaName,
      paraArabicName: _cachedParaArabic,
      lastPara: _cachedParaNumber,
      totalPara: 30,
      pageNumber: _cachedPage,
      progress: _cachedProgress,
    );
  }

  static int getLastPage() => _cachedPage;

  // Find Para from page number
  static ParaInfo? getParaFromPage(int page) {
    for (final para in MockData.paras) {
      if (page >= para.startPage && page <= para.endPage) {
        return para;
      }
    }
    return null;
  }
}