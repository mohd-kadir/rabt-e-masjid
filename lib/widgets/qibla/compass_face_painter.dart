import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Paints the static compass face: outer gold ring, dark green disc,
/// minor/major tick marks, and fixed N/E/S/W cardinal labels.
class CompassFacePainter extends CustomPainter {
  final Color discColor;
  final Color tickColor;

  CompassFacePainter({required this.discColor, required this.tickColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer gold ring.
    final ringPaint = Paint()
      ..shader = SweepGradient(
        colors: const [AppColors.gold, AppColors.goldLight, AppColors.gold],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 2, ringPaint);

    // Dark green disc.
    final discPaint = Paint()
      ..shader = RadialGradient(
        colors: [discColor, AppColors.primaryGreenDark],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 6, discPaint);

    // Inner subtle ring.
    final innerRingPaint = Paint()
      ..color = AppColors.gold.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 26, innerRingPaint);

    // Tick marks: 60 minor ticks, every 5th slightly longer, every 15th (cardinal/intercardinal) longest.
    for (int i = 0; i < 60; i++) {
      final angle = (i * 6) * math.pi / 180;
      final isMajor = i % 15 == 0;
      final isMid = i % 5 == 0;
      final tickLength = isMajor ? 14.0 : (isMid ? 9.0 : 5.0);
      final outerR = radius - 10;
      final innerR = outerR - tickLength;

      final tickPaint = Paint()
        ..color = isMajor ? AppColors.gold : tickColor.withOpacity(isMid ? 0.7 : 0.35)
        ..strokeWidth = isMajor ? 2 : 1;

      final p1 = Offset(center.dx + outerR * math.sin(angle), center.dy - outerR * math.cos(angle));
      final p2 = Offset(center.dx + innerR * math.sin(angle), center.dy - innerR * math.cos(angle));
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Cardinal labels: N, E, S, W.
    const labels = ['N', 'E', 'S', 'W'];
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90) * math.pi / 180;
      final labelRadius = radius - 44;
      final offset = Offset(
        center.dx + labelRadius * math.sin(angle),
        center.dy - labelRadius * math.cos(angle),
      );

      final isNorth = i == 0;
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: TextStyle(
            fontSize: isNorth ? 18 : 15,
            fontWeight: FontWeight.w800,
            color: isNorth ? AppColors.goldLight : Colors.white.withOpacity(0.85),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        offset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Center pivot dot.
    canvas.drawCircle(center, 4, Paint()..color = AppColors.goldLight);
  }

  @override
  bool shouldRepaint(covariant CompassFacePainter oldDelegate) {
    return oldDelegate.discColor != discColor || oldDelegate.tickColor != tickColor;
  }
}