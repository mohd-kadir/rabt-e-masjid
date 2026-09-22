import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/bookmark.dart';

class AnnouncementBookmarkCard extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback? onTap;

  const AnnouncementBookmarkCard({super.key, required this.bookmark, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(
                  color: palette.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.campaign_outlined,
                    size: 20, color: AppColors.goldMuted),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookmark.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                          height: 1.3),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 12, color: palette.goldMuted),
                        const SizedBox(width: 5),
                        Text(
                          bookmark.preview ?? '',
                          style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: palette.goldMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 13, color: palette.iconInactive),
            ],
          ),
        ),
      ),
    );
  }
}