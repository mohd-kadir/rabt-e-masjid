import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A labeled text field with consistent styling, used for every text
/// input on the Masjid Settings screen.
class SettingsTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const SettingsTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderRadius = BorderRadius.circular(14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(fontSize: 13.5, color: palette.textPrimary, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            prefixIcon: maxLines > 1
                ? null
                : Icon(icon, size: 18, color: AppColors.primaryGreen),
            filled: true,
            fillColor: palette.cardSurfaceAlt,
            contentPadding: EdgeInsets.symmetric(vertical: maxLines > 1 ? 14 : 14, horizontal: maxLines > 1 ? 14 : 4),
            border: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: borderRadius, borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.warning, width: 1.4),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.warning, width: 1.6),
            ),
            errorStyle: const TextStyle(fontSize: 11, color: AppColors.warning, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}