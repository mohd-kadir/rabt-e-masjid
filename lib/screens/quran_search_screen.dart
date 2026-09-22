import 'package:flutter/material.dart';
import 'package:rabt_e_masjid/screens/quran_reader_screen.dart';
import '../data/quran_page_mapping.dart';
import '../theme/app_colors.dart';
import '../models/mock_data.dart';
import '../models/surah_data.dart';

/// Unified search screen for the Quran section.
/// Searches both Surahs and Paras by:
///   • English name (e.g. "Yaseen", "Sayaqool")
///   • Arabic name (e.g. "يس", "سيقول")
///   • Number (e.g. "36", "2")
class QuranSearchScreen extends StatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  State<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends State<QuranSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _query = '';

  @override
  void initState() {
    super.initState();
    // Auto-focus so the keyboard opens immediately.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // FILTERS
  // ─────────────────────────────────────────────

  List<SurahInfo> get _matchedSurahs {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return allSurahs.where((s) {
      return s.englishName.toLowerCase().contains(q) ||
          s.arabicName.contains(_query.trim()) ||
          s.number.toString() == q ||
          s.number.toString().contains(q);
    }).toList();
  }

  List<ParaInfo> get _matchedParas {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return MockData.paras.where((p) {
      return p.paraName.toLowerCase().contains(q) ||
          p.arabicName.contains(_query.trim()) ||
          p.label.toLowerCase().contains(q) ||
          p.number.toString() == q ||
          p.number.toString().contains(q);
    }).toList();
  }

  bool get _hasQuery => _query.trim().isNotEmpty;

  // ─────────────────────────────────────────────
  // NAVIGATION
  // ─────────────────────────────────────────────

  void _openSurah(SurahInfo surah) {
    final page = getSurahPage(surah.number);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuranReaderScreen(
          surah: surah,
          jumpToPage: page,
          isParaMode: false,
        ),
      ),
    );
  }

  void _openPara(ParaInfo para) {
    final page = getParaPage(para.number);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuranReaderScreen(
          surah: null,
          jumpToPage: page,
          isParaMode: true,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;

    final surahs = _matchedSurahs;
    final paras = _matchedParas;
    final hasResults = surahs.isNotEmpty || paras.isNotEmpty;

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
        title: Text(
          'Search Quran',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ── SEARCH BAR ─────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  horizontalPadding, 8, horizontalPadding, 12),
              child: _buildSearchField(palette),
            ),

            // ── RESULTS ────────────────────────────
            Expanded(
              child: !_hasQuery
                  ? _buildEmptyPrompt(palette)
                  : !hasResults
                  ? _buildNoResults(palette)
                  : ListView(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 0, horizontalPadding, 24),
                children: [
                  if (surahs.isNotEmpty) ...[
                    _sectionHeader(
                        palette, 'Surahs', surahs.length),
                    const SizedBox(height: 8),
                    for (final s in surahs)
                      _SurahResultTile(
                        surah: s,
                        palette: palette,
                        query: _query.trim(),
                        onTap: () => _openSurah(s),
                      ),
                    const SizedBox(height: 20),
                  ],
                  if (paras.isNotEmpty) ...[
                    _sectionHeader(palette, 'Paras', paras.length),
                    const SizedBox(height: 8),
                    for (final p in paras)
                      _ParaResultTile(
                        para: p,
                        palette: palette,
                        query: _query.trim(),
                        onTap: () => _openPara(p),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SEARCH FIELD
  // ─────────────────────────────────────────────

  Widget _buildSearchField(AppPalette palette) {
    return Container(
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        onChanged: (v) => setState(() => _query = v),
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w500,
          color: palette.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search Surah or Para…',
          hintStyle: TextStyle(
            fontSize: 14,
            color: palette.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(Icons.search_rounded,
              size: 22, color: palette.iconInactive),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
            icon: Icon(Icons.close_rounded,
                size: 20, color: palette.iconInactive),
            onPressed: () {
              _controller.clear();
              setState(() => _query = '');
            },
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // EMPTY / NO-RESULTS STATES
  // ─────────────────────────────────────────────

  Widget _buildEmptyPrompt(AppPalette palette) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_rounded,
                  size: 34, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 18),
            Text(
              'Search the Quran',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a Surah name like "Yaseen",\na Para like "Sayaqool", or a number.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: palette.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(AppPalette palette) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 42, color: palette.iconInactive),
            const SizedBox(height: 12),
            Text(
              'No matches for "$_query"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: palette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION HEADER
  // ─────────────────────────────────────────────

  Widget _sectionHeader(AppPalette palette, String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════
// RESULT TILES
// ═══════════════════════════════════════════════════

class _SurahResultTile extends StatelessWidget {
  final SurahInfo surah;
  final AppPalette palette;
  final String query;
  final VoidCallback onTap;

  const _SurahResultTile({
    required this.surah,
    required this.palette,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.divider, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Number badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  surah.numberLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _highlightedText(
                      surah.englishName,
                      query,
                      TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                      palette,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surah.metaLabel,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                surah.arabicName,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: palette.goldMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParaResultTile extends StatelessWidget {
  final ParaInfo para;
  final AppPalette palette;
  final String query;
  final VoidCallback onTap;

  const _ParaResultTile({
    required this.para,
    required this.palette,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.divider, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  para.number.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _highlightedText(
                      para.paraName,
                      query,
                      TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                      palette,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${para.label} • ${para.pageRangeLabel}',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                para.arabicName,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: palette.goldMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════
// HIGHLIGHT HELPER
// ═══════════════════════════════════════════════════

/// Returns a RichText where the matched substring is highlighted.
Widget _highlightedText(
    String text,
    String query,
    TextStyle baseStyle,
    AppPalette palette,
    ) {
  if (query.isEmpty) {
    return Text(text, style: baseStyle);
  }
  final lowerText = text.toLowerCase();
  final lowerQuery = query.toLowerCase();
  final matchIndex = lowerText.indexOf(lowerQuery);

  if (matchIndex < 0) {
    return Text(text, style: baseStyle);
  }

  final before = text.substring(0, matchIndex);
  final match = text.substring(matchIndex, matchIndex + query.length);
  final after = text.substring(matchIndex + query.length);

  return RichText(
    text: TextSpan(
      style: baseStyle,
      children: [
        if (before.isNotEmpty) TextSpan(text: before),
        TextSpan(
          text: match,
          style: baseStyle.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.w800,
            backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
          ),
        ),
        if (after.isNotEmpty) TextSpan(text: after),
      ],
    ),
  );
}