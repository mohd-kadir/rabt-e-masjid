import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ramadan_data.dart';
import '../islamic_pattern_painter.dart';

/// Ramadan Dashboard header: "Ramadan Mubarak 🌙", the Hijri date, and a
/// "Day X of 30" badge, over a deep-green gradient banner with a subtle
/// geometric pattern and a crescent moon mark.
class RamadanHeader extends StatelessWidget {
  const RamadanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        gradient: AppColors.nextPrayerGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primaryGreenDark.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -24,
              top: -24,
              child: Opacity(
                opacity: 0.4,
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: IslamicPatternPainter(progress: 0.35, color: AppColors.goldLight),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldLight.withOpacity(0.5), width: 1.2),
                  ),
                  child: const Icon(Icons.nightlight_round, size: 28, color: AppColors.goldLight),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Ramadan Mubarak 🌙',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  RamadanData.hijriDate,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.85)),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Day ${RamadanData.currentDay} of ${RamadanData.totalDays}',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.goldLight),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}