import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class QiblaNeedle extends StatefulWidget {
  final double size;
  final double targetAngleDegrees;

  const QiblaNeedle({super.key, required this.size, required this.targetAngleDegrees});

  @override
  State<QiblaNeedle> createState() => _QiblaNeedleState();
}

class _QiblaNeedleState extends State<QiblaNeedle> with TickerProviderStateMixin {
  late AnimationController _settleController;
  late Animation<double> _settleAnimation;

  late final AnimationController _idleController;
  late final Animation<double> _idleAnimation;

  double _previousTarget = 0.0;

  @override
  void initState() {
    super.initState();
    _previousTarget = widget.targetAngleDegrees;

    _settleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _settleAnimation = Tween<double>(
      begin: 0,
      end: widget.targetAngleDegrees,
    ).animate(
      CurvedAnimation(parent: _settleController, curve: Curves.easeOutBack),
    );

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _idleAnimation = Tween<double>(begin: -0.6, end: 0.6).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    );

    _settleController.forward(from: 0);
  }

  @override
  void didUpdateWidget(QiblaNeedle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.targetAngleDegrees - _previousTarget).abs() > 0.5) {
      _previousTarget = widget.targetAngleDegrees;

      _settleAnimation = Tween<double>(
        begin: _settleAnimation.value,
        end: widget.targetAngleDegrees,
      ).animate(
        CurvedAnimation(parent: _settleController, curve: Curves.easeOutBack),
      );

      _settleController.reset();
      _settleController.forward();
    }
  }

  @override
  void dispose() {
    _settleController.dispose();
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_settleAnimation, _idleAnimation]),
      builder: (context, child) {
        final settleProgress = _settleController.value;
        final jitter = settleProgress > 0.9 ? _idleAnimation.value : 0.0;
        final totalDegrees = _settleAnimation.value + jitter;

        return Transform.rotate(
          angle: totalDegrees * 3.1415926535 / 180,
          child: child,
        );
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(painter: _NeedlePainter()),
      ),
    );
  }
}

class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final needleLength = size.height * 0.38;

    final tipPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [AppColors.goldLight, AppColors.gold],
      ).createShader(Rect.fromLTWH(center.dx - 10, center.dy - needleLength, 20, needleLength));

    final path = Path()
      ..moveTo(center.dx, center.dy - needleLength)
      ..lineTo(center.dx - 9, center.dy - needleLength * 0.35)
      ..lineTo(center.dx + 9, center.dy - needleLength * 0.35)
      ..close();
    canvas.drawPath(path, tipPaint);

    final tailPaint = Paint()..color = Colors.white.withOpacity(0.25);
    final tailPath = Path()
      ..moveTo(center.dx, center.dy + needleLength * 0.5)
      ..lineTo(center.dx - 6, center.dy + needleLength * 0.15)
      ..lineTo(center.dx + 6, center.dy + needleLength * 0.15)
      ..close();
    canvas.drawPath(tailPath, tailPaint);

    canvas.drawCircle(center, 7, Paint()..color = AppColors.primaryGreenDark);
    canvas.drawCircle(
      center,
      7,
      Paint()
        ..color = AppColors.goldLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) => false;
}