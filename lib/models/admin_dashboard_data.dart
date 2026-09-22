import 'package:flutter/material.dart';

/// Publication status for an announcement, as seen by an admin
/// (distinct from the public-facing AnnouncementItem, which has no
/// notion of draft/scheduled state).
enum AnnouncementStatus { published, scheduled, draft }

extension AnnouncementStatusMeta on AnnouncementStatus {
  String get label {
    switch (this) {
      case AnnouncementStatus.published:
        return 'Published';
      case AnnouncementStatus.scheduled:
        return 'Scheduled';
      case AnnouncementStatus.draft:
        return 'Draft';
    }
  }
}

/// A single upcoming mosque-organized event.
class MosqueEvent {
  final String title;
  final String dateLabel;
  final String timeLabel;
  final String location;
  final int attendeeCount;
  final IconData icon;

  const MosqueEvent({
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    required this.location,
    required this.attendeeCount,
    required this.icon,
  });
}

/// Mock publication status for each announcement (keyed by
/// [AnnouncementItem.id]), used only on the Admin Dashboard's Recent
/// Announcements list — the public-facing screen has no notion of this.
const Map<String, AnnouncementStatus> mockAnnouncementStatus = {
  'a1': AnnouncementStatus.published,
  'a2': AnnouncementStatus.published,
  'a3': AnnouncementStatus.published,
  'a4': AnnouncementStatus.published,
  'a5': AnnouncementStatus.scheduled,
  'a6': AnnouncementStatus.draft,
  'a7': AnnouncementStatus.published,
  'a8': AnnouncementStatus.scheduled,
};

/// Mock admin dashboard statistics.
class AdminStats {
  AdminStats._();

  static const int totalUsers = 1284;
  static const int announcementsCount = 8;
  static const int upcomingEventsCount = 3;
  static const int prayerUpdatesCount = 2;
}

/// Mock upcoming events shown on the Admin Dashboard.
const List<MosqueEvent> mockUpcomingEvents = [
  MosqueEvent(
    title: 'Community Iftar Fundraiser',
    dateLabel: '22 August 2026',
    timeLabel: '6:00 PM',
    location: 'Main Hall',
    attendeeCount: 84,
    icon: Icons.event_rounded,
  ),
  MosqueEvent(
    title: 'Weekend Quran Tafseer Circle',
    dateLabel: '25 August 2026',
    timeLabel: '4:45 PM',
    location: 'Library Room',
    attendeeCount: 32,
    icon: Icons.menu_book_rounded,
  ),
  MosqueEvent(
    title: 'Ramadan Planning Committee Meeting',
    dateLabel: '23 August 2026',
    timeLabel: '7:30 PM',
    location: 'Admin Office',
    attendeeCount: 12,
    icon: Icons.groups_rounded,
  ),
];