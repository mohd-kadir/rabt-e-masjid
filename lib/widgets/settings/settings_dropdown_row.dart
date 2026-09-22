import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A settings row with an icon, title, and an inline Material dropdown
/// beneath it — used for Prayer Calculation Method, where option labels
/// are long enough to need their own line rather than sitting trailing.
class SettingsDropdownRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const SettingsDropdownRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: palette.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: palette.cardSurfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGreen),
                dropdownColor: palette.cardSurface,
                borderRadius: BorderRadius.circular(14),
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textPrimary),
                items: [
                  for (final option in options)
                    DropdownMenuItem(value: option, child: Text(option, overflow: TextOverflow.ellipsis)),
                ],
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}