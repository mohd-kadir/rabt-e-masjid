import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'editable_time_field.dart';

/// A single prayer's editable card: name/icon header, then Azan and
/// Jamaat time fields side by side.
class PrayerTimingCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final TimeOfDay azanTime;
  final TimeOfDay jamaatTime;
  final ValueChanged<TimeOfDay> onAzanChanged;
  final ValueChanged<TimeOfDay> onJamaatChanged;

  const PrayerTimingCard({
    super.key,
    required this.name,
    required this.icon,
    required this.azanTime,
    required this.jamaatTime,
    required this.onAzanChanged,
    required this.onJamaatChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 18, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: EditableTimeField(
                  label: 'AZAN TIME',
                  value: azanTime,
                  onChanged: onAzanChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: EditableTimeField(
                  label: 'JAMAAT TIME',
                  value: jamaatTime,
                  onChanged: onJamaatChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}