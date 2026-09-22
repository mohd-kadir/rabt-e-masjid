import 'package:hijri/hijri_calendar.dart';

/// Hijri month names (Muharram through Dhul-Hijjah).
const List<String> hijriMonthNames = [
  'Muharram',
  'Safar',
  "Rabi' al-Awwal",
  "Rabi' al-Thani",
  'Jumada al-Awwal',
  'Jumada al-Thani',
  'Rajab',
  "Sha'ban",
  'Ramadan',
  'Shawwal',
  "Dhul-Qa'dah",
  'Dhul-Hijjah',
];

const List<String> gregorianMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> weekdayShortLabels = [
  'S',
  'M',
  'T',
  'W',
  'T',
  'F',
  'S',
];

/// A Hijri calendar date.
class HijriDate {
  final int day;
  final int month; // 1-12
  final int year;

  const HijriDate({
    required this.day,
    required this.month,
    required this.year,
  });

  String get monthName => hijriMonthNames[(month - 1) % 12];

  String get label => '$day $monthName $year AH';
}

/// Convert Gregorian DateTime to Hijri.
extension HijriConversion on DateTime {
  HijriDate toHijri() {
    final hijri = HijriCalendar.fromDate(this);

    return HijriDate(
      day: hijri.hDay,
      month: hijri.hMonth,
      year: hijri.hYear,
    );
  }
}

/// Format Gregorian date.
String formatGregorian(DateTime date) {
  return '${date.day} ${gregorianMonthNames[date.month - 1]} ${date.year}';
}

/// A single upcoming Islamic event.
class IslamicEvent {
  final String name;
  final HijriDate hijriDate;
  final DateTime gregorianDate;
  final int daysAway;

  const IslamicEvent({
    required this.name,
    required this.hijriDate,
    required this.gregorianDate,
    required this.daysAway,
  });
}

/// Upcoming Islamic events.
List<IslamicEvent> getUpcomingIslamicEvents() {
  final now = DateTime.now();
  final currentYear = now.year;

  final events = <IslamicEvent>[
    IslamicEvent(
      name: 'Ramadan',
      gregorianDate: DateTime(currentYear, 3, 1),
      hijriDate: DateTime(currentYear, 3, 1).toHijri(),
      daysAway: DateTime(currentYear, 3, 1).difference(now).inDays,
    ),

    IslamicEvent(
      name: 'Eid-ul-Fitr',
      gregorianDate: DateTime(currentYear, 4, 1),
      hijriDate: DateTime(currentYear, 4, 1).toHijri(),
      daysAway: DateTime(currentYear, 4, 1).difference(now).inDays,
    ),

    IslamicEvent(
      name: 'Eid-ul-Adha',
      gregorianDate: DateTime(currentYear, 7, 1),
      hijriDate: DateTime(currentYear, 7, 1).toHijri(),
      daysAway: DateTime(currentYear, 7, 1).difference(now).inDays,
    ),

    IslamicEvent(
      name: 'Islamic New Year',
      gregorianDate: DateTime(currentYear, 8, 1),
      hijriDate: DateTime(currentYear, 8, 1).toHijri(),
      daysAway: DateTime(currentYear, 8, 1).difference(now).inDays,
    ),

    IslamicEvent(
      name: 'Ashura',
      gregorianDate: DateTime(currentYear, 8, 10),
      hijriDate: DateTime(currentYear, 8, 10).toHijri(),
      daysAway: DateTime(currentYear, 8, 10).difference(now).inDays,
    ),
  ];

  return events
      .where((event) => event.daysAway >= 0)
      .toList()
    ..sort((a, b) => a.daysAway.compareTo(b.daysAway));
}

/// Backward compatibility.
@Deprecated('Use getUpcomingIslamicEvents() instead')
final List<IslamicEvent> upcomingIslamicEvents =
getUpcomingIslamicEvents();