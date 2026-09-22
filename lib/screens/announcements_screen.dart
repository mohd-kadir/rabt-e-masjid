import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/announcement_data.dart';
import '../widgets/announcements/announcement_filter_chips.dart';
import '../widgets/announcements/announcement_card.dart';
import '../widgets/announcements/announcements_empty_state.dart';
import '../widgets/announcements/announcements_loading_state.dart';
import 'announcement_detail_screen.dart';

/// Announcements screen: mosque-wide notices with category filtering,
/// search, pull-to-refresh, and loading/empty states. Important
/// announcements are visually distinguished but stay within the app's
/// elegant, restrained card language. Theme-aware, UI only, mock data.
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  AnnouncementCategory? _selectedCategory; // null = All
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate an initial network fetch.
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Simulate re-fetching announcements from the server.
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) setState(() {}); // mock data is static, just re-render
  }

  List<AnnouncementItem> get _filtered {
    Iterable<AnnouncementItem> list = mockAnnouncements;

    if (_selectedCategory != null) {
      list = list.where((a) => a.category == _selectedCategory);
    }

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where(
        (a) =>
            a.title.toLowerCase().contains(q) ||
            a.description.toLowerCase().contains(q),
      );
    }

    return list.toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _query = '';
      }
    });
  }

  void _openAnnouncement(AnnouncementItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AnnouncementDetailScreen(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final results = _filtered;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                style: TextStyle(
                  fontSize: 15,
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search announcements...',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: palette.textSecondary,
                  ),
                  border: InputBorder.none,
                ),
              )
            : Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              size: 22,
              color: AppColors.primaryGreen,
            ),
            onPressed: _toggleSearch,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primaryGreen,
          backgroundColor: palette.cardSurface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    12,
                  ),
                  child: AnnouncementFilterChips(
                    selected: _selectedCategory,
                    onChanged: (c) => setState(() => _selectedCategory = c),
                  ),
                ),
              ),
              if (_isLoading)
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    24,
                  ),
                  sliver: const SliverToBoxAdapter(
                    child: AnnouncementsLoadingState(),
                  ),
                )
              else if (results.isEmpty)
                SliverToBoxAdapter(
                  child: AnnouncementsEmptyState(query: _query),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    24,
                  ),
                  sliver: SliverList.separated(
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return AnnouncementCard(
                        item: item,
                        onTap: () => _openAnnouncement(item),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
