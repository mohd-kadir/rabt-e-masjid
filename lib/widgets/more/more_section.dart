import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Data for a single row in a [MoreSection].
class MoreMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const MoreMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

/// A titled section of menu rows, grouped into a single rounded card
/// with dividers between rows — the building block for the More screen's
/// Islamic Tools / Community / Masjid / App sections.
class MoreSection extends StatelessWidget {
  final String title;
  final List<MoreMenuItem> items;

  const MoreSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: palette.goldMuted,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _MoreRow(item: items[i], palette: palette),
                if (i != items.length - 1) Divider(height: 1, thickness: 1, color: palette.divider, indent: 66),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MoreRow extends StatelessWidget {
  final MoreMenuItem item;
  final AppPalette palette;

  const _MoreRow({required this.item, required this.palette});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(item.icon, size: 20, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: palette.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 19, color: palette.goldMuted),
          ],
        ),
      ),
    );
  }
}