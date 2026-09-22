import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../models/dua_data.dart';
import '../models/bookmark.dart';
import '../services/bookmark_service.dart';

/// Full detail view for a single Dua/Zikr — large, highly readable
/// Arabic text, transliteration, English translation, and a
/// Quran/Hadith reference. Supports previous/next navigation within
/// the same category and a dedicated dark reading mode (independent
/// of the app's system theme, matching the Quran Reader screen).
/// UI only, mock data.
class DuaDetailScreen extends StatefulWidget {
  final List<DuaEntry> duas;
  final int initialIndex;

  const DuaDetailScreen({super.key, required this.duas, this.initialIndex = 0});

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  late int _index;
  bool _isFavourite = false;
  bool _isDarkReadingMode = false;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.duas.length - 1);
    _loadFavourite();
  }

  DuaEntry get _current => widget.duas[_index];
  AppPalette get _palette =>
      _isDarkReadingMode ? AppColors.darkPalette : AppColors.lightPalette;

  String get _favouriteId => 'dua_${_current.id}';

  Future<void> _loadFavourite() async {
    final isFav = await BookmarkService.isBookmarked(_favouriteId);
    if (!mounted) return;
    setState(() => _isFavourite = isFav);
  }

  void _goPrevious() {
    if (_index > 0) {
      setState(() => _index--);
      _loadFavourite();
    }
  }

  void _goNext() {
    if (_index < widget.duas.length - 1) {
      setState(() => _index++);
      _loadFavourite();
    }
  }

  Future<void> _toggleFavourite() async {
    final dua = _current;
    final bookmark = Bookmark(
      id: _favouriteId,
      type: BookmarkType.dua,
      title: dua.title,
      arabicName: dua.categoryName,
      preview: dua.arabic,
      category: dua.categoryName,
      savedAt: DateTime.now(),
    );
    final nowFav = await BookmarkService.toggle(bookmark);
    if (!mounted) return;
    setState(() => _isFavourite = nowFav);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowFav
            ? 'Added "${dua.title}" to favourites'
            : 'Removed "${dua.title}" from favourites'),
      ),
    );
  }

  void _share() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share sheet would open here')),
    );
  }

  void _copy() {
    final dua = _current;
    final text =
        '${dua.title}\n\n${dua.arabic}\n\n${dua.transliteration}\n\n${dua.translation}\n\n— ${dua.reference}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette;
    final dua = _current;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.14 : 22.0;
    final hasPrevious = _index > 0;
    final hasNext = _index < widget.duas.length - 1;

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
          dua.categoryName,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavourite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: 21,
              color: _isFavourite ? Colors.redAccent : palette.textPrimary,
            ),
            onPressed: _toggleFavourite,
          ),
          IconButton(
            icon: Icon(Icons.share_outlined,
                size: 20, color: palette.textPrimary),
            onPressed: _share,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 12, horizontalPadding, 20),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Column(
                    key: ValueKey(dua.id),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dua.title,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: palette.textPrimary,
                                height: 1.3,
                              ),
                            ),
                          ),
                          _ReadingModeToggle(
                            isDark: _isDarkReadingMode,
                            onChanged: (v) =>
                                setState(() => _isDarkReadingMode = v),
                            palette: palette,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Arabic — the visual priority of the screen.
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 24),
                        child: Text(
                          dua.arabic,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: palette.textPrimary,
                            height: 2.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(color: palette.divider, thickness: 1),
                      const SizedBox(height: 24),

                      _SectionLabel(
                          text: 'TRANSLITERATION', palette: palette),
                      const SizedBox(height: 10),
                      Text(
                        dua.transliteration,
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          color: palette.goldMuted,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 28),

                      _SectionLabel(text: 'TRANSLATION', palette: palette),
                      const SizedBox(height: 10),
                      Text(
                        dua.translation,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w400,
                          color: palette.textPrimary,
                          height: 1.75,
                        ),
                      ),
                      const SizedBox(height: 28),

                      _SectionLabel(text: 'REFERENCE', palette: palette),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: palette.cardSurfaceAlt,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book_outlined,
                                size: 16, color: AppColors.primaryGreen),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                dua.reference,
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: palette.textPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Previous / Next navigation.
            Padding(
              padding:
              EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 10),
              child: Row(
                children: [
                  Expanded(
                    child: _NavButton(
                      label: 'Previous',
                      icon: Icons.chevron_left_rounded,
                      alignLeft: true,
                      enabled: hasPrevious,
                      onTap: _goPrevious,
                      palette: palette,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _NavButton(
                      label: 'Next',
                      icon: Icons.chevron_right_rounded,
                      alignLeft: false,
                      enabled: hasNext,
                      onTap: _goNext,
                      palette: palette,
                    ),
                  ),
                ],
              ),
            ),

            // Favourite / Share / Copy.
            Padding(
              padding:
              EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: _isFavourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      label: 'Favourite',
                      onTap: _toggleFavourite,
                      palette: palette,
                      highlighted: _isFavourite,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                        icon: Icons.share_outlined,
                        label: 'Share',
                        onTap: _share,
                        palette: palette),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                        icon: Icons.copy_rounded,
                        label: 'Copy',
                        onTap: _copy,
                        palette: palette),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final AppPalette palette;
  const _SectionLabel({required this.text, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: palette.goldMuted,
          letterSpacing: 1.0),
    );
  }
}

class _ReadingModeToggle extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;
  final AppPalette palette;

  const _ReadingModeToggle(
      {required this.isDark, required this.onChanged, required this.palette});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isDark),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: palette.cardSurfaceAlt,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          size: 18,
          color: AppColors.goldMuted,
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool alignLeft;
  final bool enabled;
  final VoidCallback onTap;
  final AppPalette palette;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.alignLeft,
    required this.enabled,
    required this.onTap,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      if (alignLeft)
        Icon(icon,
            size: 18,
            color: enabled ? AppColors.primaryGreen : palette.iconInactive),
      if (alignLeft) const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: enabled ? palette.textPrimary : palette.iconInactive,
        ),
      ),
      if (!alignLeft) const SizedBox(width: 4),
      if (!alignLeft)
        Icon(icon,
            size: 18,
            color: enabled ? AppColors.primaryGreen : palette.iconInactive),
    ];

    return Material(
      color: palette.cardSurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: palette.divider, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final AppPalette palette;
  final bool highlighted;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.palette,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted ? AppColors.primaryGreen : palette.cardSurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border:
            highlighted ? null : Border.all(color: palette.divider, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 18,
                  color: highlighted ? Colors.white : AppColors.primaryGreen),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: highlighted ? Colors.white : palette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}