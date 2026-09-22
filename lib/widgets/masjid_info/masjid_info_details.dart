import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';

/// Address / Phone / Email information card.
class MasjidInfoDetails extends StatelessWidget {
  const MasjidInfoDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.location_on_outlined, label: 'Address', value: MasjidInfo.address, palette: palette),
          Divider(height: 22, thickness: 1, color: palette.divider),
          _InfoRow(icon: Icons.call_outlined, label: 'Phone', value: MasjidInfo.phone, palette: palette),
          Divider(height: 22, thickness: 1, color: palette.divider),
          _InfoRow(icon: Icons.mail_outline_rounded, label: 'Email', value: MasjidInfo.email, palette: palette),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final AppPalette palette;

  const _InfoRow({required this.icon, required this.label, required this.value, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: AppColors.primaryGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: palette.goldMuted, letterSpacing: 0.4),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: palette.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}