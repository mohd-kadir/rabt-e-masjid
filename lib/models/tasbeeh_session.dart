import 'dart:convert';

/// A single saved Tasbeeh session (partial or completed round).
/// Persisted locally via SharedPreferences as JSON.
class TasbeehSession {
  final String zikrName;
  final String zikrArabic;
  final int count;
  final int target;
  final DateTime timestamp;

  const TasbeehSession({
    required this.zikrName,
    required this.zikrArabic,
    required this.count,
    required this.target,
    required this.timestamp,
  });

  bool get isCompleted => count >= target;

  Map<String, dynamic> toMap() => {
    'zikrName': zikrName,
    'zikrArabic': zikrArabic,
    'count': count,
    'target': target,
    'timestamp': timestamp.toIso8601String(),
  };

  factory TasbeehSession.fromMap(Map<String, dynamic> map) => TasbeehSession(
    zikrName: map['zikrName'] as String,
    zikrArabic: map['zikrArabic'] as String,
    count: map['count'] as int,
    target: map['target'] as int,
    timestamp: DateTime.parse(map['timestamp'] as String),
  );

  String toJson() => jsonEncode(toMap());

  factory TasbeehSession.fromJson(String source) =>
      TasbeehSession.fromMap(jsonDecode(source) as Map<String, dynamic>);
}