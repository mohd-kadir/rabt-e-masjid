import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Reusable section heading used throughout the dashboard
/// (e.g. "Prayer Times", "Quick Actions").
class SectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;

  const SectionTitle({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 17, color: palette.gold),
          const SizedBox(width: 6),
        ],
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }
}