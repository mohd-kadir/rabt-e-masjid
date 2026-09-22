import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/ramadan_data.dart';

/// Large "Time Until Iftar" countdown card with an animated circular
/// progress ring showing how much of the fasting day has elapsed.
class IftarCountdownCard extends StatefulWidget {
  const IftarCountdownCard({super.key});

  @override
  State<IftarCountdownCard> createState() => _IftarCountdownCardState();
}

class _IftarCountdownCardState extends State<IftarCountdownCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
    _progressAnim = Tween<double>(begin: 0, end: RamadanData.iftarCountdownProgress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(color: palette.shadowColor, blurRadius: 14, offset: const Offset(0, 6)),
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
                    const Icon(Icons.nightlight_round, size: 15, color: AppColors.gold),
                    const SizedBox(width: 6),
                    Text(
                      'Time Until Iftar',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: palette.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  RamadanData.iftarCountdownLabel,
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: palette.textPrimary, height: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  'Iftar at ${RamadanData.iftarTime}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: palette.goldMuted),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _progressAnim,
            builder: (context, _) => _ProgressRing(progress: _progressAnim.value, palette: palette),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;
  final AppPalette palette;

  const _ProgressRing({required this.progress, required this.palette});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      height: 84,
      child: CustomPaint(
        painter: _RingPainter(progress: progress, trackColor: palette.divider),
        child: const Center(
          child: Icon(Icons.dark_mode_rounded, size: 24, color: AppColors.gold),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;

  _RingPainter({required this.progress, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..shader = const SweepGradient(colors: [AppColors.primaryGreen, AppColors.gold])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) => oldDelegate.progress != progress;
}