import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Empty state shown when no announcements match the current
/// filter/search, or when the list has been fully cleared.
class ManageEmptyState extends StatelessWidget {
  final bool isFiltered;

  const ManageEmptyState({super.key, this.isFiltered = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFiltered ? Icons.search_off_rounded : Icons.campaign_outlined,
              size: 28,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered ? 'No announcements match your filters' : 'No announcements yet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            isFiltered
                ? 'Try a different search term or filter.'
                : 'Tap "+ Add Announcement" to publish your first notice.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: palette.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}