import 'package:flutter/material.dart';

/// Notification category, used for both tab filtering and the icon shown.
enum NotificationCategory { prayer, announcement }

extension NotificationCategoryMeta on NotificationCategory {
  IconData get icon {
    switch (this) {
      case NotificationCategory.prayer:
        return Icons.mosque_rounded;
      case NotificationCategory.announcement:
        return Icons.campaign_rounded;
    }
  }
}

/// A single notification entry.
class NotificationItem {
  final String id;
  final NotificationCategory category;
  final String title;
  final String message;
  final String timeAgo;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.timeAgo,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      category: category,
      title: title,
      message: message,
      timeAgo: timeAgo,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Mock notifications, newest first.
final List<NotificationItem> mockNotifications = [
  const NotificationItem(
    id: 'n1',
    category: NotificationCategory.prayer,
    title: 'Fajr Azan',
    message: 'Fajr prayer time is approaching.',
    timeAgo: '5 min ago',
    isRead: false,
  ),
  const NotificationItem(
    id: 'n2',
    category: NotificationCategory.announcement,
    title: 'New Announcement',
    message: "Jumu'ah timing has been updated.",
    timeAgo: '1 hour ago',
    isRead: false,
  ),
  const NotificationItem(
    id: 'n3',
    category: NotificationCategory.prayer,
    title: 'Maghrib Reminder',
    message: 'Maghrib prayer is at 6:42 PM.',
    timeAgo: '2 hours ago',
    isRead: false,
  ),
  const NotificationItem(
    id: 'n4',
    category: NotificationCategory.prayer,
    title: 'Dhuhr Azan',
    message: 'Dhuhr prayer time is approaching.',
    timeAgo: '6 hours ago',
    isRead: true,
  ),
  const NotificationItem(
    id: 'n5',
    category: NotificationCategory.announcement,
    title: 'Water Supply Interruption',
    message:
        'The masjid water supply will be temporarily interrupted tomorrow morning.',
    timeAgo: 'Yesterday',
    isRead: true,
  ),
  const NotificationItem(
    id: 'n6',
    category: NotificationCategory.prayer,
    title: 'Isha Azan',
    message: 'Isha prayer time is approaching.',
    timeAgo: 'Yesterday',
    isRead: true,
  ),
];
