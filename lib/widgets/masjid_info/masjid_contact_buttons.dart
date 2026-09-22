import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Three quick-action buttons: Call, Directions, Contact.
class MasjidContactButtons extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback? onDirections;
  final VoidCallback? onContact;

  const MasjidContactButtons({super.key, this.onCall, this.onDirections, this.onContact});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ContactButton(icon: Icons.call_rounded, label: 'Call', onTap: onCall, filled: true),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ContactButton(icon: Icons.directions_rounded, label: 'Directions', onTap: onDirections),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ContactButton(icon: Icons.mail_outline_rounded, label: 'Contact', onTap: onContact),
        ),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;

  const _ContactButton({required this.icon, required this.label, this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

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