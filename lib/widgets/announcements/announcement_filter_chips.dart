import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/announcement_data.dart';

/// Category filter chips: "All" plus every [AnnouncementCategory].
class AnnouncementFilterChips extends StatelessWidget {
  final AnnouncementCategory? selected; // null = "All"
  final ValueChanged<AnnouncementCategory?> onChanged;

  const AnnouncementFilterChips({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _Chip(
            label: 'All',
            selected: selected == null,
            onTap: () => onChanged(null),
            palette: palette,
          ),
          const SizedBox(width: 8),
          for (final category in AnnouncementCategory.values) ...[
            _Chip(
              label: category.label,
              selected: selected == category,
              onTap: () => onChanged(category),
              palette: palette,
            ),
            if (category != AnnouncementCategory.values.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppPalette palette;

  const _Chip({required this.label, required this.selected, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : palette.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryGreen : palette.divider, width: 1),
        ),
        alignment: Alignment.center,
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