import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/announcement_data.dart';

/// A single announcement card. Important announcements get a gold border,
/// a subtle glow, and an "IMPORTANT" badge — standing out without
/// breaking the overall elegant, restrained card language.
class AnnouncementCard extends StatelessWidget {
  final AnnouncementItem item;
  final VoidCallback? onTap;

  const AnnouncementCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: item.isImportant ? AppColors.gold.withOpacity(0.6) : palette.divider,
              width: item.isImportant ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: item.isImportant ? AppColors.gold.withOpacity(0.18) : palette.shadowColor,
                blurRadius: item.isImportant ? 16 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.hasThumbnail) ...[
                _Thumbnail(category: item.category),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _CategoryBadge(category: item.category),
                        if (item.isImportant) ...[
                          const SizedBox(width: 6),
                          const _ImportantBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: palette.textPrimary, height: 1.3),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.5, color: palette.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded, size: 12, color: palette.goldMuted),
                        const SizedBox(width: 5),
                        Text(
                          '${item.dateLabel} • ${item.timeLabel}',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: palette.goldMuted),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded, size: 13, color: palette.iconInactive),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final AnnouncementCategory category;
  const _Thumbnail({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: category.badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(category.icon, size: 22, color: category.badgeColor),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final AnnouncementCategory category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: category.badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 11, color: category.badgeColor),
          const SizedBox(width: 4),
          Text(
            category.label.toUpperCase(),
            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: category.badgeColor, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }
}

class _ImportantBadge extends StatelessWidget {
  const _ImportantBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withOpacity(0.35)),
      ),
      child: const Text(
        'IMPORTANT',
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.warning, letterSpacing: 0.4),
      ),
    );
  }
}