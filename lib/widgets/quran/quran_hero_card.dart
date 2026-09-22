import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../islamic_pattern_painter.dart';

/// Elegant hero banner inviting the user to read — deep green gradient,
/// gold Quran icon mark, Arabic phrase, and a "Continue Reading" CTA.
class QuranHeroCard extends StatelessWidget {
  final VoidCallback? onContinueReading;

  const QuranHeroCard({super.key, this.onContinueReading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        gradient: AppColors.nextPrayerGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreenDark.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Subtle geometric decoration, gold-on-green.
            Positioned(
              right: -20,
              bottom: -30,
              child: Opacity(
                opacity: 0.5,
                child: SizedBox(
                  width: 180,
                  height: 180,
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
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldLight.withOpacity(0.5), width: 1.2),
                  ),
                  child: const Icon(
                    Icons.auto_stories_rounded,
                    size: 30,
                    color: AppColors.goldLight,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Read the Holy Quran',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'اقرأ القرآن الكريم',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinueReading,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldLight,
                      foregroundColor: AppColors.primaryGreenDark,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continue Reading',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
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