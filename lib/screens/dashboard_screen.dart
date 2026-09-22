import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:rabt_e_masjid/screens/notifications_screen.dart';
import 'package:rabt_e_masjid/screens/quran_screen.dart';
import '../providers/app_data_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/home/greeting_header.dart';
import '../widgets/home/hijri_date_card.dart';
import '../widgets/home/current_prayer_card.dart';
import '../widgets/home/prayer_summary_row.dart';
import '../widgets/home/announcement_section.dart';
import '../widgets/home/quick_actions_grid.dart';
import '../widgets/home/section_title.dart';
import '../utils/prayer_utils.dart';
import 'tasbeeh_screen.dart';
import 'announcements_screen.dart';
import 'hijri_calendar_screen.dart';
import 'dua_azkar_screen.dart';
import 'qibla_screen.dart';
import 'masjid_info_screen.dart';

/// The Home Dashboard content — everything the user needs at a glance:
/// greeting, Hijri date, next prayer, today's prayer times, announcements,
/// and quick actions.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  /// Builds a fade + slide-up entrance for section [index], staggered
  /// across the overall controller timeline.
  Widget _animatedSection({required int index, required Widget child}) {
    final start = (index * 0.08).clamp(0.0, 0.7);
    final end = (start + 0.4).clamp(0.0, 1.0);
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppDataProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 600;
    final horizontalPadding = isTablet ? width * 0.1 : 18.0;

    // ✅ Get current prayer data
    final currentPrayerName = PrayerUtils.getCurrentPrayerName(appData.prayerTimes);
    final currentPrayerTime = PrayerUtils.getCurrentPrayerTime(appData.prayerTimes);
    final nextPrayerTime = PrayerUtils.getNextPrayerTime(appData.prayerTimes);
    final remainingTime = PrayerUtils.getRemainingTime(appData.prayerTimes);
    final progress = PrayerUtils.getCurrentPrayerProgress(appData.prayerTimes);

    // ✅ Format times to 12-hour AM/PM
    final startTimeFormatted = PrayerUtils.formatTo12Hour(currentPrayerTime);
    final endTimeFormatted = PrayerUtils.formatTo12Hour(nextPrayerTime);

    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.background),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _animatedSection(
                      index: 0,
                      child: GreetingHeader(
                        onNotificationTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _animatedSection(index: 1, child: const HijriDateCard()),
                    const SizedBox(height: 16),

                    // ✅ Current Prayer Card
                    _animatedSection(
                      index: 2,
                      child: appData.isLoading
                          ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : CurrentPrayerCard(
                        currentPrayerName: currentPrayerName,
                        startTime: startTimeFormatted,
                        endTime: endTimeFormatted,
                        remainingTime: remainingTime,
                        progress: progress,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _animatedSection(
                      index: 3,
                      child: const SectionTitle(
                        title: "Today's Prayer Times",
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _animatedSection(index: 4, child: const PrayerSummaryRow()),
                    const SizedBox(height: 24),
                    _animatedSection(
                      index: 5,
                      child: AnnouncementSection(
                        onViewAll: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AnnouncementsScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _animatedSection(
                      index: 6,
                      child: const SectionTitle(
                        title: 'Quick Actions',
                        icon: Icons.grid_view_rounded,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _animatedSection(
                      index: 7,
                      child: QuickActionsGrid(
                        onTap: (action) {
                          if (action.label == 'Tasbeeh') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TasbeehScreen(),
                              ),
                            );
                          } else if (action.label == 'Hijri Calendar') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const HijriCalendarScreen(),
                              ),
                            );
                          } else if (action.label == 'Dua & Azkar') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const DuaAzkarScreen(),
                              ),
                            );
                          } else if (action.label == 'Qibla') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const QiblaScreen(),
                              ),
                            );
                          } else if (action.label == 'Masjid Info') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MasjidInfoScreen(),
                              ),
                            );
                          } else if (action.label == 'Quran') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const QuranScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}