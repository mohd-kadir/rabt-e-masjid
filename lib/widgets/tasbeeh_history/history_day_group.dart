import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/zikr_data.dart';

/// A single day's history card: date header, then each Zikr's name,
/// count, and a progress bar showing its share of that day's total.
class HistoryDayGroup extends StatelessWidget {
  final DailyZikrLog log;

  const HistoryDayGroup({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 13, color: palette.goldMuted),
              const SizedBox(width: 6),
              Text(
                log.dateLabel,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const Spacer(),
              Text(
                '${log.totalCount} total',
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: palette.goldMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < log.entries.length; i++) ...[
            _ZikrEntryRow(entry: log.entries[i], dayTotal: log.totalCount, palette: palette),
            if (i != log.entries.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ZikrEntryRow extends StatelessWidget {
  final ZikrLogEntry entry;
  final int dayTotal;
  final AppPalette palette;

  const _ZikrEntryRow({required this.entry, required this.dayTotal, required this.palette});

  @override
  Widget build(BuildContext context) {
    final fraction = dayTotal == 0 ? 0.0 : entry.count / dayTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    entry.name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.textPrimary),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entry.arabic,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.goldMuted),
                  ),
                ],
              ),
            ),
            Text(
              '${entry.count}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: fraction),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: palette.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              );
            },
          ),
        ),
      ],
    );
  }
}