import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';

/// A single, richly detailed prayer card for the Prayer Times list.
/// Shows the prayer icon, name, azan + jamaat times, a notification
/// toggle, and a highlighted style when it's the current/next prayer.
class PrayerTimeCard extends StatelessWidget {
  final PrayerEntry prayer;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationChanged;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.notificationsEnabled,
    required this.onNotificationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    // ✅ Use isCurrent
    final bool highlighted = prayer.isCurrent;

    final Color cardColor = highlighted ? AppColors.primaryGreen : palette.cardSurface;
    final Color titleColor = highlighted ? Colors.white : palette.textPrimary;
    final Color subtleColor = highlighted ? Colors.white.withOpacity(0.85) : palette.textSecondary;
    final Color iconBg = highlighted ? Colors.white.withOpacity(0.14) : AppColors.primaryGreen.withOpacity(0.08);
    final Color iconColor = highlighted ? AppColors.goldLight : AppColors.primaryGreen;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: highlighted ? null : Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: highlighted ? 16 : 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(prayer.icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      prayer.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    if (highlighted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'CURRENT',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldLight,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _TimeChip(label: 'Azan', time: prayer.azanTime, muted: subtleColor, strong: titleColor),
                    const SizedBox(width: 14),
                    _TimeChip(label: 'Jamaat', time: prayer.jamaatTime, muted: subtleColor, strong: titleColor),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: notificationsEnabled,
              onChanged: onNotificationChanged,
              activeColor: highlighted ? AppColors.goldLight : AppColors.primaryGreen,
              activeTrackColor: highlighted ? Colors.white.withOpacity(0.25) : AppColors.primaryGreen.withOpacity(0.25),
              inactiveThumbColor: palette.iconInactive,
              inactiveTrackColor: highlighted ? Colors.white.withOpacity(0.15) : palette.divider,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final String time;
  final Color muted;
  final Color strong;

  const _TimeChip({required this.label, required this.time, required this.muted, required this.strong});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: muted, letterSpacing: 0.4),
        ),
        const SizedBox(height: 1),
        Text(
          time,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: strong),
        ),
      ],
    );
  }
}