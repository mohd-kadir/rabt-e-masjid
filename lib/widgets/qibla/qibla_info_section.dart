import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class QiblaInfoSection extends StatelessWidget {
  final double directionDegrees;
  final String distanceToMakkah;

  const QiblaInfoSection({
    super.key,
    required this.directionDegrees,
    required this.distanceToMakkah,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: _InfoBlock(
            label: 'Qibla Direction',
            value: '${directionDegrees.round()}°',
            icon: Icons.explore_rounded,
            palette: palette,
            isHighlighted: true,
          ),
        ),
        const SizedBox(width: 12),
        Container(width: 1, height: 46, color: palette.divider),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoBlock(
            label: 'Distance to Makkah',
            value: distanceToMakkah,
            icon: Icons.mosque_rounded,
            palette: palette,
            isHighlighted: false,
          ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final AppPalette palette;
  final bool isHighlighted;

  const _InfoBlock({
    required this.label,
    required this.value,
    required this.icon,
    required this.palette,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isHighlighted ? AppColors.goldLight : palette.goldMuted,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isHighlighted ? AppColors.goldLight : palette.textPrimary,
          ),
        ),
        if (isHighlighted) ...[
          const SizedBox(height: 4),
          Text(
            '↑ Follow the arrow',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.goldLight.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}