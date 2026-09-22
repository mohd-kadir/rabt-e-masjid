import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Beautiful empty state: "Nothing bookmarked yet."
class BookmarksEmptyState extends StatelessWidget {
  final bool isSearchResult;

  const BookmarksEmptyState({super.key, this.isSearchResult = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              gradient: AppColors.goldAccentGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bookmark_border_rounded, size: 34, color: AppColors.primaryGreenDark),
          ),
          const SizedBox(height: 20),
          Text(
            isSearchResult ? 'No bookmarks match your search' : 'Nothing bookmarked yet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            isSearchResult
                ? 'Try a different search term.'
                : 'Save your favorite Ayahs, Duas, and announcements to find them here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: palette.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}