import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tasbeeh_session.dart';

/// Local persistence for Tasbeeh sessions using SharedPreferences.
/// Stores a JSON-encoded list of TasbeehSession under one key, plus
/// a single "in-progress" session so a running count survives screen
/// changes / app backgrounding.
class TasbeehStorageService {
  static const String _key = 'tasbeeh_sessions_v1';
  static const String _inProgressKey = 'tasbeeh_in_progress_v1';

  /// Appends a new session to storage. Skips if count <= 0.
  static Future<void> saveSession(TasbeehSession session) async {
    if (session.count <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? <String>[];
    existing.add(session.toJson());
    await prefs.setStringList(_key, existing);
  }

  /// Returns all saved sessions sorted newest first.
  static Future<List<TasbeehSession>> getAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];
    final sessions = raw
        .map((s) {
      try {
        return TasbeehSession.fromJson(s);
      } catch (_) {
        return null;
      }
    })
        .whereType<TasbeehSession>()
        .toList();
    sessions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sessions;
  }

  /// Returns sessions within the last [days] days (0 = today only).
  static Future<List<TasbeehSession>> getSessionsWithinDays(int days) async {
    final all = await getAllSessions();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return all.where((s) {
      final d = DateTime(s.timestamp.year, s.timestamp.month, s.timestamp.day);
      final diff = today.difference(d).inDays;
      return diff >= 0 && diff <= days;
    }).toList();
  }

  /// Clears all saved history (does NOT clear in-progress session).
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  // ─────────────────────────────────────────────────────────────
  // In-progress session (the currently running count)
  // ─────────────────────────────────────────────────────────────

  /// Saves the currently running count so it survives navigation.
  static Future<void> saveInProgress(TasbeehSession session) async {
    final prefs = await SharedPreferences.getInstance();
    if (session.count <= 0) {
      await prefs.remove(_inProgressKey);
      return;
    }
    await prefs.setString(_inProgressKey, session.toJson());
  }

  /// Loads the in-progress session, or null if none.
  static Future<TasbeehSession?> loadInProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_inProgressKey);
    if (raw == null) return null;
    try {
      return TasbeehSession.fromJson(raw);
    } catch (_) {
      return null;
    }
  }

  /// Clears the in-progress session (e.g. after it's moved to history).
  static Future<void> clearInProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_inProgressKey);
  }
}

/// Returns true if two DateTime values fall on the same calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;