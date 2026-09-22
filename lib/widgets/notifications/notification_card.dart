import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/notification_data.dart';

/// A single notification card. Unread notifications get a subtle
/// highlighted background and an unread dot; swiping left reveals a
/// delete action.
class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;
  final VoidCallback onDelete;

  const NotificationCard({super.key, required this.item, this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: item.isRead ? palette.cardSurface : AppColors.primaryGreen.withOpacity(0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: item.isRead ? palette.divider : AppColors.primaryGreen.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(item.category.icon, size: 20, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: palette.textPrimary,
                              ),
                            ),
                          ),
                          if (!item.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.message,
                        style: TextStyle(fontSize: 12.5, color: palette.textSecondary, height: 1.4),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.timeAgo,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: palette.goldMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}