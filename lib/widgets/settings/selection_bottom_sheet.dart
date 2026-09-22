import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'settings_radio_row.dart';

/// A generic bottom sheet: title + a radio list of [options], calling
/// [onSelect] and popping when one is chosen. Reused for Language,
/// Reading Mode, and Prayer Calculation Method.
class SelectionBottomSheet extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  static Future<void> show(
      BuildContext context, {
        required String title,
        required List<String> options,
        required String selected,
        required ValueChanged<String> onSelect,
      }) {
    final palette = context.palette;
    return showModalBottomSheet(
      context: context,
      backgroundColor: palette.cardSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SelectionBottomSheet(
        title: title,
        options: options,
        selected: selected,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
            const SizedBox(height: 8),
            for (final option in options)
              SettingsRadioRow(
                title: option,
                selected: option == selected,
                onTap: () {
                  onSelect(option);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}