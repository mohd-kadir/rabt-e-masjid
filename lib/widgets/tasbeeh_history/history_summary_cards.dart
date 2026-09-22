import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Three compact summary cards: Today's Count, This Week, This Month.
/// Responsive — wraps to a single row on phones, stays roomy on tablets.
class HistorySummaryCards extends StatelessWidget {
  final int todayCount;
  final int weekCount;
  final int monthCount;

  const HistorySummaryCards({
    super.key,
    required this.todayCount,
    required this.weekCount,
    required this.monthCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: "Today's Count",
            value: todayCount,
            icon: Icons.today_rounded,
            filled: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            label: 'This Week',
            value: weekCount,
            icon: Icons.calendar_view_week_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            label: 'This Month',
            value: monthCount,
            icon: Icons.calendar_month_rounded,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final bool filled;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: filled ? AppColors.primaryGreen : palette.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: filled ? null : Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: filled ? AppColors.goldLight : AppColors.primaryGreen),
          const SizedBox(height: 10),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: filled ? Colors.white : palette.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: filled ? Colors.white.withOpacity(0.85) : palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}