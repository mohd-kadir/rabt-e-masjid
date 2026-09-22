import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/surah_data.dart';

enum SurahFilter { all, meccan, medinan, favourites }

/// Search field + filter chip row ("All", "Meccan", "Medinan", "Favourites")
/// for the Surah List screen.
class SurahSearchAndFilter extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final SurahFilter selectedFilter;
  final ValueChanged<SurahFilter> onFilterChanged;

  const SurahSearchAndFilter({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onSearchChanged,
            style: TextStyle(fontSize: 14, color: palette.textPrimary, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Search Surah',
              hintStyle: TextStyle(fontSize: 14, color: palette.textSecondary, fontWeight: FontWeight.w400),
              prefixIcon: Icon(Icons.search_rounded, size: 20, color: palette.goldMuted),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                icon: Icon(Icons.close_rounded, size: 18, color: palette.iconInactive),
                onPressed: () {
                  controller.clear();
                  onSearchChanged('');
                },
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                selected: selectedFilter == SurahFilter.all,
                onTap: () => onFilterChanged(SurahFilter.all),
                palette: palette,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Meccan',
                selected: selectedFilter == SurahFilter.meccan,
                onTap: () => onFilterChanged(SurahFilter.meccan),
                palette: palette,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Medinan',
                selected: selectedFilter == SurahFilter.medinan,
                onTap: () => onFilterChanged(SurahFilter.medinan),
                palette: palette,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Favourites',
                selected: selectedFilter == SurahFilter.favourites,
                onTap: () => onFilterChanged(SurahFilter.favourites),
                palette: palette,
                icon: Icons.favorite_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppPalette palette;
  final IconData? icon;

  const _FilterChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : palette.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primaryGreen : palette.divider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: selected ? Colors.white : palette.textSecondary,
              ),
              const SizedBox(width: 5),
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