import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';

/// A slim, visually distinct row for sunrise time — informational only,
/// since it isn't a prayer (no azan/jamaat/notification toggle).
class SunriseCard extends StatelessWidget {
  const SunriseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.cardSurfaceAlt,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.divider, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.wb_twilight_rounded, size: 18, color: palette.gold),
          const SizedBox(width: 10),
          Text(
            'Sunrise',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.textSecondary),
          ),
          const Spacer(),
          Text(
            MockData.sunriseTime,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: palette.textPrimary),
          ),
        ],
      ),
    );
  }
}