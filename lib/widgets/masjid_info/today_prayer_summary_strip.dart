import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';

/// Compact "Today's Prayer" summary strip shown at the bottom of the
/// Masjid Information screen — reuses the same prayer mock data as the
/// dashboard so times stay consistent across the app.
class TodayPrayerSummaryStrip extends StatelessWidget {
  const TodayPrayerSummaryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.today_rounded, size: 15, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(
                "Today's Prayer Summary",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 0; i < MockData.prayers.length; i++) ...[
                Expanded(child: _PrayerChip(prayer: MockData.prayers[i], palette: palette)),
                if (i != MockData.prayers.length - 1) const SizedBox(width: 6),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerChip extends StatelessWidget {
  final PrayerTime prayer;
  final AppPalette palette;

  const _PrayerChip({required this.prayer, required this.palette});

  @override
  Widget build(BuildContext context) {
    final highlighted = prayer.isNext;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryGreen : palette.cardSurfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            prayer.name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: highlighted ? Colors.white : palette.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            prayer.jamaatTime,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: highlighted ? AppColors.goldLight : palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}