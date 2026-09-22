import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';

/// A single Para (Juz) card: large deep-green number circle, English +
/// Arabic name, starting surah, page range, and a gold arrow affordance.
/// Scales down subtly on press for tactile feedback.
class ParaCard extends StatefulWidget {
  final ParaInfo para;
  final VoidCallback? onTap;

  const ParaCard({super.key, required this.para, this.onTap});

  @override
  State<ParaCard> createState() => _ParaCardState();
}

class _ParaCardState extends State<ParaCard> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _pressed ? AppColors.gold.withOpacity(0.5) : palette.divider,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: palette.shadowColor,
                blurRadius: _pressed ? 4 : 10,
                offset: Offset(0, _pressed ? 2 : 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Large circular number.
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.para.number.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldLight,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.para.label,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.para.arabicName,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: palette.goldMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.para.paraName,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.para.pageRangeLabel,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: palette.iconInactive,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 15, color: palette.goldMuted),
            ],
          ),
        ),
      ),
    );
  }
}