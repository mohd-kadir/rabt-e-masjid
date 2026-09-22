import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Bottom page navigation: previous / page number / next.
class ReaderBottomBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final AppPalette palette;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ReaderBottomBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.palette,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPrevious = currentPage > 1;
    final bool hasNext = currentPage < totalPages;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.cardSurface,
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 14, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _NavButton(
                icon: Icons.chevron_left_rounded,
                label: 'Next',
                enabled: hasPrevious,
                onTap: onPrevious,
                palette: palette,
              ),
              Spacer(),
              SizedBox(width: 23,),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Page $currentPage',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.textPrimary),
                  ),
                  Text(
                    'of $totalPages',
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: palette.textSecondary),
                  ),
                ],
              ),
              Spacer(),
              _NavButton(
                icon: Icons.chevron_right_rounded,
                label: 'Previous',
                enabled: hasNext,
                onTap: onNext,
                iconTrailing: true,
                palette: palette,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback? onTap;
  final bool iconTrailing;
  final AppPalette palette;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
    required this.palette,
    this.iconTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? AppColors.primaryGreen : palette.iconInactive;
    final children = [
      if (!iconTrailing) Icon(icon, size: 20, color: color),
      Text(
        label,
        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: color),
      ),
      if (iconTrailing) Icon(icon, size: 20, color: color),
    ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: children),
        ),
      ),
    );
  }
}