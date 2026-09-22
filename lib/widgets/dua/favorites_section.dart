import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/bookmark.dart';

/// "Favourites" section — horizontally scrollable cards of favourited duas.
class FavoritesSection extends StatelessWidget {
  final List<Bookmark> favourites;
  final ValueChanged<Bookmark>? onTap;

  const FavoritesSection({super.key, required this.favourites, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (favourites.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: palette.cardSurfaceAlt,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(Icons.favorite_border_rounded,
                size: 26, color: palette.iconInactive),
            const SizedBox(height: 8),
            Text(
              'No favourites yet',
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              'Tap ♥ on any dua to save it here',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: palette.iconInactive),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: favourites.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final fav = favourites[index];
          return _FavouriteCard(
            bookmark: fav,
            palette: palette,
            onTap: onTap == null ? null : () => onTap!(fav),
          );
        },
      ),
    );
  }
}

class _FavouriteCard extends StatelessWidget {
  final Bookmark bookmark;
  final AppPalette palette;
  final VoidCallback? onTap;

  const _FavouriteCard({
    required this.bookmark,
    required this.palette,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 210,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(18),
            border:
            Border.all(color: AppColors.gold.withOpacity(0.3), width: 1.1),
            boxShadow: [
              BoxShadow(
                  color: palette.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite_rounded,
                      size: 14, color: Colors.redAccent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      bookmark.category ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: palette.goldMuted,
                          letterSpacing: 0.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                bookmark.preview ?? '',
                textDirection: TextDirection.rtl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: palette.textPrimary),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  bookmark.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: palette.textSecondary,
                      height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}