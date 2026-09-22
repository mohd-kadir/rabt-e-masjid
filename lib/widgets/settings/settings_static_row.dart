import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A non-interactive settings row showing a fixed value (e.g. App Version).
class SettingsStaticRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const SettingsStaticRow({super.key, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
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
          Text(
            value,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// A plain navigational row (icon, title, chevron) — used for About,
/// Privacy Policy, Terms.
class SettingsNavRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsNavRow({super.key, required this.icon, required this.title, required this.onTap});

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
            Icon(Icons.chevron_right_rounded, size: 19, color: palette.iconInactive),
          ],
        ),
      ),
    );
  }
}