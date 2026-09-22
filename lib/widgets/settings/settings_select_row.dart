import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A settings row with an icon, title, and the current value shown on
/// the trailing side with a chevron — tapping opens a bottom sheet (or
/// performs any other action) via [onTap].
class SettingsSelectRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const SettingsSelectRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
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
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.goldMuted),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 19, color: palette.iconInactive),
          ],
        ),
      ),
    );
  }
}