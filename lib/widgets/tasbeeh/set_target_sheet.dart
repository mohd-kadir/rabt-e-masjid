import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Bottom sheet for choosing a target count: common presets (33, 34, 99,
/// 100) plus a custom numeric entry.
class SetTargetSheet extends StatefulWidget {
  final int currentTarget;
  final ValueChanged<int> onSelect;

  const SetTargetSheet({super.key, required this.currentTarget, required this.onSelect});

  @override
  State<SetTargetSheet> createState() => _SetTargetSheetState();
}

class _SetTargetSheetState extends State<SetTargetSheet> {
  static const List<int> _presets = [33, 34, 99, 100];
  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _submitCustom() {
    final value = int.tryParse(_customController.text.trim());
    if (value != null && value > 0) {
      widget.onSelect(value);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 20),
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
              'Set Target',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final preset in _presets)
                  _PresetButton(
                    value: preset,
                    selected: widget.currentTarget == preset,
                    palette: palette,
                    onTap: () {
                      widget.onSelect(preset);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Custom Target',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.cardSurfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _customController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 14, color: palette.textPrimary, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'e.g. 500',
                        hintStyle: TextStyle(fontSize: 14, color: palette.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _submitCustom,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      child: Icon(Icons.check_rounded, size: 18, color: Colors.white),
                    ),
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

class _PresetButton extends StatelessWidget {
  final int value;
  final bool selected;
  final VoidCallback onTap;
  final AppPalette palette;

  const _PresetButton({required this.value, required this.selected, required this.onTap, required this.palette});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : palette.cardSurfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primaryGreen : palette.divider, width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          '$value',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : palette.textPrimary,
          ),
        ),
      ),
    );
  }
}