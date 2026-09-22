import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/app_data_provider.dart';
import '../utils/prayer_utils.dart';
import '../widgets/home/current_prayer_card.dart';
import '../widgets/home/section_title.dart';
import '../widgets/prayer_times/prayer_times_header.dart';
import '../widgets/prayer_times/prayer_time_card.dart';
import '../widgets/prayer_times/jumuah_card.dart';
import '../models/mock_data.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late List<bool> _notificationsEnabled;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _notificationsEnabled = List<bool>.filled(5, true);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppDataProvider>(context);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;

    final prayerEntries = _buildPrayerEntries(appData);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  14,
                  horizontalPadding,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrayerTimesHeader(
                      hijriDate: appData.hijriDate,
                      masjidName: MockData.masjidName,
                      location: MockData.locationLabel,
                    ),
                    const SizedBox(height: 20),

                    if (appData.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (appData.errorMessage != null)
                      _buildErrorWidget(appData)
                    else ...[
                        // ✅ Current Prayer Card
                        CurrentPrayerCard(
                          currentPrayerName: PrayerUtils.getCurrentPrayerName(
                            appData.prayerTimes,
                          ),
                          startTime: PrayerUtils.formatTo12Hour(
                            PrayerUtils.getCurrentPrayerTime(appData.prayerTimes),
                          ),
                          endTime: PrayerUtils.formatTo12Hour(
                            PrayerUtils.getNextPrayerTime(appData.prayerTimes),
                          ),
                          remainingTime: PrayerUtils.getRemainingTime(
                            appData.prayerTimes,
                          ),
                          progress: PrayerUtils.getCurrentPrayerProgress(
                            appData.prayerTimes,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const SectionTitle(
                          title: "Today's Prayers",
                          icon: Icons.wb_sunny_rounded,
                        ),
                        const SizedBox(height: 12),

                        for (int i = 0; i < prayerEntries.length; i++) ...[
                          PrayerTimeCard(
                            prayer: prayerEntries[i],
                            notificationsEnabled: _notificationsEnabled[i],
                            onNotificationChanged: (v) => setState(() {
                              _notificationsEnabled[i] = v;
                            }),
                          ),
                          if (i != prayerEntries.length - 1)
                            const SizedBox(height: 10),
                        ],

                        const SizedBox(height: 24),
                        const JumuahCard(),
                        const SizedBox(height: 28),
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

  Widget _buildErrorWidget(AppDataProvider appData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Error: ${appData.errorMessage}',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => appData.refreshData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<PrayerEntry> _buildPrayerEntries(AppDataProvider appData) {
    final times = appData.prayerTimes;
    if (times == null) return MockData.detailedPrayers;

    final prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final icons = [
      Icons.nights_stay_outlined,
      Icons.wb_sunny_outlined,
      Icons.wb_twilight_outlined,
      Icons.dark_mode_outlined,
      Icons.bedtime_outlined,
    ];

    // ✅ Get current prayer
    final currentPrayerName = PrayerUtils.getCurrentPrayerName(times);

    return List.generate(5, (index) {
      final name = prayerNames[index];
      return PrayerEntry(
        name: name,
        icon: icons[index],
        azanTime: times[name] ?? '--:--',
        jamaatTime: _adjustForJamaat(times[name] ?? '--:--', 5),
        isCurrent: name == currentPrayerName,
      );
    });
  }

  String _adjustForJamaat(String time, int minutesToAdd) {
    try {
      final parts = time.split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      minute += minutesToAdd;
      if (minute >= 60) {
        minute -= 60;
        hour += 1;
      }

      final suffix = parts.length > 1 ? parts[1] : 'AM';
      if (hour >= 12) {
        final adjustedHour = hour > 12 ? hour - 12 : hour;
        return '${adjustedHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} PM';
      }
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $suffix';
    } catch (e) {
      return time;
    }
  }
}