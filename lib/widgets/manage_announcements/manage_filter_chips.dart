import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum ManageFilter { all, published, draft, important }

extension ManageFilterLabel on ManageFilter {
  String get label {
    switch (this) {
      case ManageFilter.all:
        return 'All';
      case ManageFilter.published:
        return 'Published';
      case ManageFilter.draft:
        return 'Draft';
      case ManageFilter.important:
        return 'Important';
    }
  }
}

/// All / Published / Draft / Important filter chip row.
class ManageFilterChips extends StatelessWidget {
  final ManageFilter selected;
  final ValueChanged<ManageFilter> onChanged;

  const ManageFilterChips({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final filter in ManageFilter.values) ...[
            _Chip(
              label: filter.label,
              selected: selected == filter,
              onTap: () => onChanged(filter),
              palette: palette,
            ),
            if (filter != ManageFilter.values.last) const SizedBox(width: 8),
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