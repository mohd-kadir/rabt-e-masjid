import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Small informational banner clarifying that Hijri dates can vary
/// with local moon sighting.
class MoonSightingInfoCard extends StatelessWidget {
  const MoonSightingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 17, color: AppColors.goldMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hijri dates may vary depending on local moon sighting.',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: palette.textPrimary, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}