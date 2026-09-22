import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Small legend clarifying what the grid's highlight colors mean.
class CalendarLegend extends StatelessWidget {
  const CalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        _LegendItem(color: AppColors.primaryGreen, label: 'Today', palette: palette, isDot: false),
        _LegendItem(color: AppColors.gold.withOpacity(0.5), label: 'Friday', palette: palette, isDot: false, isRing: true),
        _LegendItem(color: AppColors.gold, label: 'Islamic Event', palette: palette, isDot: true),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final AppPalette palette;
  final bool isDot;
  final bool isRing;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.palette,
    required this.isDot,
    this.isRing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isDot ? color : (isRing ? Colors.transparent : color),
            shape: isDot ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isDot ? null : BorderRadius.circular(4),
            border: isRing ? Border.all(color: color, width: 1.4) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: palette.textSecondary),
        ),
      ],
    );
  }
}