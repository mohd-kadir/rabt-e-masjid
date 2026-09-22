import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

enum BookmarkTab { quran, dua, announcements }

/// Quran / Dua / Announcements tab selector for the Bookmarks screen.
class BookmarkTabs extends StatelessWidget {
  final BookmarkTab selected;
  final ValueChanged<BookmarkTab> onChanged;

  const BookmarkTabs({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(child: _Tab(label: 'Quran', tab: BookmarkTab.quran, selected: selected, onChanged: onChanged, palette: palette)),
        const SizedBox(width: 8),
        Expanded(child: _Tab(label: 'Dua', tab: BookmarkTab.dua, selected: selected, onChanged: onChanged, palette: palette)),
        const SizedBox(width: 8),
        Expanded(
          child: _Tab(
            label: 'Announcements',
            tab: BookmarkTab.announcements,
            selected: selected,
            onChanged: onChanged,
            palette: palette,
          ),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final BookmarkTab tab;
  final BookmarkTab selected;
  final ValueChanged<BookmarkTab> onChanged;
  final AppPalette palette;

  const _Tab({
    required this.label,
    required this.tab,
    required this.selected,
    required this.onChanged,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = tab == selected;

    return GestureDetector(
      onTap: () => onChanged(tab),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : palette.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.primaryGreen : palette.divider, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : palette.textSecondary,
          ),
        ),
      ),
    );
  }
}