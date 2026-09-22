import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ramadan_data.dart';

/// Daily Ramadan Dua card — the traditional dua for breaking the fast.
class DailyDuaCard extends StatelessWidget {
  const DailyDuaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.cardSurfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.3), width: 1.2),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_stories_rounded, size: 17, color: AppColors.goldMuted),
              const SizedBox(width: 7),
              Text(
                "Today's Iftar Dua",
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            RamadanData.dailyDuaArabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: palette.textPrimary, height: 1.8),
          ),
          const SizedBox(height: 12),
          Text(
            RamadanData.dailyDuaTransliteration,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: palette.goldMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            RamadanData.dailyDuaTranslation,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: palette.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 10),
          Text(
            '— ${RamadanData.dailyDuaReference}',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: palette.iconInactive),
          ),
        ],
      ),
    );
  }
}