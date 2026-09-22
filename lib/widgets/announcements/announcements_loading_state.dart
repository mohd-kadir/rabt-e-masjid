import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Loading state: a handful of pulsing skeleton cards that mimic the
/// shape of a real announcement card, built with a plain opacity
/// animation so no external shimmer package is needed.
class AnnouncementsLoadingState extends StatefulWidget {
  const AnnouncementsLoadingState({super.key});

  @override
  State<AnnouncementsLoadingState> createState() => _AnnouncementsLoadingStateState();
}

class _AnnouncementsLoadingStateState extends State<AnnouncementsLoadingState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.45, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Opacity(
          opacity: _pulse.value,
          child: Column(
            children: [
              for (int i = 0; i < 4; i++) ...[
                _SkeletonCard(palette: palette),
                if (i != 3) const SizedBox(height: 12),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final AppPalette palette;
  const _SkeletonCard({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Bar(width: 70, height: 16, palette: palette),
          const SizedBox(height: 12),
          _Bar(width: double.infinity, height: 15, palette: palette),
          const SizedBox(height: 8),
          _Bar(width: double.infinity, height: 11, palette: palette),
          const SizedBox(height: 6),
          _Bar(width: 160, height: 11, palette: palette),
          const SizedBox(height: 12),
          _Bar(width: 120, height: 10, palette: palette),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double width;
  final double height;
  final AppPalette palette;

  const _Bar({required this.width, required this.height, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: palette.divider,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}