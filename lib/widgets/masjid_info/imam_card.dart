import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';

/// Imam name and short bio card.
class ImamCard extends StatelessWidget {
  const ImamCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.goldAccentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.person_rounded, size: 26, color: AppColors.primaryGreenDark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IMAM',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: palette.goldMuted, letterSpacing: 0.6),
                ),
                const SizedBox(height: 3),
                Text(
                  MasjidInfo.imamName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: palette.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  MasjidInfo.imamBio,
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400, color: palette.textSecondary, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}