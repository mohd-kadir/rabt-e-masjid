import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';

/// Jumu'ah (Friday prayer) card — Khutbah and Salah timings side by side,
/// styled with a gold accent to distinguish it from the daily prayer list.
class JumuahCard extends StatelessWidget {
  const JumuahCard({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: AppColors.goldAccentGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.groups_rounded, size: 18, color: AppColors.primaryGreenDark),
              ),
              const SizedBox(width: 10),
              Text(
                "Jumu'ah",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _JumuahTimeBlock(
                  label: 'Khutbah',
                  time: MockData.jumuah.khutbahTime,
                  palette: palette,
                ),
              ),
              Container(width: 1, height: 34, color: palette.divider),
              Expanded(
                child: _JumuahTimeBlock(
                  label: 'Salah',
                  time: MockData.jumuah.salahTime,
                  palette: palette,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JumuahTimeBlock extends StatelessWidget {
  final String label;
  final String time;
  final AppPalette palette;

  const _JumuahTimeBlock({required this.label, required this.time, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: palette.goldMuted, letterSpacing: 0.6),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
      ],
    );
  }
}