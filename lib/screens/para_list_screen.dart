import 'package:flutter/material.dart';
import 'package:rabt_e_masjid/screens/quran_reader_screen.dart';
import '../data/quran_page_mapping.dart';
import '../models/surah_data.dart';
import '../theme/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/quran/para_search_bar.dart';
import '../widgets/quran/para_card.dart';

/// Full Para (Juz) list screen for the Quran section — searchable,
/// theme-aware (light/dark), with a staggered entrance for the list.
/// UI only, backed by mock data.
class ParaListScreen extends StatefulWidget {
  const ParaListScreen({super.key});

  @override
  State<ParaListScreen> createState() => _ParaListScreenState();
}

class _ParaListScreenState extends State<ParaListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ParaInfo> get _filteredParas {
    if (_query.trim().isEmpty) return MockData.paras;
    final q = _query.trim().toLowerCase();
    return MockData.paras.where((p) {
      return p.label.toLowerCase().contains(q) ||
          p.number.toString().contains(q) ||
          p.paraName.toLowerCase().contains(q) ||
          p.arabicName.contains(_query.trim());
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() => _query = value);
  }

  void _openPara(ParaInfo para) {
    final page = getParaPage(para.number);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuranReaderScreen(
          surah: null,  // No surah
          jumpToPage: page,
          isParaMode: true,  // IMPORTANT: Para mode
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final results = _filteredParas;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 19, color: palette.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Quran - Para',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '30 Paras',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'أجزاء القرآن الكريم',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: palette.goldMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ParaSearchBar(controller: _searchController, onChanged: _onSearchChanged),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (results.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 40, color: palette.iconInactive),
                      const SizedBox(height: 12),
                      Text(
                        'No Para matches "$_query"',
                        style: TextStyle(fontSize: 13.5, color: palette.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverList.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final para = results[index];
                    return _StaggeredEntry(
                      index: index,
                      child: ParaCard(para: para, onTap: () => _openPara(para)),
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

/// Lightweight per-item fade + slide-in used for the list's entrance,
/// staggered by [index] but capped so long lists don't feel sluggish.
class _StaggeredEntry extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredEntry({required this.index, required this.child});

  @override
  State<_StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<_StaggeredEntry> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(_fade);

    final delayMs = (widget.index * 30).clamp(0, 300);
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