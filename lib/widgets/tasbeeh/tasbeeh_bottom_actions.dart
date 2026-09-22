import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Bottom row of three actions: Reset, Set Target, History.
class TasbeehBottomActions extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onSetTarget;
  final VoidCallback onHistory;

  const TasbeehBottomActions({
    super.key,
    required this.onReset,
    required this.onSetTarget,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.refresh_rounded,
            label: 'Reset',
            onTap: onReset,
            palette: palette,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.track_changes_rounded,
            label: 'Set Target',
            onTap: onSetTarget,
            palette: palette,
            filled: true,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionButton(
            icon: Icons.history_rounded,
            label: 'History',
            onTap: onHistory,
            palette: palette,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppPalette palette;
  final bool filled;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.palette,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primaryGreen : palette.cardSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: filled ? null : Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 19, color: filled ? Colors.white : AppColors.primaryGreen),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: filled ? Colors.white : palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}