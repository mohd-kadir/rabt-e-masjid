import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/home/section_title.dart';
import '../widgets/ramadan/ramadan_header.dart';
import '../widgets/ramadan/iftar_countdown_card.dart';
import '../widgets/ramadan/ramadan_times_row.dart';
import '../widgets/ramadan/ramadan_progress_card.dart';
import '../widgets/ramadan/ramadan_quick_actions.dart';
import '../widgets/ramadan/daily_dua_card.dart';
import '../widgets/ramadan/quran_progress_card.dart';
import 'quran_screen.dart';
import 'dua_azkar_screen.dart';
import 'tasbeeh_screen.dart';
import 'para_list_screen.dart';

/// Dedicated Ramadan Dashboard: greeting + Hijri date + day counter,
/// Time Until Iftar countdown, Sehri/Iftar/Taraweeh times, days-completed
/// progress, quick actions, a daily dua, and Quran khatm progress.
/// UI only, mock data.
class RamadanScreen extends StatefulWidget {
  const RamadanScreen({super.key});

  @override
  State<RamadanScreen> createState() => _RamadanScreenState();
}

class _RamadanScreenState extends State<RamadanScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Widget _animated({required int index, required Widget child}) {
    final start = (index * 0.07).clamp(0.0, 0.7);
    final end = (start + 0.35).clamp(0.0, 1.0);
    final curved = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }

  void _onQuickAction(RamadanQuickAction action) {
    switch (action.label) {
      case 'Quran':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuranScreen()));
        break;
      case 'Dua':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DuaAzkarScreen()));
        break;
      case 'Tasbeeh':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TasbeehScreen()));
        break;
      case 'Zakat':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zakat calculator — coming soon')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animated(index: 0, child: const RamadanHeader()),
              const SizedBox(height: 20),
              _animated(index: 1, child: const IftarCountdownCard()),
              const SizedBox(height: 16),
              _animated(index: 2, child: const RamadanTimesRow()),
              const SizedBox(height: 20),
              _animated(index: 3, child: const RamadanProgressCard()),
              const SizedBox(height: 24),
              _animated(
                index: 4,
                child: const SectionTitle(title: 'Quick Actions', icon: Icons.grid_view_rounded),
              ),
              const SizedBox(height: 12),
              _animated(index: 5, child: RamadanQuickActionsRow(onTap: _onQuickAction)),
              const SizedBox(height: 24),
              _animated(index: 6, child: const DailyDuaCard()),
              const SizedBox(height: 16),
              _animated(
                index: 7,
                child: QuranProgressCard(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ParaListScreen()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}