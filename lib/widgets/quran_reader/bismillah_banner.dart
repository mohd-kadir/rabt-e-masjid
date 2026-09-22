import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ayah_data.dart';

/// Decorative Bismillah banner shown once at the top of a surah's
/// content, framed with a thin gold border to feel like an opening
/// page of a physical mushaf.
class BismillahBanner extends StatelessWidget {
  final AppPalette palette;
  final double fontScale;

  const BismillahBanner({super.key, required this.palette, this.fontScale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
      decoration: BoxDecoration(
        color: palette.cardSurfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.2),
      ),
      child: Column(
        children: [
          Text(
            bismillahArabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26 * fontScale,
              height: 1.9,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bismillahTranslation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}