import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class QuranOptionData {
  final String label;
  final IconData icon;

  const QuranOptionData({required this.label, required this.icon});
}

const List<QuranOptionData> _kOptions = [
  QuranOptionData(label: 'Bookmarks', icon: Icons.bookmark_outline_rounded),
  QuranOptionData(label: 'Last Read', icon: Icons.history_rounded),
  QuranOptionData(label: 'Search Quran', icon: Icons.search_rounded),
];

/// Compact list of secondary Quran actions: Bookmarks, Last Read, Search.
class QuranAdditionalOptions extends StatelessWidget {
  final void Function(String label)? onTap;

  const QuranAdditionalOptions({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < _kOptions.length; i++) ...[
            _OptionRow(
              data: _kOptions[i],
              palette: palette,
              onTap: onTap == null ? null : () => onTap!(_kOptions[i].label),
            ),
            if (i != _kOptions.length - 1)
              Divider(height: 1, thickness: 1, color: palette.divider, indent: 58),
          ],
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final QuranOptionData data;
  final AppPalette palette;
  final VoidCallback? onTap;

  const _OptionRow({required this.data, required this.palette, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, size: 17, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                data.label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: palette.textPrimary),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 19, color: palette.iconInactive),
          ],
        ),
      ),
    );
  }
}