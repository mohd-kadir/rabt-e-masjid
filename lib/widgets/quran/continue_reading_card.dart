import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/mock_data.dart';
import '../../models/quran_progress_state.dart';

class ContinueReadingCard extends StatefulWidget {
  final VoidCallback? onContinue;

  const ContinueReadingCard({super.key, this.onContinue});

  @override
  State<ContinueReadingCard> createState() => _ContinueReadingCardState();
}

class _ContinueReadingCardState extends State<ContinueReadingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _progressAnim;

  QuranProgress? _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _loadData();
  }

  /// Progress reload karke animation dobara chalao.
  void _loadData() {
    // Always read the Para progress — never the Surah one.
    _progress = QuranProgressState.getCurrentProgress();

    final double initialProgress = _progress?.progress ?? 0.0;
    _progressAnim = Tween<double>(begin: 0, end: initialProgress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller
      ..reset()
      ..forward();
  }

  /// Jab bhi user reader se wapas aaye, parent rebuild karega
  /// aur ye dependencies change hone par progress refresh ho jayega.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sirf tab reload karo jab pehle se init ho chuka ho
    if (_controller.isAnimating || _controller.isCompleted || _progress != null) {
      // ignore: invalid_use_of_protected_member
      _loadData();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final progress = _progress;

    // No progress yet — show placeholder.
    if (progress == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: palette.cardSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.divider, width: 1),
          boxShadow: [
            BoxShadow(
              color: palette.shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.menu_book_rounded,
                      size: 22, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Continue Reading',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: palette.goldMuted,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Start your daily Quran recitation',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onContinue,
                icon: const Icon(Icons.play_arrow_rounded, size: 19),
                label: const Text('Start Reading',
                    style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Progress available — always show Para info.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.menu_book_rounded,
                    size: 22, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continue Reading',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: palette.goldMuted,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          progress.paraName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          progress.paraArabicName,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: palette.goldMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MetaChip(
                icon: Icons.menu_book_outlined,
                label: 'Para ${progress.lastPara} of ${progress.totalPara}',
                palette: palette,
              ),
              const SizedBox(width: 10),
              _MetaChip(
                icon: Icons.bookmark_outline_rounded,
                label: 'Page ${progress.pageNumber}',
                palette: palette,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AnimatedBuilder(
              animation: _progressAnim,
              builder: (context, _) => LinearProgressIndicator(
                value: _progressAnim.value,
                minHeight: 7,
                backgroundColor: palette.divider,
                valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.gold),
              ),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: _progressAnim,
            builder: (context, _) => Text(
              '${(_progressAnim.value * 100).round()}% completed',
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: palette.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onContinue,
              icon: const Icon(Icons.play_arrow_rounded, size: 19),
              label: const Text('Continue',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppPalette palette;

  const _MetaChip(
      {required this.icon, required this.label, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.cardSurfaceAlt,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: palette.goldMuted),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: palette.textSecondary),
          ),
        ],
      ),
    );
  }
}