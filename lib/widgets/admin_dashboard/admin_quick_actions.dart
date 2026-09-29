import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AdminQuickAction {
  final String label;
  final IconData icon;
  final bool isPrimary;

  const AdminQuickAction({required this.label, required this.icon, this.isPrimary = false});
}

const List<AdminQuickAction> adminQuickActions = [
  AdminQuickAction(label: 'Add Announcement', icon: Icons.add_circle_rounded, isPrimary: true),
  AdminQuickAction(label: 'Prayer Timings', icon: Icons.access_time_rounded),
  AdminQuickAction(label: 'Manage Announcements', icon: Icons.campaign_outlined),
  AdminQuickAction(label: 'Masjid Information', icon: Icons.mosque_outlined),
];

/// Quick Actions grid for the Admin Dashboard: "+ Add Announcement" is
/// visually primary (filled), the rest are secondary outlined tiles.
class AdminQuickActions extends StatelessWidget {
  final void Function(AdminQuickAction action)? onTap;

  const AdminQuickActions({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 520;
        final crossAxisCount = isWide ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: adminQuickActions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.4,
          ),
          itemBuilder: (context, index) {
            final action = adminQuickActions[index];
            return _ActionTile(
              action: action,
              onTap: onTap == null ? null : () => onTap!(action),
            );
          },
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  final AdminQuickAction action;
  final VoidCallback? onTap;

  const _ActionTile({required this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final filled = action.isPrimary;

    return Material(
      color: filled ? AppColors.primaryGreen : palette.cardSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: filled ? null : Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: filled ? Colors.white.withOpacity(0.16) : AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(action.icon, size: 17, color: filled ? Colors.white : AppColors.primaryGreen),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  action.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: filled ? Colors.white : palette.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}