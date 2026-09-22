import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/bookmark.dart';

class DuaBookmarkCard extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback? onTap;

  const DuaBookmarkCard({super.key, required this.bookmark, this.onTap});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bookmark_rounded,
                      size: 15, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      bookmark.title,
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary),
                    ),
                  ),
                  if (bookmark.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        bookmark.category!,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen),
                      ),
                    ),
                ],
              ),
              if (bookmark.preview != null && bookmark.preview!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  bookmark.preview!,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                      height: 1.6),
                ),
              ],
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios_rounded,
                    size: 13, color: palette.goldMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}