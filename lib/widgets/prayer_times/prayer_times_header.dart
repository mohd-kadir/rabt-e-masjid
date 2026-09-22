import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/hijri_calendar_data.dart';
import '../../services/hijri_calendar_service.dart';

class PrayerTimesHeader extends StatelessWidget {
  final HijriDate? hijriDate;
  final String masjidName;
  final String location;

  const PrayerTimesHeader({
    super.key,
    this.hijriDate,
    required this.masjidName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hijri = hijriDate ?? HijriCalendarService.convertGregorianToHijri(now);

    final gregorianDate = '${now.day} ${_monthName(now.month)} ${now.year}';
    final dayName = _dayName(now.weekday);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prayer Times',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.calendar_month_rounded, size: 14, color: AppColors.gold),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '${hijri.day} ${hijri.monthName} ${hijri.year} AH  ·  $dayName, $gregorianDate',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.mosque_rounded, size: 14, color: AppColors.gold),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                '$masjidName · $location',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.goldMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _dayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }
}