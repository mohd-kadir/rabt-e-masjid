import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/bookmark.dart';
import '../models/surah_data.dart';
import '../services/bookmark_service.dart';
import '../data/quran_page_mapping.dart';
import '../widgets/bookmarks/bookmark_tabs.dart';
import '../widgets/bookmarks/bookmark_search_bar.dart';
import '../widgets/bookmarks/quran_bookmark_card.dart';
import '../widgets/bookmarks/dua_bookmark_card.dart';
import '../widgets/bookmarks/announcement_bookmark_card.dart';
import '../widgets/bookmarks/bookmarks_empty_state.dart';
import 'quran_reader_screen.dart';

/// Bookmarks screen: Quran / Dua / Announcements tabs, search, real
/// persisted data. Tapping a Quran/Surah bookmark opens the reader at
/// the right page.
class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  BookmarkTab _tab = BookmarkTab.quran;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  bool _loading = true;
  List<Bookmark> _all = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await BookmarkService.getAll();
    if (!mounted) return;
    setState(() {
      _all = list;
      _loading = false;
    });
  }

  List<Bookmark> _filter(BookmarkType type) {
    final q = _query.trim().toLowerCase();
    return _all.where((b) {
      if (b.type != type) return false;
      if (q.isEmpty) return true;
      return b.title.toLowerCase().contains(q) ||
          (b.category?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  Future<void> _deleteBookmark(Bookmark b) async {
    await BookmarkService.remove(b.id);
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed "${b.title}"')),
    );
  }

  void _showComingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening "$label" — coming soon')),
    );
  }

  /// Opens the target of a bookmark.
  Future<void> _openBookmark(Bookmark b) async {
    switch (b.type) {
      case BookmarkType.quranPage:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuranReaderScreen(
              surah: null,
              jumpToPage: b.pageNumber,
              isParaMode: true,
            ),
          ),
        );
        if (mounted) _load();
        break;

      case BookmarkType.surah:
        final surah = allSurahs.firstWhere(
              (s) => s.number == b.surahNumber,
          orElse: () => allSurahs.first,
        );
        final page = b.pageNumber ?? getSurahPage(surah.number);
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => QuranReaderScreen(
              surah: surah,
              jumpToPage: page,
              isParaMode: false,
            ),
          ),
        );
        if (mounted) _load();
        break;

      case BookmarkType.dua:
        _showComingSoon(context, b.title);
        break;

      case BookmarkType.announcement:
        _showComingSoon(context, b.title);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final hasQuery = _query.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 19, color: palette.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Text(
          'Bookmarks',
          style: TextStyle(
              fontSize: 17, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
        actions: [
          if (_all.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  size: 20, color: palette.textSecondary),
              tooltip: 'Clear all',
              onPressed: _confirmClear,
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _loading
            ? Center(child: CircularProgressIndicator(color: palette.goldMuted))
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 8, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookmarkTabs(
                      selected: _tab,
                      onChanged: (t) => setState(() => _tab = t),
                    ),
                    const SizedBox(height: 12),
                    BookmarkSearchBar(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
            ),
            _buildTabContent(context, horizontalPadding, hasQuery),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
      BuildContext context, double horizontalPadding, bool hasQuery) {
    switch (_tab) {
      case BookmarkTab.quran:
        final results = _filter(BookmarkType.quranPage);
        if (results.isEmpty) {
          return SliverToBoxAdapter(
              child: BookmarksEmptyState(isSearchResult: hasQuery));
        }
        return SliverPadding(
          padding:
          EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
          sliver: SliverList.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => Dismissible(
              key: ValueKey(results[i].id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              onDismissed: (_) => _deleteBookmark(results[i]),
              child: QuranBookmarkCard(
                bookmark: results[i],
                onTap: () => _openBookmark(results[i]),
              ),
            ),
          ),
        );

      case BookmarkTab.dua:
        final results = _filter(BookmarkType.dua);
        if (results.isEmpty) {
          return SliverToBoxAdapter(
              child: BookmarksEmptyState(isSearchResult: hasQuery));
        }
        return SliverPadding(
          padding:
          EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
          sliver: SliverList.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => Dismissible(
              key: ValueKey(results[i].id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              onDismissed: (_) => _deleteBookmark(results[i]),
              child: DuaBookmarkCard(
                bookmark: results[i],
                onTap: () => _openBookmark(results[i]),
              ),
            ),
          ),
        );

      case BookmarkTab.announcements:
        final results = _filter(BookmarkType.announcement);
        if (results.isEmpty) {
          return SliverToBoxAdapter(
              child: BookmarksEmptyState(isSearchResult: hasQuery));
        }
        return SliverPadding(
          padding:
          EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
          sliver: SliverList.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => Dismissible(
              key: ValueKey(results[i].id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              onDismissed: (_) => _deleteBookmark(results[i]),
              child: AnnouncementBookmarkCard(
                bookmark: results[i],
                onTap: () => _openBookmark(results[i]),
              ),
            ),
          ),
        );
    }
  }

  Future<void> _confirmClear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear all bookmarks?'),
        content: const Text('This will permanently remove all your bookmarks.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Clear')),
        ],
      ),
    );
    if (ok == true) {
      await BookmarkService.clearAll();
      await _load();
    }
  }
}