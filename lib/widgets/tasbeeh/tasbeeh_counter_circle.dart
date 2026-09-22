import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../theme/app_colors.dart';

/// Large circular counter: progress ring, count, active Zikr text
/// (English + Arabic), and a tap instruction. Tapping anywhere inside
/// increments the count with a smooth ring animation and a tap-scale
/// bounce.
class TasbeehCounterCircle extends StatefulWidget {
  final int count;
  final int target;
  final String zikrName;
  final String zikrArabic;
  final VoidCallback onTap;

  const TasbeehCounterCircle({
    super.key,
    required this.count,
    required this.target,
    required this.zikrName,
    required this.zikrArabic,
    required this.onTap,
  });

  @override
  State<TasbeehCounterCircle> createState() => _TasbeehCounterCircleState();
}

class _TasbeehCounterCircleState extends State<TasbeehCounterCircle> with SingleTickerProviderStateMixin {
  late final AnimationController _tapController;
  late final Animation<double> _tapScale;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
    _tapScale = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) => _tapController.forward();
  void _handleTapUp(TapUpDetails _) => _tapController.reverse();
  void _handleTapCancel() => _tapController.reverse();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progress = widget.target == 0 ? 0.0 : (widget.count / widget.target).clamp(0.0, 1.0);

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _tapScale,
        builder: (context, child) => Transform.scale(scale: _tapScale.value, child: child),
        child: SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow / shadow disc
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.cardSurface,
                  boxShadow: [
                    BoxShadow(color: palette.shadowColor, blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
              ),
              // Animated progress ring
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: progress),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return SizedBox(
                    width: 260,
                    height: 260,
                    child: CustomPaint(
                      painter: _RingPainter(progress: value, trackColor: palette.divider),
                    ),
                  );
                },
              ),
              // Inner content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.zikrArabic,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: palette.goldMuted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.zikrName,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                    child: Text(
                      '${widget.count}',
                      key: ValueKey(widget.count),
                      style: TextStyle(fontSize: 56, fontWeight: FontWeight.w700, color: palette.textPrimary, height: 1),
                    ),
                  ),
                  Text(
                    '/ ${widget.target}',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: palette.goldMuted),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Tap to count',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: palette.iconInactive, letterSpacing: 0.4),
                  ),
                ],
              ),
            ],
          ),
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
    final radius = size.width / 2 - 8;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi,
        colors: const [AppColors.gold, AppColors.primaryGreen, AppColors.gold],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.trackColor != trackColor;
  }
}