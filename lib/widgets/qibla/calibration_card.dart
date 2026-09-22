import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Calibration instruction card telling the user to move their phone
/// in a figure-8 motion — standard guidance for compass sensors.
class CalibrationCard extends StatelessWidget {
  const CalibrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.explore_outlined, size: 20, color: AppColors.goldMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Move your phone in a figure-8 motion to calibrate the compass.',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textPrimary, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}