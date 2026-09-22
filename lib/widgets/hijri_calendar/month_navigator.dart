import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/hijri_calendar_data.dart';

/// "< Previous Month   Current Month   Next Month >" navigator row.
class MonthNavigator extends StatelessWidget {
  final DateTime displayedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MonthNavigator({
    super.key,
    required this.displayedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.divider, width: 1),
      ),
      child: Row(
        children: [
          _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrevious, palette: palette),
          Expanded(
            child: Text(
              '${gregorianMonthNames[displayedMonth.month - 1]} ${displayedMonth.year}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
          ),
          _NavButton(icon: Icons.chevron_right_rounded, onTap: onNext, palette: palette),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final AppPalette palette;

  const _NavButton({required this.icon, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.cardSurfaceAlt,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}