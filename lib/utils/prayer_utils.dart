import 'package:flutter/material.dart';

class PrayerUtils {
  static TimeOfDay? parseTime(String timeStr) {
    try {
      final parts = timeStr.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (parts.length > 1) {
        final suffix = parts[1].toUpperCase();
        if (suffix == 'PM' && hour != 12) hour += 12;
        if (suffix == 'AM' && hour == 12) hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  static bool isTimeAfter(TimeOfDay current, TimeOfDay prayer) {
    final currentMinutes = current.hour * 60 + current.minute;
    final prayerMinutes = prayer.hour * 60 + prayer.minute;
    return prayerMinutes > currentMinutes;
  }

  // ✅ Convert 24-hour to 12-hour format with AM/PM
  static String formatTo12Hour(String timeStr) {
    try {
      if (timeStr.contains('AM') || timeStr.contains('PM')) {
        return timeStr;
      }

      final parts = timeStr.split(':');
      if (parts.length < 2) return timeStr;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      String ampm = hour >= 12 ? 'PM' : 'AM';
      int hour12 = hour % 12;
      if (hour12 == 0) hour12 = 12;

      return '$hour12:${minute.toString().padLeft(2, '0')} $ampm';
    } catch (e) {
      return timeStr;
    }
  }

  // ✅ Get current prayer name
  // 🔥 FIX: Sunrise ko Fajr ke baad consider kiya, lekin Dhuhr se pehle
  static String getCurrentPrayerName(Map<String, String>? times) {
    if (times == null) return '--:--';

    final now = TimeOfDay.now();

    // ✅ Fajr ka waqt sunrise tak hai, is liye sunrise ko bhi include kiya
    final prayerOrder = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    String? currentPrayer;

    for (int i = 0; i < prayerOrder.length; i++) {
      final prayer = prayerOrder[i];
      final timeStr = times[prayer];
      if (timeStr == null) continue;

      final prayerTime = parseTime(timeStr);
      if (prayerTime == null) continue;

      if (isTimeAfter(now, prayerTime)) {
        // This is the next prayer
        // Current prayer is the previous one
        currentPrayer = (i > 0) ? prayerOrder[i - 1] : prayerOrder.last;
        break;
      }
    }

    if (currentPrayer == null) {
      currentPrayer = prayerOrder.last; // Isha
    }

    // ✅ Agar Sunrise current prayer hai, to actually Fajr ka waqt hai
    if (currentPrayer == 'Sunrise') {
      currentPrayer = 'Fajr';
    }

    return currentPrayer;
  }

  // ✅ Get current prayer time (start time)
  static String getCurrentPrayerTime(Map<String, String>? times) {
    if (times == null) return '--:--';
    final name = getCurrentPrayerName(times);
    return times[name] ?? '--:--';
  }

  // ✅ Get next prayer time (end time)
  // 🔥 FIX: Fajr ka next prayer Sunrise hai, Dhuhr nahi
  static String getNextPrayerTime(Map<String, String>? times) {
    if (times == null) return '--:--';

    final now = TimeOfDay.now();
    final prayerOrder = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (int i = 0; i < prayerOrder.length; i++) {
      final prayer = prayerOrder[i];
      final timeStr = times[prayer];
      if (timeStr == null) continue;

      final prayerTime = parseTime(timeStr);
      if (prayerTime == null) continue;

      if (isTimeAfter(now, prayerTime)) {
        return timeStr;
      }
    }

    // All prayers passed → return Fajr (next day)
    return times['Fajr'] ?? '--:--';
  }

  // ✅ Get remaining time in current prayer
  // 🔥 FIX: Fajr ke liye sunrise tak ka waqt, baqi ke liye next prayer tak
  static String getRemainingTime(Map<String, String>? times) {
    if (times == null) return '--:--';

    final now = TimeOfDay.now();
    final prayerOrder = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    // Find next prayer
    String? nextPrayer;
    for (int i = 0; i < prayerOrder.length; i++) {
      final prayer = prayerOrder[i];
      final timeStr = times[prayer];
      if (timeStr == null) continue;

      final prayerTime = parseTime(timeStr);
      if (prayerTime == null) continue;

      if (isTimeAfter(now, prayerTime)) {
        nextPrayer = prayer;
        break;
      }
    }

    if (nextPrayer == null) {
      nextPrayer = prayerOrder.first; // Fajr (next day)
    }

    final timeStr = times[nextPrayer];
    if (timeStr == null) return '--:--';

    final prayerTime = parseTime(timeStr);
    if (prayerTime == null) return '--:--';

    final nowMinutes = now.hour * 60 + now.minute;
    int prayerMinutes = prayerTime.hour * 60 + prayerTime.minute;

    int diffMinutes = prayerMinutes - nowMinutes;
    if (diffMinutes < 0) diffMinutes += 24 * 60;

    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m remaining';
    } else {
      return '${minutes}m remaining';
    }
  }

  // ✅ Get progress (0% = almost ended, 100% = just started)
  // 🔥 FIX: Fajr ke liye sunrise ko next prayer consider kiya
  static double getCurrentPrayerProgress(Map<String, String>? times) {
    if (times == null) return 0.0;

    final now = TimeOfDay.now();
    final prayerOrder = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    String? currentPrayer;
    String? nextPrayer;

    for (int i = 0; i < prayerOrder.length; i++) {
      final prayer = prayerOrder[i];
      final timeStr = times[prayer];
      if (timeStr == null) continue;

      final prayerTime = parseTime(timeStr);
      if (prayerTime == null) continue;

      if (isTimeAfter(now, prayerTime)) {
        nextPrayer = prayer;
        currentPrayer = (i > 0) ? prayerOrder[i - 1] : prayerOrder.last;
        break;
      }
    }

    if (nextPrayer == null) {
      currentPrayer = prayerOrder.last;
      nextPrayer = prayerOrder.first;
    }

    // ✅ Agar current prayer Sunrise hai, to actually Fajr hai
    if (currentPrayer == 'Sunrise') {
      currentPrayer = 'Fajr';
    }

    final currentTimeStr = times[currentPrayer!];
    final nextTimeStr = times[nextPrayer!];

    if (currentTimeStr == null || nextTimeStr == null) return 0.0;

    final currentTime = parseTime(currentTimeStr);
    final nextTime = parseTime(nextTimeStr);

    if (currentTime == null || nextTime == null) return 0.0;

    int currentMinutes = currentTime.hour * 60 + currentTime.minute;
    int nextMinutes = nextTime.hour * 60 + nextTime.minute;
    int nowMinutes = now.hour * 60 + now.minute;

    if (nextMinutes <= currentMinutes) {
      nextMinutes += 24 * 60;
    }

    if (nowMinutes < currentMinutes) {
      currentMinutes -= 24 * 60;
    }

    final totalDuration = nextMinutes - currentMinutes;
    final elapsed = nowMinutes - currentMinutes;

    if (totalDuration <= 0) return 0.0;

    // 🔥 REVERSED: 100% = just started, 0% = almost ended
    final progress = 1.0 - (elapsed / totalDuration).clamp(0.0, 1.0);
    return progress;
  }
}