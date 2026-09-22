import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/hijri_calendar_data.dart';

/// Header for the Hijri Calendar screen: title plus the currently
/// displayed Hijri month/year and Gregorian month/year, with a small
/// crescent moon mark.
class CalendarHeader extends StatelessWidget {
  final HijriDate displayedHijriMonth;
  final DateTime displayedGregorianMonth;

  const CalendarHeader({
    super.key,
    required this.displayedHijriMonth,
    required this.displayedGregorianMonth,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
          child: const Icon(Icons.nightlight_round, size: 24, color: AppColors.goldLight),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Islamic Calendar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const SizedBox(height: 3),
              Text(
                '${displayedHijriMonth.monthName} ${displayedHijriMonth.year} AH  ·  '
                    '${gregorianMonthNames[displayedGregorianMonth.month - 1]} ${displayedGregorianMonth.year}',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.goldMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}