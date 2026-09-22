import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/zikr_data.dart';

/// Simple visual progress section — an animated bar chart of the most
/// recent days' totals, giving an at-a-glance sense of consistency.
class HistoryProgressSection extends StatelessWidget {
  final List<DailyZikrLog> logs;

  const HistoryProgressSection({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    // Most recent 7 days, oldest to newest for a natural left-to-right chart.
    final recent = logs.take(7).toList().reversed.toList();
    final maxCount = recent.isEmpty
        ? 1
        : recent.map((l) => l.totalCount).reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(
              color: palette.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 90,
            child: recent.isEmpty
                ? Center(
              child: Text(
                'No activity yet',
                style: TextStyle(
                    fontSize: 12,
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final log in recent) ...[
                  Expanded(
                    child: _DayBar(
                      value: log.totalCount,
                      maxValue: maxCount,
                      isToday: log.daysAgo == 0,
                      label: log.dateLabel.split(' ').first,
                      palette: palette,
                    ),
                  ),
                  if (log != recent.last) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayBar extends StatelessWidget {
  final int value;
  final int maxValue;
  final bool isToday;
  final String label;
  final AppPalette palette;

  const _DayBar({
    required this.value,
    required this.maxValue,
    required this.isToday,
    required this.label,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = maxValue == 0 ? 0.0 : value / maxValue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: fraction.clamp(0.04, 1.0)),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              builder: (context, animatedFraction, _) {
                return FractionallySizedBox(
                  heightFactor: animatedFraction,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColors.gold
                          : AppColors.primaryGreen.withOpacity(0.55),
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? palette.goldMuted : palette.textSecondary,
          ),
        ),
      ],
    );
  }
}