import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'time_format_utils.dart';

/// A labeled, tappable time field that opens a native [showTimePicker]
/// and displays the currently selected time.
class EditableTimeField extends StatelessWidget {
  final String label;
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;

  const EditableTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: value,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primaryGreen),
        ),
        child: child!,
      ),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: palette.textSecondary),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _pickTime(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: palette.cardSurfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formatTimeOfDay(value),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: palette.textPrimary),
                  ),
                ),
                Icon(Icons.edit_outlined, size: 14, color: palette.goldMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}