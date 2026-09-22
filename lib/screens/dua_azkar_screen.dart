import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/dua_data.dart';
import '../models/bookmark.dart';
import '../services/bookmark_service.dart';
import '../widgets/islamic_pattern_painter.dart';
import '../widgets/home/section_title.dart';
import '../widgets/dua/dua_search_bar.dart';
import '../widgets/dua/favorites_section.dart';
import '../widgets/dua/dua_category_grid.dart';
import 'dua_detail_screen.dart';

/// Dua & Azkar screen: search, a Favourites shelf, and a grid of the
/// eight Dua/Azkar categories. A very faint Islamic geometric pattern
/// sits behind the content for a calm, spiritual feel without
/// competing with the cards. UI only, mock data.
class DuaAzkarScreen extends StatefulWidget {
  const DuaAzkarScreen({super.key});

  @override
  State<DuaAzkarScreen> createState() => _DuaAzkarScreenState();
}

class _DuaAzkarScreenState extends State<DuaAzkarScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  List<Bookmark> _favourites = [];

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
    final list = await BookmarkService.getByType(BookmarkType.dua);
    if (!mounted) return;
    setState(() => _favourites = list);
  }

  List<DuaCategory> get _filteredCategories {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return duaCategories;
    return duaCategories
        .where((c) =>
    c.name.toLowerCase().contains(q) ||
        c.description.toLowerCase().contains(q))
        .toList();
  }

  void _openCategory(DuaCategory category) {
    final categoryName = category.name;
    final duas = mockDuaEntriesByCategory[categoryName] ?? [];

    if (duas.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DuaDetailScreen(
            duas: duas,
            initialIndex: 0,
          ),
        ),
      ).then((_) => _loadFavourites());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Duas available in ${category.name} yet')),
      );
    }
  }

  void _openFavourite(Bookmark fav) {
    // Bookmark ki id se original DuaEntry ka id nikaalo: 'dua_<id>' -> '<id>'
    final duaId = fav.id.startsWith('dua_') ? fav.id.substring(4) : fav.id;

    final categoryName = fav.category ?? '';
    final duas = mockDuaEntriesByCategory[categoryName] ?? [];
    final index = duas.indexWhere((d) => d.id == duaId);

    if (duas.isNotEmpty && index != -1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DuaDetailScreen(
            duas: duas,
            initialIndex: index,
          ),
        ),
      ).then((_) => _loadFavourites());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dua not found in mock data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final results = _filteredCategories;

    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          // Very subtle background pattern for a calm, spiritual feel.
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.4,
                child:
                CustomPaint(painter: IslamicPatternPainter(progress: 0.2)),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        horizontalPadding, 14, horizontalPadding, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dua & Azkar',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'أذكار وأدعية',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: palette.goldMuted),
                        ),
                        const SizedBox(height: 18),
                        DuaSearchBar(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                        ),
                        const SizedBox(height: 24),
                        const SectionTitle(
                            title: 'Favourites',
                            icon: Icons.favorite_rounded),
                        const SizedBox(height: 12),
                        FavoritesSection(
                          favourites: _favourites,
                          onTap: _openFavourite,
                        ),
                        const SizedBox(height: 24),
                        const SectionTitle(
                            title: 'Categories',
                            icon: Icons.grid_view_rounded),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                if (results.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 38, color: palette.iconInactive),
                          const SizedBox(height: 12),
                          Text(
                            'No category matches "$_query"',
                            style: TextStyle(
                                fontSize: 13,
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
                        horizontalPadding, 0, horizontalPadding, 28),
                    sliver: SliverToBoxAdapter(
                      child: DuaCategoryGrid(
                          categories: results, onCategoryTap: _openCategory),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}