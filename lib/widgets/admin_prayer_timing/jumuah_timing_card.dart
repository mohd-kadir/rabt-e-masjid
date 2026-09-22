import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'editable_time_field.dart';

/// Editable Jumu'ah card: Khutbah Time and Salah Time, gold-bordered
/// to match how Jumu'ah is visually distinguished elsewhere in the app.
class JumuahTimingCard extends StatelessWidget {
  final TimeOfDay khutbahTime;
  final TimeOfDay salahTime;
  final ValueChanged<TimeOfDay> onKhutbahChanged;
  final ValueChanged<TimeOfDay> onSalahChanged;

  const JumuahTimingCard({
    super.key,
    required this.khutbahTime,
    required this.salahTime,
    required this.onKhutbahChanged,
    required this.onSalahChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.2),
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
                  gradient: AppColors.goldAccentGradient,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.groups_rounded, size: 18, color: AppColors.primaryGreenDark),
              ),
              const SizedBox(width: 10),
              Text(
                "Jumu'ah",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: EditableTimeField(
                  label: 'KHUTBAH TIME',
                  value: khutbahTime,
                  onChanged: onKhutbahChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: EditableTimeField(
                  label: 'SALAH TIME',
                  value: salahTime,
                  onChanged: onSalahChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}