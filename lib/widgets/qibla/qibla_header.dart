import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Simple title header for the Qibla screen.
class QiblaHeader extends StatelessWidget {
  const QiblaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Text(
      'Qibla',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: palette.textPrimary),
    );
  }
}