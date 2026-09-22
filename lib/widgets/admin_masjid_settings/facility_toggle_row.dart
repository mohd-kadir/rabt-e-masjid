import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';

/// A single facility with an on/off Switch, used to control whether it
/// shows on the public Masjid Information screen.
class FacilityToggleRow extends StatelessWidget {
  final MasjidFacility facility;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const FacilityToggleRow({
    super.key,
    required this.facility,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(facility.icon, size: 18, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              facility.name,
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: palette.textPrimary),
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeColor: AppColors.primaryGreen,
            activeTrackColor: AppColors.primaryGreen.withOpacity(0.25),
            inactiveThumbColor: palette.iconInactive,
            inactiveTrackColor: palette.divider,
          ),
        ],
      ),
    );
  }
}