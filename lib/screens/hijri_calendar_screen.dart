import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../models/hijri_calendar_data.dart';
import '../services/hijri_calendar_service.dart';
import '../widgets/hijri_calendar/calendar_header.dart';
import '../widgets/hijri_calendar/month_navigator.dart';
import '../widgets/hijri_calendar/calendar_grid.dart';
import '../widgets/hijri_calendar/calendar_legend.dart';
import '../widgets/hijri_calendar/moon_sighting_info_card.dart';
import '../widgets/hijri_calendar/hijri_adjustment_control.dart';
import '../widgets/hijri_calendar/upcoming_events_section.dart';

class HijriCalendarScreen extends StatefulWidget {
  const HijriCalendarScreen({super.key});

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppDataProvider>(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;

    // ✅ Provider se adjustment use karein
    final hijriAdjustment = appData.hijriAdjustment;

    final displayedHijriMonth = appData.hijriDate ??
        HijriCalendarService.convertGregorianToHijri(
          DateTime(_displayedMonth.year, _displayedMonth.month, 15),
          adjustment: hijriAdjustment,
        );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (appData.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      CalendarHeader(
                        displayedHijriMonth: displayedHijriMonth,
                        displayedGregorianMonth: _displayedMonth,
                      ),
                      const SizedBox(height: 18),
                      MonthNavigator(
                        displayedMonth: _displayedMonth,
                        onPrevious: _goToPreviousMonth,
                        onNext: _goToNextMonth,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            CalendarGrid(
                              displayedMonth: _displayedMonth,
                              todayDate: DateTime.now(),
                              hijriAdjustment: hijriAdjustment, // ✅ Provider se
                              events: upcomingIslamicEvents,
                            ),
                            const SizedBox(height: 12),
                            const CalendarLegend(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ✅ Provider se adjustment control
                      HijriAdjustmentControl(
                        value: hijriAdjustment,
                        onChanged: (v) => appData.setHijriAdjustment(v),
                      ),
                      const SizedBox(height: 16),
                      const MoonSightingInfoCard(),
                      const SizedBox(height: 24),
                      UpcomingEventsSection(events: upcomingIslamicEvents),
                      const SizedBox(height: 24),
                    ],
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