import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ramadan_data.dart';

/// Quran progress card — tracks Juz completed toward a Ramadan khatm
/// (complete reading), following the traditional one-Juz-per-day pace.
class QuranProgressCard extends StatelessWidget {
  final VoidCallback? onTap;

  const QuranProgressCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fraction = RamadanData.juzCompleted / RamadanData.juzTotal;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
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
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.menu_book_rounded, size: 22, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Quran Progress',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
                        ),
                        const Spacer(),
                        Text(
                          'Juz ${RamadanData.juzCompleted} of ${RamadanData.juzTotal}',
                          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.gold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: fraction),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) => LinearProgressIndicator(
                          value: value,
                          minHeight: 7,
                          backgroundColor: palette.divider,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'On pace for a complete khatm by Eid, insha\'Allah',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: palette.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}