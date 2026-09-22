import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/islamic_pattern_painter.dart';
import '../widgets/mosque_logo_painter.dart';
import 'home_screen.dart';

/// Premium splash screen for Rabt-e-Masjid.
///
/// - Warm off-white background with a subtle animated Islamic geometric pattern
/// - Centered mosque/minaret logo mark with fade + scale entrance
/// - App name + Arabic title fade in after the logo
/// - Tagline fades in last
/// - Auto navigates to [HomeScreen] after a short delay
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Drives the logo fade + scale, and staggers the text fade-ins.
  late final AnimationController _entranceController;
  // Drives the slow, continuous background pattern animation.
  late final AnimationController _backgroundController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _appNameOpacity;
  late final Animation<Offset> _appNameSlide;
  late final Animation<double> _arabicOpacity;
  late final Animation<double> _taglineOpacity;

  static const Duration _totalSplashDuration = Duration(milliseconds: 2600);

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    // Logo: fade + scale, 0% -> 55% of the entrance timeline.
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    // App name: fades + slides up slightly, 35% -> 75%.
    _appNameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );
    _appNameSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );

    // Arabic title: 0.5 -> 0.85
    _arabicOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.5, 0.85, curve: Curves.easeOut),
      ),
    );

    // Tagline: last to appear, 0.65 -> 1.0
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();
    _scheduleNavigation();
  }

  void _scheduleNavigation() {
    Future.delayed(_totalSplashDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, animation, __) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final logoSize = isTablet ? 180.0 : size.width * 0.36;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.splashBackgroundGradient),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Subtle animated Islamic geometric background pattern.
            AnimatedBuilder(
              animation: _backgroundController,
              builder: (context, _) {
                return CustomPaint(
                  painter: IslamicPatternPainter(progress: _backgroundController.value),
                  size: Size.infinite,
                );
              },
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo: fade + scale
                              AnimatedBuilder(
                                animation: _entranceController,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _logoOpacity.value,
                                    child: Transform.scale(
                                      scale: _logoScale.value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  width: logoSize,
                                  height: logoSize,
                                  child: CustomPaint(
                                    painter: MosqueLogoPainter(),
                                  ),
                                ),
                              ),

                              SizedBox(height: isTablet ? 32 : 24),

                              // App name: fade + slide
                              SlideTransition(
                                position: _appNameSlide,
                                child: FadeTransition(
                                  opacity: _appNameOpacity,
                                  child: Text(
                                    'Rabt-e-Masjid',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.appNameStyle(
                                      context,
                                      fontSize: isTablet ? 34 : 28,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Arabic title
                              FadeTransition(
                                opacity: _arabicOpacity,
                                child: Text(
                                  'رَبْطُ الْمَسْجِد',
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: AppTheme.arabicStyle(
                                    context,
                                    fontSize: isTablet ? 26 : 22,
                                  ),
                                ),
                              ),

                              SizedBox(height: isTablet ? 20 : 14),

                              // Decorative divider
                              FadeTransition(
                                opacity: _taglineOpacity,
                                child: Container(
                                  width: 56,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.gold,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),

                              SizedBox(height: isTablet ? 16 : 12),

                              // Tagline
                              FadeTransition(
                                opacity: _taglineOpacity,
                                child: Text(
                                  'CONNECTING MASAJID & COMMUNITIES',
                                  textAlign: TextAlign.center,
                                  style: AppTheme.taglineStyle(
                                    context,
                                    fontSize: isTablet ? 14 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Small bottom loading indicator, fades in with the tagline.
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: SafeArea(
                child: FadeTransition(
                  opacity: _taglineOpacity,
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.gold.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}