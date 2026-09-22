import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/hijri_calendar_data.dart';

/// "Upcoming Events" section listing the major Islamic occasions with
/// their mock Hijri/Gregorian dates and a days-away countdown.
class UpcomingEventsSection extends StatelessWidget {
  final List<IslamicEvent> events;

  const UpcomingEventsSection({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Events',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
        const SizedBox(height: 10),
        for (int i = 0; i < events.length; i++) ...[
          _EventCard(event: events[i], palette: palette),
          if (i != events.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final IslamicEvent event;
  final AppPalette palette;

  const _EventCard({required this.event, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.goldAccentGradient,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.star_rounded, size: 20, color: AppColors.primaryGreenDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${event.hijriDate.label} · ${formatGregorian(event.gregorianDate)}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: palette.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'In ${event.daysAway}d',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }
}