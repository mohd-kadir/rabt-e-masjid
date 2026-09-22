import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/announcement_data.dart';

/// Full detail view for a single announcement. Typography is deliberately
/// generous — large title, roomy line height on the body text — since
/// this is where the person actually reads the notice, not just scans it.
/// UI only, mock data; share is a placeholder (no share package wired).
class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementItem item;

  const AnnouncementDetailScreen({super.key, required this.item});

  void _share(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share sheet would open here')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.12 : 20.0;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: palette.textPrimary,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Announcement',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              size: 21,
              color: AppColors.primaryGreen,
            ),
            onPressed: () => _share(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CategoryBadge(category: item.category),
                  if (item.isImportant) ...[
                    const SizedBox(width: 8),
                    const _ImportantBadge(),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: palette.goldMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.dateLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.goldMuted,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: palette.goldMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.timeLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.goldMuted,
                    ),
                  ),
                ],
              ),
              if (item.hasThumbnail) ...[
                const SizedBox(height: 20),
                _PosterBanner(category: item.category),
              ],
              const SizedBox(height: 22),
              if (item.isImportant) ...[
                _ImportantNotice(palette: palette),
                const SizedBox(height: 18),
              ],
              Text(
                item.fullDescriptionOrShort,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400,
                  color: palette.textPrimary,
                  height: 1.75,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _share(context),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text(
                    'Share Announcement',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PosterBanner extends StatelessWidget {
  final AnnouncementCategory category;
  const _PosterBanner({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        gradient: AppColors.nextPrayerGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreenDark.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          category.icon,
          size: 56,
          color: AppColors.goldLight.withOpacity(0.9),
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final AnnouncementCategory category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: category.badgeColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 13, color: category.badgeColor),
          const SizedBox(width: 5),
          Text(
            category.label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: category.badgeColor,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportantBadge extends StatelessWidget {
  const _ImportantBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.warning.withOpacity(0.35)),
      ),
      child: const Text(
        'IMPORTANT',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.warning,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _ImportantNotice extends StatelessWidget {
  final AppPalette palette;
  const _ImportantNotice({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.priority_high_rounded,
            size: 18,
            color: AppColors.warning,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This is an important notice from the mosque administration.',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
