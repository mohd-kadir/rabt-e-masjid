import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Search field for filtering bookmarks within the current tab.
class BookmarkSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const BookmarkSearchBar({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
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
        onChanged: onChanged,
        style: TextStyle(fontSize: 14, color: palette.textPrimary, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Search bookmarks...',
          hintStyle: TextStyle(fontSize: 14, color: palette.textSecondary, fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.search_rounded, size: 20, color: palette.goldMuted),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
            icon: Icon(Icons.close_rounded, size: 18, color: palette.iconInactive),
            onPressed: () {
              controller.clear();
              onChanged('');
            },
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        ),
      ),
    );
  }
}