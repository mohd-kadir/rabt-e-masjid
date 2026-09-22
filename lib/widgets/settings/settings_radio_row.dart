import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A single selectable row with a radio indicator — used both inline
/// (Appearance, Madhab) and inside [SelectionBottomSheet] option lists.
class SettingsRadioRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  const SettingsRadioRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.primaryGreen : palette.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: palette.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primaryGreen : palette.iconInactive,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}