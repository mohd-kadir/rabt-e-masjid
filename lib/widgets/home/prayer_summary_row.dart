import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_data_provider.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';
import '../../utils/prayer_utils.dart';

/// Horizontal row of 5 compact prayer cards (Fajr..Isha).
/// The CURRENT prayer is visually highlighted.
class PrayerSummaryRow extends StatelessWidget {
  const PrayerSummaryRow({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppDataProvider>(context);
    final times = appData.prayerTimes;

    final prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final icons = [
      Icons.nights_stay_outlined,
      Icons.wb_sunny_outlined,
      Icons.wb_twilight_outlined,
      Icons.dark_mode_outlined,
      Icons.bedtime_outlined,
    ];

    // ✅ Get current prayer
    final currentPrayerName = PrayerUtils.getCurrentPrayerName(times);

    final prayers = List.generate(5, (index) {
      final name = prayerNames[index];
      final prayerTime = times != null
          ? times[name] ?? '--:--'
          : MockData.prayers[index].azanTime;
      final isCurrent = name == currentPrayerName;

      return PrayerTime(
        name: name,
        icon: icons[index],
        time: prayerTime,
        isCurrent: isCurrent,
      );
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final cardWidth = (constraints.maxWidth - gap * 4) / 5;

        return Row(
          children: [
            for (int i = 0; i < prayers.length; i++) ...[
              SizedBox(
                width: cardWidth,
                child: _PrayerMiniCard(prayer: prayers[i]),
              ),
              if (i != prayers.length - 1) const SizedBox(width: gap),
            ],
          ],
        );
      },
    );
  }
}

class _PrayerMiniCard extends StatelessWidget {
  final PrayerTime prayer;
  const _PrayerMiniCard({required this.prayer});

  @override
  Widget build(BuildContext context) {
    final bool highlighted = prayer.isCurrent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryGreen : AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted ? AppColors.primaryGreen : AppColors.divider,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: highlighted ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            prayer.icon,
            size: 20,
            color: highlighted ? AppColors.goldLight : AppColors.primaryGreen,
          ),
          const SizedBox(height: 6),
          Text(
            prayer.name,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: highlighted ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            PrayerUtils.formatTo12Hour(prayer.time),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: highlighted
                  ? AppColors.goldLight
                  : AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class PrayerTime {
  final String name;
  final IconData icon;
  final String time;
  final bool isCurrent;

  const PrayerTime({
    required this.name,
    required this.icon,
    required this.time,
    this.isCurrent = false,
  });
}