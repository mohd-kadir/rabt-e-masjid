import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/zikr_data.dart';

/// Horizontal scrollable row of preset Zikr chips, plus a "Custom Zikr"
/// entry that opens a dialog for a user-defined Zikr.
class ZikrSelectorChips extends StatelessWidget {
  final ZikrPreset selected;
  final ValueChanged<ZikrPreset> onSelect;
  final VoidCallback onCustomTap;

  const ZikrSelectorChips({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onCustomTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final preset in zikrPresets) ...[
            _ZikrChip(
              label: preset.name,
              selected: !selected.isCustom && selected.name == preset.name,
              onTap: () => onSelect(preset),
              palette: palette,
            ),
            const SizedBox(width: 8),
          ],
          _ZikrChip(
            label: selected.isCustom ? selected.name : 'Custom Zikr',
            icon: Icons.edit_rounded,
            selected: selected.isCustom,
            onTap: onCustomTap,
            palette: palette,
          ),
        ],
      ),
    );
  }
}

class _ZikrChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppPalette palette;
  final IconData? icon;

  const _ZikrChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.palette,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : palette.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryGreen : palette.divider, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: selected ? Colors.white : palette.goldMuted),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}