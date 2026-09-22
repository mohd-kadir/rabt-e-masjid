import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ramadan_data.dart';

/// "12 / 30 Days Completed" progress card with an animated bar.
class RamadanProgressCard extends StatelessWidget {
  const RamadanProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(18),
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
              Text(
                '${RamadanData.currentDay} / ${RamadanData.totalDays} Days Completed',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const Spacer(),
              Text(
                '${(RamadanData.daysCompletedFraction * 100).round()}%',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: RamadanData.daysCompletedFraction),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: palette.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}