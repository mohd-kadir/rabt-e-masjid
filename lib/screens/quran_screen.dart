import 'package:flutter/material.dart';
import 'package:rabt_e_masjid/screens/bookmarks_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/home/section_title.dart';
import '../widgets/quran/quran_header.dart';
import '../widgets/quran/quran_hero_card.dart';
import '../widgets/quran/continue_reading_card.dart';
import '../widgets/quran/read_by_feature_cards.dart';
import '../widgets/quran/quran_additional_options.dart';
import '../models/surah_data.dart';
import '../models/quran_progress_state.dart';   // <-- ADD
import 'para_list_screen.dart';
import 'surah_list_screen.dart';
import 'quran_reader_screen.dart';
import 'quran_search_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Widget _animated({required int index, required Widget child}) {
    final start = (index * 0.08).clamp(0.0, 0.7);
    final end = (start + 0.35).clamp(0.0, 1.0);
    final curved = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position:
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
            .animate(curved),
        child: child,
      ),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — coming soon')),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const QuranSearchScreen()),
    );
  }

  /// Naya helper: jahan last read chhoda tha wahi open karo
  void _openLastRead(BuildContext context) {
    final progress = QuranProgressState.getCurrentProgress();

    // Agar abhi tak koi progress nahi hai to Para mode page 1 se shuru
    final page = progress?.pageNumber;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuranReaderScreen(
          surah: null,
          isParaMode: true,
          jumpToPage: page,
        ),
      ),
    ).then((_) {
      // Reader se wapas aane par ContinueReadingCard ko refresh karna ho
      // to setState call kar sakte ho (agar state listen kar raha ho).
      if (mounted) setState(() {});
    });
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 14, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _animated(
                      index: 0,
                      child: QuranHeader(
                        onSearchTap: () => _openSearch(context),
                        onBookmarkTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BookmarksScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _animated(
                      index: 2,
                      child: ContinueReadingCard(
                        onContinue: () => _openLastRead(context),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _animated(
                      index: 3,
                      child: const SectionTitle(
                          title: 'Explore', icon: Icons.grid_view_rounded),
                    ),
                    const SizedBox(height: 12),
                    _animated(
                      index: 4,
                      child: ReadByFeatureCards(
                        onParaTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const ParaListScreen()),
                        ),
                        onSurahTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const SurahListScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _animated(
                      index: 5,
                      child: const SectionTitle(
                          title: 'More', icon: Icons.apps_rounded),
                    ),
                    const SizedBox(height: 12),
                    _animated(
                      index: 6,
                      child: QuranAdditionalOptions(
                        onTap: (label) {
                          if (label == 'Bookmarks') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const BookmarksScreen()),
                            );
                          } else if (label == 'Last Read') {
                            _openLastRead(context);
                          } else if (label == 'Search Quran'){
                            _openSearch(context);
                          } else {
                            _showComingSoon(context, label);
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