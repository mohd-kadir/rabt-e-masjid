import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Wraps any form control with a consistent label above it and an
/// optional inline error message below — used for every field on the
/// Add Announcement form so spacing and typography stay uniform.
class LabeledField extends StatelessWidget {
  final String label;
  final bool required;
  final Widget child;
  final String? errorText;

  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.required = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
            if (required) ...[
              const SizedBox(width: 3),
              const Text('*', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.warning)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        child,
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.error_outline_rounded, size: 13, color: AppColors.warning),
              const SizedBox(width: 5),
              Text(
                errorText!,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning),
              ),
            ],
          ),
        ],
      ],
    );
  }
}