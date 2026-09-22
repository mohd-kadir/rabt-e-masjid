import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../theme/app_colors.dart';
import '../models/surah_data.dart';
import '../widgets/quran_reader/reader_bottom_bar.dart';
import '../services/quran_pdf_service.dart';
import '../models/quran_progress_state.dart';
import '../models/bookmark.dart';
import '../services/bookmark_service.dart';

class QuranReaderScreen extends StatefulWidget {
  final SurahInfo? surah;
  final int? jumpToPage;
  final bool isParaMode;

  const QuranReaderScreen({
    super.key,
    this.surah,
    this.jumpToPage,
    this.isParaMode = true,
  });

  @override
  State<QuranReaderScreen> createState() => _QuranReaderScreenState();
}

class _QuranReaderScreenState extends State<QuranReaderScreen> {
  final PdfViewerController _pdfController = PdfViewerController();

  int _currentPage = 1;
  int _totalPages = 847;

  bool _isLoading = true;
  bool _isBookmarked = false;

  double _dragStartX = 0;
  bool _isDragging = false;

  AppPalette get _palette => AppColors.lightPalette;

  @override
  void initState() {
    super.initState();
    _loadBookmarkState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  // =========================================================
  // BOOKMARK STATE
  // =========================================================

  Future<void> _loadBookmarkState() async {
    final id = 'quranPage_$_currentPage';
    final isB = await BookmarkService.isBookmarked(id);
    if (!mounted) return;
    setState(() => _isBookmarked = isB);
  }

  // =========================================================
  // PROGRESS
  // =========================================================

  void _updateProgress(int page) {
    // Always remember the mode so "Continue" opens the right view.
    QuranPdfService.saveLastReadMode(widget.isParaMode);

    if (widget.isParaMode) {
      // ── PARA MODE ─────────────────────────────────────
      // Only Para reading updates the Continue Reading card.
      final paraInfo = QuranProgressState.getParaFromPage(page);
      if (paraInfo != null) {
        final progress = (page - paraInfo.startPage) /
            (paraInfo.endPage - paraInfo.startPage + 1);
        QuranProgressState.saveProgress(
          page: page,
          paraNumber: paraInfo.number,
          paraArabicName: paraInfo.arabicName,
          paraName: paraInfo.paraName,
          progress: progress.clamp(0.0, 1.0),
        );
      }
      QuranPdfService.saveLastParaPage(page);
    } else {
      // ── SURAH MODE ────────────────────────────────────
      // Only save the surah page for "resume where you left".
      // Continue Reading card is NOT touched here.
      QuranPdfService.saveLastSurahPage(page);
    }
  }

  // =========================================================
  // INITIAL PAGE
  // =========================================================

  Future<void> _jumpToInitialPage() async {
    int targetPage = 1;

    if (widget.jumpToPage != null && widget.jumpToPage! > 0) {
      targetPage = widget.jumpToPage!;
    } else {
      if (widget.isParaMode) {
        targetPage = await QuranPdfService.getLastParaPage();
      } else {
        targetPage = await QuranPdfService.getLastSurahPage();
      }
    }

    if (!mounted) return;

    if (targetPage >= 1 && targetPage <= _totalPages) {
      _pdfController.jumpToPage(targetPage);
      setState(() => _currentPage = targetPage);
      _loadBookmarkState();
    }
  }

  // =========================================================
  // PAGE NAVIGATION
  // =========================================================

  void _goToPage(int page) {
    if (page < 1 || page > _totalPages) return;

    _pdfController.jumpToPage(page);
    setState(() => _currentPage = page);

    if (widget.isParaMode) {
      QuranPdfService.saveLastParaPage(page);
    } else {
      QuranPdfService.saveLastSurahPage(page);
    }

    _loadBookmarkState();
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) _goToPage(_currentPage + 1);
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) _goToPage(_currentPage - 1);
  }

  // =========================================================
  // BOOKMARK TOGGLE
  // =========================================================

  Future<void> _toggleBookmark() async {
    final para = QuranProgressState.getParaFromPage(_currentPage);
    final title = widget.isParaMode
        ? (para?.paraName ?? 'Para')
        : (widget.surah?.englishName ?? 'Surah');
    final arabic = widget.isParaMode
        ? (para?.arabicName)
        : (widget.surah?.arabicName);

    final bookmark = Bookmark(
      id: 'quranPage_$_currentPage',
      type: BookmarkType.quranPage,
      title: '$title — Page $_currentPage',
      arabicName: arabic,
      preview: null,
      pageNumber: _currentPage,
      surahNumber: widget.surah?.number,
      savedAt: DateTime.now(),
    );

    final nowBookmarked = await BookmarkService.toggle(bookmark);
    if (!mounted) return;
    setState(() => _isBookmarked = nowBookmarked);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(nowBookmarked
            ? 'Page $_currentPage bookmarked'
            : 'Bookmark removed'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // =========================================================
  // PAGE JUMP DIALOG
  // =========================================================

  void _showPageJumpDialog() {
    final controller = TextEditingController(text: _currentPage.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Go to Page',
            style: TextStyle(
              color: _palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter page number',
              filled: true,
              fillColor: _palette.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: TextStyle(color: Colors.grey.shade600)),
            ),
            ElevatedButton(
              onPressed: () {
                final page = int.tryParse(controller.text);
                Navigator.pop(context);
                if (page != null) _goToPage(page);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  Widget _buildHeader() {
    return Container(
      color: _palette.background,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: _palette.textPrimary),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                'Al-Quran',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: _palette.textPrimary,
                  letterSpacing: .1,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              size: 24,
              color: _isBookmarked ? AppColors.gold : _palette.textPrimary,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded,
                size: 25, color: _palette.textPrimary),
            onPressed: _showPageJumpDialog,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFO BAR
  // =========================================================

  Widget _buildReaderInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black.withOpacity(.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _infoItem(
              icon: Icons.menu_book_rounded,
              title: widget.isParaMode ? 'Para' : 'Surah',
              value: 'Reading',
            ),
          ),
          Container(height: 34, width: 1, color: Colors.grey.shade200),
          Expanded(
            child: _infoItem(
              icon: Icons.auto_stories_rounded,
              title: 'Page',
              value: '$_currentPage',
            ),
          ),
          Container(height: 34, width: 1, color: Colors.grey.shade200),
          Expanded(
            child: _infoItem(
              icon: Icons.library_books_outlined,
              title: 'Total',
              value: '$_totalPages',
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return InkWell(
      onTap: _showPageJumpDialog,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: Colors.green),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: _palette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PDF VIEWER
  // =========================================================

  Widget _buildPdfViewer() {
    return AspectRatio(
      aspectRatio: 0.73,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: const BoxDecoration(color: Colors.white),
        clipBehavior: Clip.antiAlias,
        child: Listener(
          onPointerDown: (PointerDownEvent event) {
            _dragStartX = event.position.dx;
            _isDragging = true;
          },
          onPointerUp: (PointerUpEvent event) {
            if (!_isDragging) return;
            _isDragging = false;
            final dragEndX = event.position.dx;
            final dragDistance = dragEndX - _dragStartX;
            const swipeThreshold = 50.0;
            if (dragDistance > swipeThreshold) {
              _goToNextPage();
            } else if (dragDistance < -swipeThreshold) {
              _goToPreviousPage();
            }
          },
          child: SfPdfViewer.asset(
            'assets/quran/quran.pdf',
            controller: _pdfController,
            scrollDirection: PdfScrollDirection.horizontal,
            pageLayoutMode: PdfPageLayoutMode.single,
            pageSpacing: 0,
            canShowScrollHead: false,
            canShowScrollStatus: false,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              if (!mounted) return;
              setState(() {
                _totalPages = details.document.pages.count;
                _isLoading = false;
              });
              _jumpToInitialPage();
            },
            onPageChanged: (PdfPageChangedDetails details) {
              if (!mounted) return;
              setState(() => _currentPage = details.newPageNumber);
              _updateProgress(details.newPageNumber);
              _loadBookmarkState();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      color: _palette.background,
      child: const Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _palette.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildReaderInfo(),
            Expanded(
              child: Stack(
                children: [
                  _buildPdfViewer(),
                  if (_isLoading) _buildLoading(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ReaderBottomBar(
        currentPage: _currentPage,
        totalPages: _totalPages,
        palette: _palette,
        onPrevious: _goToNextPage,
        onNext: _goToPreviousPage,
      ),
    );
  }
}