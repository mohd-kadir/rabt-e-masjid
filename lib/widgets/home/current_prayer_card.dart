import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../utils/prayer_utils.dart';

class CurrentPrayerCard extends StatelessWidget {
  final String currentPrayerName;
  final String startTime;
  final String endTime;
  final String remainingTime;
  final double progress;

  const CurrentPrayerCard({
    super.key,
    required this.currentPrayerName,
    required this.startTime,
    required this.endTime,
    required this.remainingTime,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: AppColors.nextPrayerGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreenDark.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'CURRENT PRAYER',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.goldLight,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  currentPrayerName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '🕐 ${PrayerUtils.formatTo12Hour(startTime)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '→ ${PrayerUtils.formatTo12Hour(endTime)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.timer_rounded, size: 14, color: AppColors.goldLight),
                    const SizedBox(width: 5),
                    Text(
                      remainingTime,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(progress),
                  ],
                ),
              ],
            ),
          ),
          _ProgressRing(progress: progress),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(double progress) {
    String label;
    Color color;

    if (progress > 0.7) {
      label = '🟢 Just Started';
      color = Colors.green;
    } else if (progress > 0.4) {
      label = '🟡 In Progress';
      color = Colors.orange;
    } else if (progress > 0.15) {
      label = '🟠 Almost Done';
      color = Colors.deepOrange;
    } else {
      label = '🔴 About to End';
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;
  const _ProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                _getProgressLabel(progress),
                style: const TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getProgressLabel(double progress) {
    if (progress > 0.7) return 'Remaining';
    if (progress > 0.3) return 'Remaining';
    return 'Remaining';
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = _getProgressColor(progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  Color _getProgressColor(double progress) {
    if (progress > 0.7) return Colors.green;
    if (progress > 0.4) return Colors.orange;
    if (progress > 0.15) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.progress != progress;
}