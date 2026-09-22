/// A single Zikr preset (or a custom one entered by the user).
class ZikrPreset {
  final String name;
  final String arabic;
  final bool isCustom;

  const ZikrPreset({
    required this.name,
    required this.arabic,
    this.isCustom = false,
  });
}

/// The standard preset Zikr options shown as selectable chips.
const List<ZikrPreset> zikrPresets = [
  ZikrPreset(name: 'SubhanAllah', arabic: 'سُبْحَانَ اللَّهِ'),
  ZikrPreset(name: 'Alhamdulillah', arabic: 'الْحَمْدُ لِلَّهِ'),
  ZikrPreset(name: 'Allahu Akbar', arabic: 'اللَّهُ أَكْبَرُ'),
  ZikrPreset(name: 'Astaghfirullah', arabic: 'أَسْتَغْفِرُ اللَّهَ'),
];

/// A single Zikr's tally within a day's log.
class ZikrLogEntry {
  final String name;
  final String arabic;
  final int count;

  const ZikrLogEntry({
    required this.name,
    required this.arabic,
    required this.count,
  });
}

/// One day's Tasbeeh log: a date label, daysAgo (0 = today), and the
/// Zikr tallies recorded that day. Built dynamically from saved sessions.
class DailyZikrLog {
  final String dateLabel;
  final int daysAgo;
  final List<ZikrLogEntry> entries;

  const DailyZikrLog({
    required this.dateLabel,
    required this.daysAgo,
    required this.entries,
  });

  int get totalCount => entries.fold(0, (sum, e) => sum + e.count);
}

/// A single completed (or in-progress) Tasbeeh session, for the
/// History sheet/list.
class TasbeehHistoryEntry {
  final String zikrName;
  final String zikrArabic;
  final int count;
  final int target;
  final String dateLabel;

  const TasbeehHistoryEntry({
    required this.zikrName,
    required this.zikrArabic,
    required this.count,
    required this.target,
    required this.dateLabel,
  });
}

/// Helper: build a human-friendly date label like '26 August' or 'Today'.
String buildDayLabel(DateTime date, DateTime today) {
  final diff = DateTime(today.year, today.month, today.day)
      .difference(DateTime(date.year, date.month, date.day))
      .inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return '${date.day} ${months[date.month - 1]}';
}

/// Helper: build a time-based label like 'Today, 6:52 PM'.
String buildDateTimeLabel(DateTime ts, DateTime today) {
  final diff = DateTime(today.year, today.month, today.day)
      .difference(DateTime(ts.year, ts.month, ts.day))
      .inDays;
  final hour12 = ts.hour % 12 == 0 ? 12 : ts.hour % 12;
  final minute = ts.minute.toString().padLeft(2, '0');
  final ampm = ts.hour >= 12 ? 'PM' : 'AM';
  final time = '$hour12:$minute $ampm';
  if (diff == 0) return 'Today, $time';
  if (diff == 1) return 'Yesterday, $time';
  if (diff < 7) return '$diff days ago';
  return buildDayLabel(ts, today);
}