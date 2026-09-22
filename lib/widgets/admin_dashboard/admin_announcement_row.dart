import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/announcement_data.dart';
import '../../models/admin_dashboard_data.dart';

/// Admin-facing announcement row: title, category badge, date, and
/// publication status (distinct from the public AnnouncementCard, which
/// has no notion of draft/scheduled state).
class AdminAnnouncementRow extends StatelessWidget {
  final AnnouncementItem item;
  final AnnouncementStatus status;
  final VoidCallback? onTap;

  const AdminAnnouncementRow({super.key, required this.item, required this.status, this.onTap});

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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: item.category.badgeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.category.label,
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: item.category.badgeColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.calendar_today_rounded, size: 10.5, color: palette.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          item.dateLabel,
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
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
        ),
      ),
    );
  }
}