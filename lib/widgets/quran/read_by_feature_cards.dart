import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Two large side-by-side feature cards: "Read by Para" and "Read by Surah".
/// Stacks vertically on narrow screens via [LayoutBuilder].
class ReadByFeatureCards extends StatelessWidget {
  final VoidCallback? onParaTap;
  final VoidCallback? onSurahTap;

  const ReadByFeatureCards({super.key, this.onParaTap, this.onSurahTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 340;
        final paraCard = _FeatureCard(
          title: 'Read by Para',
          countLabel: '30 Paras',
          arabicLabel: 'الأجزاء',
          icon: Icons.menu_book_rounded,
          onTap: onParaTap,
        );
        final surahCard = _FeatureCard(
          title: 'Read by Surah',
          countLabel: '114 Surahs',
          arabicLabel: 'السور',
          icon: Icons.auto_stories_rounded,
          onTap: onSurahTap,
        );

        if (narrow) {
          return Column(
            children: [
              paraCard,
              const SizedBox(height: 12),
              surahCard,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: paraCard),
            const SizedBox(width: 12),
            Expanded(child: surahCard),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String countLabel;
  final String arabicLabel;
  final IconData icon;
  final VoidCallback? onTap;

  const _FeatureCard({
    required this.title,
    required this.countLabel,
    required this.arabicLabel,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(
                color: palette.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: AppColors.goldAccentGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 22, color: AppColors.primaryGreenDark),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    countLabel,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: palette.textSecondary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    arabicLabel,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: palette.goldMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}