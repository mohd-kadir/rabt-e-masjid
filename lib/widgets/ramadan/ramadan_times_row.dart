import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ramadan_data.dart';

/// Three compact cards: Sehri, Iftar, Taraweeh times.
class RamadanTimesRow extends StatelessWidget {
  const RamadanTimesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TimeCard(
            label: 'Sehri',
            time: RamadanData.sehriTime,
            icon: Icons.wb_twilight_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TimeCard(
            label: 'Iftar',
            time: RamadanData.iftarTime,
            icon: Icons.nightlight_round,
            highlighted: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TimeCard(
            label: 'Taraweeh',
            time: RamadanData.taraweehTime,
            icon: Icons.mosque_outlined,
          ),
        ),
      ],
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final bool highlighted;

  const _TimeCard({required this.label, required this.time, required this.icon, this.highlighted = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryGreen : palette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: highlighted ? null : Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: highlighted ? AppColors.goldLight : AppColors.primaryGreen),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: highlighted ? Colors.white : palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlighted ? AppColors.goldLight : palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}