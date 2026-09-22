import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Header for the Tasbeeh screen: title with history and settings actions.
class TasbeehHeader extends StatelessWidget {
  final VoidCallback? onHistoryTap;
  final VoidCallback? onSettingsTap;

  const TasbeehHeader({super.key, this.onHistoryTap, this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Tasbeeh',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: palette.textPrimary),
          ),
        ),
        _HeaderIconButton(icon: Icons.history_rounded, onTap: onHistoryTap, palette: palette),
        const SizedBox(width: 10),
        _HeaderIconButton(icon: Icons.settings_outlined, onTap: onSettingsTap, palette: palette),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final AppPalette palette;

  const _HeaderIconButton({required this.icon, required this.onTap, required this.palette});

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
          child: Icon(icon, size: 19, color: AppColors.primaryGreen),
        ),
      ),
    );
  }
}