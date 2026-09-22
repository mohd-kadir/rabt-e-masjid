import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/notification_data.dart';

/// Tab filter: All / Prayer / Announcements.
enum NotificationTab { all, prayer, announcements }

class NotificationTabs extends StatelessWidget {
  final NotificationTab selected;
  final ValueChanged<NotificationTab> onChanged;

  const NotificationTabs({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(child: _TabButton(label: 'All', tab: NotificationTab.all, selected: selected, onChanged: onChanged, palette: palette)),
        const SizedBox(width: 8),
        Expanded(child: _TabButton(label: 'Prayer', tab: NotificationTab.prayer, selected: selected, onChanged: onChanged, palette: palette)),
        const SizedBox(width: 8),
        Expanded(
          child: _TabButton(
            label: 'Announcements',
            tab: NotificationTab.announcements,
            selected: selected,
            onChanged: onChanged,
            palette: palette,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final NotificationTab tab;
  final NotificationTab selected;
  final ValueChanged<NotificationTab> onChanged;
  final AppPalette palette;

  const _TabButton({
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

/// Maps a [NotificationTab] to the matching [NotificationCategory],
/// or null for "All".
NotificationCategory? categoryForTab(NotificationTab tab) {
  switch (tab) {
    case NotificationTab.all:
      return null;
    case NotificationTab.prayer:
      return NotificationCategory.prayer;
    case NotificationTab.announcements:
      return NotificationCategory.announcement;
  }
}