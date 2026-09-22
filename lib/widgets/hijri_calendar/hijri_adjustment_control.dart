import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Segmented [-1] [0] [+1] control for manually adjusting the displayed
/// Hijri date by a day, to account for local moon-sighting differences.
class HijriAdjustmentControl extends StatelessWidget {
  final int value; // -1, 0, or 1
  final ValueChanged<int> onChanged;

  const HijriAdjustmentControl({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Hijri Adjustment',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.textPrimary),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: palette.cardSurfaceAlt,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              for (final option in const [-1, 0, 1]) ...[
                _SegmentButton(
                  label: option > 0 ? '+$option' : '$option',
                  selected: value == option,
                  onTap: () => onChanged(option),
                  palette: palette,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppPalette palette;

  const _SegmentButton({required this.label, required this.selected, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}