import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Empty state shown when no announcements match the current filter
/// or search query.
class AnnouncementsEmptyState extends StatelessWidget {
  final String? query;

  const AnnouncementsEmptyState({super.key, this.query});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final hasQuery = query != null && query!.trim().isNotEmpty;

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
              hasQuery ? Icons.search_off_rounded : Icons.campaign_outlined,
              size: 28,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasQuery ? 'No announcements match "$query"' : 'No announcements yet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            hasQuery
                ? 'Try a different search term or category.'
                : 'Check back later for updates from the mosque administration.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: palette.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}