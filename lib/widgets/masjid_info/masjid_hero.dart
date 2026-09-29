import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';
import '../islamic_pattern_painter.dart';

/// Hero section for Masjid Information.
///
/// If a Cloudinary photo exists, it is displayed as the hero image.
/// Otherwise, the default Islamic placeholder is shown.
class MasjidHero extends StatelessWidget {
  final MasjidInfo masjidInfo;

  const MasjidHero({
    super.key,
    required this.masjidInfo,
  });

  static const double _logoSize = 68;
  static const double _overlap = 10;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final hasPhoto = masjidInfo.photoUrl.trim().isNotEmpty;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // =====================================================
            // MASJID PHOTO / PLACEHOLDER
            // =====================================================

            AspectRatio(
              aspectRatio: 1/1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: hasPhoto
                      ? null
                      : AppColors.nextPrayerGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: hasPhoto
                      ? Image.network(
                    masjidInfo.photoUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,

                    // While image is loading
                    loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                        ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return _buildPlaceholder();
                    },

                    // If Cloudinary image fails
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return _buildPlaceholder();
                    },
                  )
                      : _buildPlaceholder(),
                ),
              ),
            ),

            // =====================================================
            // LOGO MARK
            // =====================================================

            // Positioned(
            //   top: 170 - _overlap,
            //   child: Container(
            //     width: _logoSize,
            //     height: _logoSize,
            //
            //     decoration: BoxDecoration(
            //       color: palette.background,
            //       shape: BoxShape.circle,
            //       border: Border.all(
            //         color: palette.background,
            //         width: 4,
            //       ),
            //       boxShadow: [
            //         BoxShadow(
            //           color: palette.shadowColor,
            //           blurRadius: 12,
            //           offset:
            //           const Offset(0, 4),
            //         ),
            //       ],
            //     ),
            //
            //     child: Container(
            //       decoration:
            //       const BoxDecoration(
            //         color:
            //         AppColors.primaryGreen,
            //         shape: BoxShape.circle,
            //       ),
            //
            //       child: const Icon(
            //         Icons.mosque_rounded,
            //         size: 30,
            //         color:
            //         AppColors.goldLight,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),

        // =======================================================
        // MASJID NAME
        // =======================================================

        const SizedBox(
          height: _overlap,
        ),

        Text(
          masjidInfo.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),

        const SizedBox(height: 4),

        // =======================================================
        // LOCATION
        // =======================================================

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 14,
              color: palette.goldMuted,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                masjidInfo.locationLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: palette.goldMuted,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =============================================================
  // DEFAULT PLACEHOLDER
  // =============================================================

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.nextPrayerGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Islamic pattern
          Opacity(
            opacity: 0.35,
            child: SizedBox.expand(
              child: CustomPaint(
                painter: IslamicPatternPainter(
                  progress: 0.4,
                  color: AppColors.goldLight,
                ),
              ),
            ),
          ),

          // Default logo
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.20),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.mosque_rounded,
              size: 42,
              color: AppColors.goldLight,
            ),
          ),

          // Placeholder label
          Positioned(
            bottom: 10,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Masjid Photo',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}