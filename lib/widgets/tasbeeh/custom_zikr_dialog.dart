import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/zikr_data.dart';

/// Dialog for entering a custom Zikr — English label plus optional
/// Arabic text — returned as a [ZikrPreset] via [onSubmit].
class CustomZikrDialog extends StatefulWidget {
  final ValueChanged<ZikrPreset> onSubmit;

  const CustomZikrDialog({super.key, required this.onSubmit});

  @override
  State<CustomZikrDialog> createState() => _CustomZikrDialogState();
}

class _CustomZikrDialogState extends State<CustomZikrDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _arabicController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _arabicController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _arabicController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    widget.onSubmit(ZikrPreset(
      name: name,
      arabic: _arabicController.text.trim(),
      isCustom: true,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Dialog(
      backgroundColor: palette.cardSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Zikr',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
            const SizedBox(height: 16),
            _DialogField(
              controller: _nameController,
              hint: 'Zikr name (e.g. La ilaha illallah)',
              palette: palette,
            ),
            const SizedBox(height: 10),
            _DialogField(
              controller: _arabicController,
              hint: 'Arabic text (optional)',
              palette: palette,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: palette.textSecondary,
                      side: BorderSide(color: palette.divider),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Start', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final AppPalette palette;
  final TextDirection textDirection;

  const _DialogField({
    required this.controller,
    required this.hint,
    required this.palette,
    this.textDirection = TextDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.cardSurfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        textDirection: textDirection,
        style: TextStyle(fontSize: 14, color: palette.textPrimary, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: palette.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}