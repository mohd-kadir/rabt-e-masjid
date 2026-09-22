import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'compass_face_painter.dart';
import 'qibla_needle.dart';

class QiblaCompass extends StatelessWidget {
  final double size;
  final double qiblaAngleDegrees;
  final double deviceHeading;

  const QiblaCompass({
    super.key,
    required this.size,
    required this.qiblaAngleDegrees,
    this.deviceHeading = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Calculate needle angle (Qibla relative to device)
    final relativeAngle = qiblaAngleDegrees - deviceHeading;
    final needleAngle = relativeAngle % 360;

    // ✅ Device heading in radians for rotation
    final correctedHeading = (deviceHeading - 90 + 360) % 360;
    final headingRadians = correctedHeading * 3.1415926535 / 180;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreenDark.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ✅ Compass face rotates OPPOSITE to device heading
          // Jab phone ghumta hai, labels sahi direction dikhane ke liye
          Transform.rotate(
            angle: -headingRadians,  // ✅ Negative rotation
            child: CustomPaint(
              size: Size(size, size),
              painter: CompassFacePainter(
                discColor: AppColors.primaryGreen,
                tickColor: Colors.white,
              ),
            ),
          ),

          // ✅ Needle - points to Qibla
          QiblaNeedle(
            size: size,
            targetAngleDegrees: needleAngle,
          ),

          // ✅ Direction indicator
          _buildDirectionIndicator(size, needleAngle),

          // Center Kaaba marker
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.primaryGreenDark,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.goldLight, width: 1.4),
            ),
            child: const Icon(
              Icons.mosque_rounded,
              size: 12,
              color: AppColors.goldLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionIndicator(double size, double needleAngle) {
    return Transform.rotate(
      angle: -deviceHeading * 3.1415926535 / 180,
      child: Container(
        width: size * 0.85,
        height: size * 0.85,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.goldLight.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 24,
                color: AppColors.goldLight,
              ),
            ),
            Container(
              width: 2,
              height: 15,
              color: AppColors.goldLight.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}