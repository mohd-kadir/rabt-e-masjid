import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/announcement_data.dart';
import '../../models/admin_dashboard_data.dart';

/// Admin management card: title, category, date, status badge, an
/// Important badge when applicable, and Edit/Delete actions.
class ManageAnnouncementCard extends StatelessWidget {
  final AnnouncementItem item;
  final AnnouncementStatus status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ManageAnnouncementCard({
    super.key,
    required this.item,
    required this.status,
    required this.onEdit,
    required this.onDelete,
  });

  Color _statusColor() {
    switch (status) {
      case AnnouncementStatus.published:
        return AppColors.primaryGreen;
      case AnnouncementStatus.scheduled:
        return AppColors.goldMuted;
      case AnnouncementStatus.draft:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final statusColor = _statusColor();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.isImportant ? AppColors.gold.withOpacity(0.5) : palette.divider,
          width: item.isImportant ? 1.3 : 1,
        ),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: palette.textPrimary, height: 1.3),
                ),
              ),
              if (item.isImportant) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.warning.withOpacity(0.35)),
                  ),
                  child: const Text(
                    'IMPORTANT',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.warning, letterSpacing: 0.3),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: item.category.badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.category.icon, size: 11, color: item.category.badgeColor),
                    const SizedBox(width: 4),
                    Text(
                      item.category.label,
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: item.category.badgeColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.calendar_today_rounded, size: 11, color: palette.textSecondary),
              const SizedBox(width: 4),
              Text(
                item.dateLabel,
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: palette.textSecondary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 15),
                  label: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 15),
                  label: const Text('Delete', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: BorderSide(color: AppColors.warning.withOpacity(0.5), width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}