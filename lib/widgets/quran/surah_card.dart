import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/surah_data.dart';

/// A single Surah card: number circle, English + Arabic name, revelation
/// type and ayah count, a toggleable favourite (heart), and an optional
/// "Continue Reading" indicator for the surah the user last read.
class SurahCard extends StatefulWidget {
  final SurahInfo surah;
  final bool isFavourite;
  final bool isContinueReading;
  final ValueChanged<bool> onFavouriteChanged;
  final VoidCallback? onTap;

  const SurahCard({
    super.key,
    required this.surah,
    required this.isFavourite,
    required this.onFavouriteChanged,
    this.isContinueReading = false,
    this.onTap,
  });

  @override
  State<SurahCard> createState() => _SurahCardState();
}

class _SurahCardState extends State<SurahCard> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final surah = widget.surah;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isContinueReading
                  ? AppColors.gold.withOpacity(0.55)
                  : palette.divider,
              width: widget.isContinueReading ? 1.3 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: palette.shadowColor,
                blurRadius: _pressed ? 4 : 10,
                offset: Offset(0, _pressed ? 2 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      surah.numberLabel,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldLight),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                surah.englishName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: palette.textPrimary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              surah.arabicName,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: palette.goldMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          surah.metaLabel,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  _FavouriteButton(
                    active: widget.isFavourite,
                    onChanged: widget.onFavouriteChanged,
                    palette: palette,
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: palette.goldMuted),
                ],
              ),
              if (widget.isContinueReading) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_circle_fill_rounded,
                          size: 13, color: AppColors.goldMuted),
                      const SizedBox(width: 5),
                      Text(
                        'Continue Reading',
                        style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: palette.goldMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FavouriteButton extends StatelessWidget {
  final bool active;
  final ValueChanged<bool> onChanged;
  final AppPalette palette;

  const _FavouriteButton({
    required this.active,
    required this.onChanged,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!active),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Icon(
          active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey(active),
          size: 21,
          color: active ? Colors.redAccent : palette.iconInactive,
        ),
      ),
    );
  }
}