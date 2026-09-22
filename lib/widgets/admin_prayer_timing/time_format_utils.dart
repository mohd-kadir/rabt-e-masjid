import 'package:flutter/material.dart';

/// Small time formatting/parsing helpers so this screen doesn't need
/// the intl package — consistent with the rest of the app.

/// Parses a "hh:mm AM/PM" string (e.g. "05:12 AM") into a [TimeOfDay].
/// Falls back to midnight if the string is malformed.
TimeOfDay parseTimeLabel(String label) {
  try {
    final parts = label.trim().split(' ');
    final hm = parts[0].split(':');
    int hour = int.parse(hm[0]);
    final minute = int.parse(hm[1]);
    final period = parts.length > 1 ? parts[1].toUpperCase() : 'AM';

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  } catch (_) {
    return const TimeOfDay(hour: 0, minute: 0);
  }
}

/// Formats a [TimeOfDay] as "hh:mm AM/PM".
String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '${hour.toString().padLeft(2, '0')}:$minute $period';
}

/// Formats today's date as "Friday, 15 August 2026" without intl.
String formatTodayLabel(DateTime date) {
  const weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  final weekday = weekdays[date.weekday - 1];
  final month = months[date.month - 1];
  return '$weekday, ${date.day} $month ${date.year}';
}