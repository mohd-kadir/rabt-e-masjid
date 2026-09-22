import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum HistoryFilter { today, week, month }

extension HistoryFilterLabel on HistoryFilter {
  String get label {
    switch (this) {
      case HistoryFilter.today:
        return 'Today';
      case HistoryFilter.week:
        return 'Week';
      case HistoryFilter.month:
        return 'Month';
    }
  }
}

/// "Today / Week / Month" filter chip row for the history list.
class HistoryFilterChips extends StatelessWidget {
  final HistoryFilter selected;
  final ValueChanged<HistoryFilter> onChanged;

  const HistoryFilterChips({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        for (final filter in HistoryFilter.values) ...[
          _FilterChip(
            label: filter.label,
            selected: selected == filter,
            onTap: () => onChanged(filter),
            palette: palette,
          ),
          if (filter != HistoryFilter.values.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final AppPalette palette;

  const _FilterChip({required this.label, required this.selected, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : palette.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryGreen : palette.divider, width: 1),
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