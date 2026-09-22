import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Settings bottom sheet for the Tasbeeh screen — haptic feedback and
/// keep-screen-on are UI-only placeholders (no platform wiring here).
class TasbeehSettingsSheet extends StatelessWidget {
  final bool hapticEnabled;
  final bool keepScreenOn;
  final ValueChanged<bool> onHapticChanged;
  final ValueChanged<bool> onKeepScreenOnChanged;

  const TasbeehSettingsSheet({
    super.key,
    required this.hapticEnabled,
    required this.keepScreenOn,
    required this.onHapticChanged,
    required this.onKeepScreenOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: palette.divider, borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Tasbeeh Settings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: palette.textPrimary),
            ),
            const SizedBox(height: 18),
            _SettingsToggle(
              label: 'Haptic Feedback',
              subtitle: 'Vibrate on each count',
              value: hapticEnabled,
              onChanged: onHapticChanged,
              palette: palette,
            ),
            const SizedBox(height: 14),
            _SettingsToggle(
              label: 'Keep Screen On',
              subtitle: 'Prevent the screen from sleeping while counting',
              value: keepScreenOn,
              onChanged: onKeepScreenOnChanged,
              palette: palette,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final AppPalette palette;

  const _SettingsToggle({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: palette.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w400, color: palette.textSecondary)),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryGreen,
          activeTrackColor: AppColors.primaryGreen.withOpacity(0.25),
          inactiveThumbColor: palette.iconInactive,
          inactiveTrackColor: palette.divider,
        ),
      ],
    );
  }
}