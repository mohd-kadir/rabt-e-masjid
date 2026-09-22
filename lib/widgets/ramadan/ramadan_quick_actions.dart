import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class RamadanQuickAction {
  final String label;
  final IconData icon;

  const RamadanQuickAction({required this.label, required this.icon});
}

const List<RamadanQuickAction> ramadanQuickActions = [
  RamadanQuickAction(label: 'Quran', icon: Icons.menu_book_outlined),
  RamadanQuickAction(label: 'Dua', icon: Icons.auto_stories_outlined),
  RamadanQuickAction(label: 'Tasbeeh', icon: Icons.fingerprint),
  RamadanQuickAction(label: 'Zakat', icon: Icons.volunteer_activism_outlined),
];

/// Row of 4 Ramadan-specific quick actions: Quran, Dua, Tasbeeh, Zakat.
class RamadanQuickActionsRow extends StatelessWidget {
  final void Function(RamadanQuickAction action)? onTap;

  const RamadanQuickActionsRow({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < ramadanQuickActions.length; i++) ...[
          Expanded(
            child: _ActionTile(
              action: ramadanQuickActions[i],
              onTap: onTap == null ? null : () => onTap!(ramadanQuickActions[i]),
            ),
          ),
          if (i != ramadanQuickActions.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final RamadanQuickAction action;
  final VoidCallback? onTap;

  const _ActionTile({required this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: palette.cardSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.divider, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: AppColors.goldAccentGradient,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(action.icon, size: 18, color: AppColors.primaryGreenDark),
              ),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}