import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A hand-drawn (vector) minimal mosque + minaret + crescent mark.
/// Kept purely as code (no image assets) so the logo scales crisply
/// at any resolution and needs no external files.
class MosqueLogoPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  MosqueLogoPainter({
    this.primaryColor = AppColors.primaryGreen,
    this.accentColor = AppColors.gold,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..shader = AppColors.logoGradient.createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = accentColor.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.012
      ..strokeCap = StrokeCap.round;

    // --- Base platform ---
    final baseRect = Rect.fromLTWH(w * 0.08, h * 0.82, w * 0.84, h * 0.05);
    canvas.drawRRect(
      RRect.fromRectAndRadius(baseRect, Radius.circular(h * 0.01)),
      bodyPaint,
    );

    // --- Central dome building ---
    final domeCenter = Offset(w * 0.5, h * 0.52);
    final domeRadius = w * 0.22;

    // Dome (arc)
    final domePath = Path()
      ..moveTo(domeCenter.dx - domeRadius, domeCenter.dy)
      ..arcToPoint(
        Offset(domeCenter.dx + domeRadius, domeCenter.dy),
        radius: Radius.circular(domeRadius),
        clockwise: false,
      )
      ..lineTo(domeCenter.dx + domeRadius, h * 0.82)
      ..lineTo(domeCenter.dx - domeRadius, h * 0.82)
      ..close();
    canvas.drawPath(domePath, bodyPaint);
    canvas.drawPath(domePath, strokePaint..strokeWidth = w * 0.008);

    // Dome finial + small crescent
    final finialTop = Offset(domeCenter.dx, domeCenter.dy - domeRadius - h * 0.10);
    canvas.drawLine(
      Offset(domeCenter.dx, domeCenter.dy - domeRadius),
      finialTop,
      strokePaint..strokeWidth = w * 0.012,
    );
    _drawCrescent(canvas, finialTop, w * 0.045, accentPaint);

    // Arched doorway
    final doorWidth = domeRadius * 0.5;
    final doorRect = Rect.fromLTWH(
      domeCenter.dx - doorWidth / 2,
      h * 0.82 - h * 0.16,
      doorWidth,
      h * 0.16,
    );
    final doorPaint = Paint()..color = AppColors.background;
    final doorPath = Path()
      ..moveTo(doorRect.left, doorRect.bottom)
      ..lineTo(doorRect.left, doorRect.top + doorWidth / 2)
      ..arcToPoint(
        Offset(doorRect.right, doorRect.top + doorWidth / 2),
        radius: Radius.circular(doorWidth / 2),
        clockwise: true,
      )
      ..lineTo(doorRect.right, doorRect.bottom)
      ..close();
    canvas.drawPath(doorPath, doorPaint);
    canvas.drawPath(doorPath, strokePaint..strokeWidth = w * 0.006);

    // --- Twin minarets ---
    _drawMinaret(canvas, w, h, bodyPaint, accentPaint, strokePaint, isLeft: true);
    _drawMinaret(canvas, w, h, bodyPaint, accentPaint, strokePaint, isLeft: false);
  }

  void _drawMinaret(
      Canvas canvas,
      double w,
      double h,
      Paint bodyPaint,
      Paint accentPaint,
      Paint strokePaint, {
        required bool isLeft,
      }) {
    final double side = isLeft ? -1 : 1;
    final double towerWidth = w * 0.055;
    final double towerX = w * 0.5 + side * w * 0.32;
    final double towerTop = h * 0.30;
    final double towerBottom = h * 0.82;

    final towerRect = Rect.fromLTWH(
      towerX - towerWidth / 2,
      towerTop,
      towerWidth,
      towerBottom - towerTop,
    );
    canvas.drawRect(towerRect, bodyPaint);
    canvas.drawRect(towerRect, strokePaint..strokeWidth = w * 0.006);

    // Small dome cap on minaret
    final capCenter = Offset(towerX, towerTop);
    final capRadius = towerWidth * 0.75;
    canvas.drawArc(
      Rect.fromCircle(center: capCenter, radius: capRadius),
      3.14159,
      3.14159,
      true,
      accentPaint,
    );

    // Spire
    canvas.drawLine(
      Offset(towerX, towerTop - capRadius),
      Offset(towerX, towerTop - capRadius - h * 0.05),
      strokePaint..strokeWidth = w * 0.008,
    );
  }

  void _drawCrescent(Canvas canvas, Offset center, double radius, Paint paint) {
    final outerPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final innerPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(center.dx + radius * 0.55, center.dy - radius * 0.15),
        radius: radius * 0.85,
      ));
    final crescentPath = Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(crescentPath, paint);
  }

  @override
  bool shouldRepaint(covariant MosqueLogoPainter oldDelegate) => false;
}