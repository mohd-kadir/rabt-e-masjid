import 'package:hijri/hijri_calendar.dart';
import '../models/hijri_calendar_data.dart';

class HijriCalendarService {
  /// Convert Gregorian date to Hijri date
  ///
  /// 🔥 NOTE: `hijri` package astronomical calculation use karta hai.
  /// Is liye moon sighting ke hisaab se 1 din ka farq ho sakta hai.
  /// `adjustment` parameter se manually adjust kar sakte hain.
  static HijriDate convertGregorianToHijri(
      DateTime gregorianDate, {
        int adjustment = 0, // -1, 0, +1
      }) {
    final hijriDate = HijriCalendar.fromDate(gregorianDate);

    // ✅ Adjustment apply karein
    int adjustedDay = hijriDate.hDay + adjustment;
    int adjustedMonth = hijriDate.hMonth;
    int adjustedYear = hijriDate.hYear;

    // Handle month overflow/underflow
    if (adjustedDay > 30) {
      adjustedDay = 1;
      adjustedMonth += 1;
      if (adjustedMonth > 12) {
        adjustedMonth = 1;
        adjustedYear += 1;
      }
    } else if (adjustedDay < 1) {
      adjustedMonth -= 1;
      if (adjustedMonth < 1) {
        adjustedMonth = 12;
        adjustedYear -= 1;
      }
      adjustedDay = 29; // Previous month ki aakhri tareekh (approx)
    }

    return HijriDate(
      day: adjustedDay,
      month: adjustedMonth,
      year: adjustedYear,
    );
  }

  /// Format Hijri date for display
  static String formatHijriDate(
      DateTime gregorianDate, {
        int adjustment = 0,
      }) {
    final hijri = convertGregorianToHijri(gregorianDate, adjustment: adjustment);
    return '${hijri.day} ${hijri.monthName} ${hijri.year} AH';
  }
}