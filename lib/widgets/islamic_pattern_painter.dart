import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Paints a very subtle repeating Islamic geometric (8-point star / lattice)
/// pattern used as a faint background texture on the splash screen.
///
/// [progress] (0..1) drives a gentle animated opacity/rotation so the
/// background feels alive without being distracting.
class IslamicPatternPainter extends CustomPainter {
  final double progress;
  final Color color;

  IslamicPatternPainter({required this.progress, this.color = AppColors.patternLine});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.06 + 0.03 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double tile = 90;
    final int cols = (size.width / tile).ceil() + 2;
    final int rows = (size.height / tile).ceil() + 2;

    for (int row = -1; row < rows; row++) {
      for (int col = -1; col < cols; col++) {
        final center = Offset(col * tile + (row.isOdd ? tile / 2 : 0), row * tile * 0.87);
        _drawEightPointStar(canvas, paint, center, tile * 0.34);
      }
    }
  }

  void _drawEightPointStar(Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    const int points = 8;
    final double rotation = progress * 0.15; // subtle drift
    for (int i = 0; i <= points; i++) {
      final double angle = (i * (2 * math.pi / points)) + rotation;
      final double r = i.isEven ? radius : radius * 0.55;
      final Offset p = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}