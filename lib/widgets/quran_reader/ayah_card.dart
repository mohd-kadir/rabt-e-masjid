import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ayah_data.dart';

/// A single Ayah, designed for maximum Arabic readability:
/// large text, generous line height, roomy padding, and a soft
/// divider separating Arabic from translation/transliteration —
/// meant to feel like a page of a physical mushaf, not a chat bubble.
class AyahCard extends StatelessWidget {
  final AyahData ayah;
  final AppPalette palette;
  final double arabicFontScale;
  final bool showTranslation;
  final bool showTransliteration;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.palette,
    required this.arabicFontScale,
    required this.showTranslation,
    required this.showTransliteration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 22),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Large, generously spaced Arabic text — the visual priority of this screen.
          Text(
            ayah.arabic,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27 * arabicFontScale,
              height: 2.15,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w500,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 18),

          // Ayah number in an elegant circle, centered beneath the verse.
          Center(
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 1.4),
              ),
              alignment: Alignment.center,
              child: Text(
                '${ayah.number}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gold),
              ),
            ),
          ),

          if (showTransliteration) ...[
            const SizedBox(height: 18),
            Divider(height: 1, thickness: 1, color: palette.divider),
            const SizedBox(height: 16),
            Text(
              ayah.transliteration,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: palette.goldMuted,
                height: 1.5,
              ),
            ),
          ],

          if (showTranslation) ...[
            const SizedBox(height: 16),
            if (!showTransliteration) ...[
              Divider(height: 1, thickness: 1, color: palette.divider),
              const SizedBox(height: 16),
            ],
            Text(
              ayah.translation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w400,
                color: palette.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}