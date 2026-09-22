import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Empty state shown when there are no notifications to display,
/// either overall or within the selected tab.
class NotificationsEmptyState extends StatelessWidget {
  final String message;

  const NotificationsEmptyState({super.key, this.message = "You're all caught up"});

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
            child: const Icon(Icons.notifications_none_rounded, size: 28, color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            'New notifications will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}