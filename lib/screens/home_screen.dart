import 'package:flutter/material.dart';
import 'package:rabt_e_masjid/screens/more_menu_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/home/app_bottom_nav.dart';
import 'dashboard_screen.dart';
import 'prayer_times_screen.dart';
import 'quran_screen.dart';
import 'tasbeeh_screen.dart';

/// App shell after the splash screen: hosts the bottom navigation bar
/// and swaps between the Home Dashboard and the other (placeholder) tabs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<String> _placeholderTitles = [
    'Home',
    'Quran',
    'Prayer',
    'Tasbeeh',
    'More',
  ];

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: _currentIndex == 0
            ? const DashboardScreen(key: ValueKey('dashboard'))
            : _currentIndex == 1
            ? const QuranScreen(key: ValueKey('quran'))
            : _currentIndex == 2
            ? const PrayerTimesScreen(key: ValueKey('prayer-times'))
            : _currentIndex == 3
            ? const TasbeehScreen(key: ValueKey('tasbeeh'))
            :_currentIndex == 4
            ? const MoreMenuScreen(key: ValueKey('more'),)
            : _PlaceholderTab(
          key: ValueKey('placeholder-$_currentIndex'),
          title: _placeholderTitles[_currentIndex],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// Simple placeholder for tabs other than Home, so the shell is fully
/// navigable. Replace each with its real screen when ready.
class _PlaceholderTab extends StatelessWidget {
  final String title;
  const _PlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.construction_rounded, size: 48, color: AppColors.gold),
              const SizedBox(height: 14),
              Text(
                '$title — Coming Soon',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'This section is under construction.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}