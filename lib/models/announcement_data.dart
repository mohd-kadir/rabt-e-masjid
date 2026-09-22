import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Announcement category, used for both filtering and the category badge.
enum AnnouncementCategory { general, jumuah, ramadan, events, emergency }

extension AnnouncementCategoryMeta on AnnouncementCategory {
  String get label {
    switch (this) {
      case AnnouncementCategory.general:
        return 'General';
      case AnnouncementCategory.jumuah:
        return "Jumu'ah";
      case AnnouncementCategory.ramadan:
        return 'Ramadan';
      case AnnouncementCategory.events:
        return 'Events';
      case AnnouncementCategory.emergency:
        return 'Emergency';
    }
  }

  IconData get icon {
    switch (this) {
      case AnnouncementCategory.general:
        return Icons.campaign_outlined;
      case AnnouncementCategory.jumuah:
        return Icons.groups_rounded;
      case AnnouncementCategory.ramadan:
        return Icons.nightlight_round;
      case AnnouncementCategory.events:
        return Icons.event_rounded;
      case AnnouncementCategory.emergency:
        return Icons.warning_amber_rounded;
    }
  }

  /// Badge color for this category — kept within the app's deep-green/gold
  /// palette, except Emergency which intentionally stands apart in red
  /// since it needs to read as urgent at a glance.
  Color get badgeColor {
    switch (this) {
      case AnnouncementCategory.general:
        return AppColors.primaryGreen;
      case AnnouncementCategory.jumuah:
        return AppColors.goldMuted;
      case AnnouncementCategory.ramadan:
        return AppColors.primaryGreenLight;
      case AnnouncementCategory.events:
        return AppColors.primaryGreenDark;
      case AnnouncementCategory.emergency:
        return AppColors.warning;
    }
  }
}

/// A single mosque announcement.
class AnnouncementItem {
  final String id;
  final AnnouncementCategory category;
  final String title;
  final String description;
  final String dateLabel;
  final String timeLabel;
  final bool isImportant;
  final bool hasThumbnail;

  /// Longer body text for the detail screen. Falls back to [description]
  /// when not provided.
  final String? fullDescription;

  const AnnouncementItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.dateLabel,
    required this.timeLabel,
    this.isImportant = false,
    this.hasThumbnail = false,
    this.fullDescription,
  });

  String get fullDescriptionOrShort => fullDescription ?? description;
}

/// Mock announcements shown on the Announcements screen, newest first.
final List<AnnouncementItem> mockAnnouncements = [
  const AnnouncementItem(
    id: 'a1',
    category: AnnouncementCategory.jumuah,
    title: "Jumu'ah Prayer Timing",
    description: "Jumu'ah prayer will be held at 1:30 PM.",
    dateLabel: '26 August 2026',
    timeLabel: '10:30 AM',
    isImportant: true,
    fullDescription:
        "Jumu'ah prayer will be held at 1:30 PM this Friday. Please arrive early to secure parking and find a "
        'space, as attendance is expected to be higher than usual. The khutbah will begin promptly at 1:15 PM, '
        'followed by the congregational prayer. Sisters are welcome to use the upstairs prayer hall, and overflow '
        'parking is available at the community center next door.',
  ),
  const AnnouncementItem(
    id: 'a2',
    category: AnnouncementCategory.emergency,
    title: 'Water Supply Interruption',
    description:
        'The masjid water supply will be temporarily interrupted tomorrow morning for maintenance. Please plan wudu accordingly.',
    dateLabel: '26 August 2026',
    timeLabel: '9:05 AM',
    isImportant: true,
    fullDescription:
        'The masjid water supply will be temporarily interrupted tomorrow morning between 6:00 AM and 10:00 AM '
        'for essential maintenance work on the main line. This will affect wudu facilities and washrooms on both '
        'floors. Bottled water will be available at the entrance for those needing to perform wudu during this '
        'window. We apologize for the inconvenience and appreciate your patience as we complete this necessary '
        'repair. Fajr and Dhuhr prayers will proceed as scheduled.',
  ),
  const AnnouncementItem(
    id: 'a3',
    category: AnnouncementCategory.events,
    title: 'Weekend Quran Tafseer Circle',
    description:
        'Join us after Asr for a reflection on Surah Al-Kahf. Open to brothers and sisters, refreshments provided.',
    dateLabel: '25 August 2026',
    timeLabel: '4:45 PM',
    hasThumbnail: true,
  ),
  const AnnouncementItem(
    id: 'a4',
    category: AnnouncementCategory.general,
    title: 'New Wudu Area Now Open',
    description:
        'The renovated wudu area on the ground floor is now open for all congregants.',
    dateLabel: '24 August 2026',
    timeLabel: '2:15 PM',
  ),
  const AnnouncementItem(
    id: 'a5',
    category: AnnouncementCategory.ramadan,
    title: 'Ramadan Planning Committee Meeting',
    description:
        'All volunteers are invited to the planning meeting for this year\'s Ramadan iftar and taraweeh schedule.',
    dateLabel: '23 August 2026',
    timeLabel: '7:30 PM',
    hasThumbnail: true,
  ),
  const AnnouncementItem(
    id: 'a6',
    category: AnnouncementCategory.events,
    title: 'Community Iftar Fundraiser',
    description:
        'A fundraising dinner to support the mosque\'s expansion project. Tickets available at the office.',
    dateLabel: '22 August 2026',
    timeLabel: '6:00 PM',
    hasThumbnail: true,
  ),
  const AnnouncementItem(
    id: 'a7',
    category: AnnouncementCategory.general,
    title: 'Car Park Resurfacing',
    description:
        'The rear car park will be closed for resurfacing work over the coming week.',
    dateLabel: '20 August 2026',
    timeLabel: '11:00 AM',
  ),
  const AnnouncementItem(
    id: 'a8',
    category: AnnouncementCategory.jumuah,
    title: 'Guest Khateeb This Friday',
    description:
        'Sheikh Abdullah Rahman will be delivering this Friday\'s khutbah on the topic of gratitude.',
    dateLabel: '19 August 2026',
    timeLabel: '12:00 PM',
  ),
];
