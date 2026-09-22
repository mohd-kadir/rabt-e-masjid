import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/bookmark.dart';

/// Card for a bookmarked Quran page (from Para or Surah). Shows a
/// small tag ("Para" or "Surah") at the top-right, the title, Arabic
/// name, and page number.
class QuranBookmarkCard extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback? onTap;

  const QuranBookmarkCard({super.key, required this.bookmark, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isSurah = bookmark.surahNumber != null;

    // Tag colors: Surah = green, Para = gold.
    final tagColor = isSurah ? AppColors.primaryGreen : AppColors.goldMuted;
    final tagBg = isSurah
        ? AppColors.primaryGreen.withOpacity(0.12)
        : AppColors.gold.withOpacity(0.14);

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
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: bookmark icon + title + tag ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.bookmark_rounded,
                      size: 15,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            bookmark.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                        if (bookmark.arabicName != null &&
                            bookmark.arabicName!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            bookmark.arabicName!,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: palette.goldMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // ── Tag: "Surah" / "Para" ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: tagBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bookmark.quranTag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: tagColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),

              // ── Arabic preview ──
              if (bookmark.preview != null &&
                  bookmark.preview!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  bookmark.preview!,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary,
                    height: 1.6,
                  ),
                ),
              ],

              // ── Bottom: page + arrow ──
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 13, color: palette.textSecondary),
                  const SizedBox(width: 5),
                  Text(
                    bookmark.pageNumber != null
                        ? 'Page ${bookmark.pageNumber}'
                        : 'Page —',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: palette.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 13, color: palette.goldMuted),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}