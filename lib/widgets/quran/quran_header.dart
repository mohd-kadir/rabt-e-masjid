import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Header for the Quran home screen: English + Arabic title,
/// with search and bookmark actions.
class QuranHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onBookmarkTap;

  const QuranHeader({super.key, this.onSearchTap, this.onBookmarkTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Al-Quran',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'القرآن الكريم',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: palette.goldMuted,
                ),
              ),
            ],
          ),
        ),
        _HeaderIconButton(
          icon: Icons.search_rounded,
          onTap: onSearchTap,
          palette: palette,
        ),
        const SizedBox(width: 10),
        _HeaderIconButton(
          icon: Icons.bookmark_border_rounded,
          onTap: onBookmarkTap,
          palette: palette,
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final AppPalette palette;

  const _HeaderIconButton({required this.icon, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.cardSurface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: palette.shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}