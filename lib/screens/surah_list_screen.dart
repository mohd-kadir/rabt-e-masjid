import 'package:flutter/material.dart';
import 'package:rabt_e_masjid/screens/quran_reader_screen.dart';
import '../data/quran_page_mapping.dart';
import '../theme/app_colors.dart';
import '../models/mock_data.dart';
import '../models/surah_data.dart';
import '../models/bookmark.dart';
import '../services/bookmark_service.dart';
import '../widgets/quran/surah_search_and_filter.dart';
import '../widgets/quran/surah_card.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  SurahFilter _filter = SurahFilter.all;

  Set<int> _favourites = {};

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavourites() async {
    final list = await BookmarkService.getByType(BookmarkType.surah);
    if (!mounted) return;
    setState(() {
      _favourites = list
          .where((b) => b.surahNumber != null)
          .map((b) => b.surahNumber!)
          .toSet();
    });
  }

  List<SurahInfo> get _filteredSurahs {
    Iterable<SurahInfo> list = allSurahs;

    if (_filter == SurahFilter.meccan) {
      list = list.where((s) => s.revelationType == RevelationType.meccan);
    } else if (_filter == SurahFilter.medinan) {
      list = list.where((s) => s.revelationType == RevelationType.medinan);
    } else if (_filter == SurahFilter.favourites) {
      list = list.where((s) => _favourites.contains(s.number));
    }

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((s) {
        return s.englishName.toLowerCase().contains(q) ||
            s.number.toString().contains(q) ||
            s.arabicName.contains(_query.trim());
      });
    }
    return list.toList();
  }

  Future<void> _toggleFavourite(int surahNumber, bool value) async {
    final surah = allSurahs.firstWhere((s) => s.number == surahNumber);
    final bookmark = Bookmark(
      id: 'surah_$surahNumber',
      type: BookmarkType.surah,
      title: surah.englishName,
      arabicName: surah.arabicName,
      preview: surah.metaLabel,
      surahNumber: surahNumber,
      pageNumber: getSurahPage(surahNumber),
      savedAt: DateTime.now(),
    );
    await BookmarkService.toggle(bookmark);
    if (!mounted) return;
    setState(() {
      if (value) {
        _favourites.add(surahNumber);
      } else {
        _favourites.remove(surahNumber);
      }
    });
  }

  void _openSurah(SurahInfo surah) {
    final page = getSurahPage(surah.number);
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => QuranReaderScreen(
          surah: surah,
          jumpToPage: page,
          isParaMode: false,
        ),
      ),
    )
        .then((_) => _loadFavourites());
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final results = _filteredSurahs;
    final continueReadingName = MockData.quranProgress.paraName;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 19, color: palette.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Surahs',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary)),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 8, horizontalPadding, 16),
                child: SurahSearchAndFilter(
                  controller: _searchController,
                  onSearchChanged: (v) => setState(() => _query = v),
                  selectedFilter: _filter,
                  onFilterChanged: (f) => setState(() => _filter = f),
                ),
              ),
            ),
            if (results.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Icon(
                        _filter == SurahFilter.favourites
                            ? Icons.favorite_border_rounded
                            : Icons.search_off_rounded,
                        size: 40,
                        color: palette.iconInactive,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _filter == SurahFilter.favourites
                            ? 'No favourite Surahs yet'
                            : 'No Surah matches your search',
                        style: TextStyle(
                            fontSize: 13.5,
                            color: palette.textSecondary,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverList.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final surah = results[index];
                    return _StaggeredEntry(
                      index: index,
                      child: SurahCard(
                        surah: surah,
                        isFavourite: _favourites.contains(surah.number),
                        isContinueReading:
                        surah.englishName == continueReadingName,
                        onFavouriteChanged: (v) =>
                            _toggleFavourite(surah.number, v),
                        onTap: () => _openSurah(surah),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredEntry extends StatefulWidget {
  final int index;
  final Widget child;
  const _StaggeredEntry({required this.index, required this.child});

  @override
  State<_StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<_StaggeredEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
        begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(_fade);
    final delayMs = (widget.index * 18).clamp(0, 220);
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}