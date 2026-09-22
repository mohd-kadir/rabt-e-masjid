import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';

/// Admin Dashboard header: title, masjid name, profile icon, and
/// notification icon.
class AdminHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const AdminHeader({super.key, this.onProfileTap, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(Icons.mosque_rounded, size: 13, color: palette.goldMuted),
                  const SizedBox(width: 5),
                  Text(
                    MasjidInfo.name,
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: palette.goldMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        _IconButton(icon: Icons.notifications_none_rounded, onTap: onNotificationTap, palette: palette, showDot: true),
        const SizedBox(width: 10),
        _IconButton(icon: Icons.account_circle_outlined, onTap: onProfileTap, palette: palette),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final AppPalette palette;
  final bool showDot;

  const _IconButton({required this.icon, required this.onTap, required this.palette, this.showDot = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.cardSurface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, size: 21, color: AppColors.primaryGreen),
              if (showDot)
                Positioned(
                  top: 10,
                  right: 11,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.warning, shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}