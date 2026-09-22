import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/surah_data.dart';

/// Reader header: surah number circle, English + Arabic name,
/// revelation type, and ayah count. Colors are passed in explicitly
/// so this widget respects the reader's own manual dark-mode toggle
/// rather than only following the system theme.
class ReaderHeader extends StatelessWidget {
  final SurahInfo surah;
  final AppPalette palette;

  const ReaderHeader({super.key, required this.surah, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            surah.numberLabel,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.goldLight),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          surah.englishName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          surah.arabicName,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: palette.goldMuted),
        ),
        const SizedBox(height: 8),
        Text(
          '${surah.revelationType.label} • ${surah.ayahCount} Ayahs',
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textSecondary),
        ),
      ],
    );
  }
}