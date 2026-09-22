import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Bottom sheet for adjusting the Arabic font size, with a live Arabic
/// text preview that scales as the slider moves.
class FontSizeBottomSheet extends StatefulWidget {
  final double initialScale;
  final ValueChanged<double> onChanged;

  const FontSizeBottomSheet({super.key, required this.initialScale, required this.onChanged});

  static Future<void> show(
      BuildContext context, {
        required double initialScale,
        required ValueChanged<double> onChanged,
      }) {
    final palette = context.palette;
    return showModalBottomSheet(
      context: context,
      backgroundColor: palette.cardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => FontSizeBottomSheet(initialScale: initialScale, onChanged: onChanged),
    );
  }

  @override
  State<FontSizeBottomSheet> createState() => _FontSizeBottomSheetState();
}

class _FontSizeBottomSheetState extends State<FontSizeBottomSheet> {
  late double _scale;

  @override
  void initState() {
    super.initState();
    _scale = widget.initialScale;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: palette.divider, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Arabic Font Size',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: palette.cardSurfaceAlt,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22 * _scale, fontWeight: FontWeight.w600, color: palette.textPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.text_decrease_rounded, size: 18, color: palette.textSecondary),
                Expanded(
                  child: Slider(
                    value: _scale,
                    min: 0.75,
                    max: 1.6,
                    divisions: 17,
                    activeColor: AppColors.primaryGreen,
                    inactiveColor: palette.divider,
                    label: '${(_scale * 100).round()}%',
                    onChanged: (v) {
                      setState(() => _scale = v);
                      widget.onChanged(v);
                    },
                  ),
                ),
                Icon(Icons.text_increase_rounded, size: 20, color: palette.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}