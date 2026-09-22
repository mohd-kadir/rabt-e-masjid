import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';
import '../islamic_pattern_painter.dart';

/// Hero section: a photo-placeholder banner (deep green gradient with a
/// subtle geometric pattern, since no real image asset exists in this
/// UI-only build), the masjid's logo mark overlapping the banner's
/// bottom edge, its name, and location.
class MasjidHero extends StatelessWidget {
  const MasjidHero({super.key});

  static const double _logoSize = 68;
  static const double _overlap = 34;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Photo placeholder banner.
            Container(
              width: double.infinity,
              height: 170,
              decoration: BoxDecoration(
                gradient: AppColors.nextPrayerGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.35,
                      child: SizedBox.expand(
                        child: CustomPaint(
                          painter: IslamicPatternPainter(progress: 0.4, color: AppColors.goldLight),
                        ),
                      ),
                    ),
                    Icon(Icons.image_outlined, size: 40, color: Colors.white.withOpacity(0.55)),
                    Positioned(
                      bottom: 10,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Photo placeholder',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Logo mark, overlapping the banner's bottom edge.
            Positioned(
              top: 170 - _overlap,
              child: Container(
                width: _logoSize,
                height: _logoSize,
                decoration: BoxDecoration(
                  color: palette.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: palette.background, width: 4),
                  boxShadow: [
                    BoxShadow(color: palette.shadowColor, blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
                  child: const Icon(Icons.mosque_rounded, size: 30, color: AppColors.goldLight),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: _overlap + 8),
        Text(
          MasjidInfo.name,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_rounded, size: 14, color: palette.goldMuted),
            const SizedBox(width: 4),
            Text(
              MasjidInfo.locationLabel,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.goldMuted),
            ),
          ],
        ),
      ],
    );
  }
}