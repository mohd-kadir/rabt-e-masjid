import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/notification_data.dart';
import '../widgets/notifications/notification_tabs.dart';
import '../widgets/notifications/notification_card.dart';
import '../widgets/notifications/notifications_empty_state.dart';

/// Notifications screen: All / Prayer / Announcements tabs, "Mark all
/// as read", swipe-to-delete cards with a subtle unread highlight, and
/// an empty state. Theme-aware, UI only, mock data (local state only —
/// resets when the screen is left).
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _notifications;
  NotificationTab _tab = NotificationTab.all;

  @override
  void initState() {
    super.initState();
    _notifications = List.of(mockNotifications);
  }

  List<NotificationItem> get _filtered {
    final category = categoryForTab(_tab);
    if (category == null) return _notifications;
    return _notifications.where((n) => n.category == category).toList();
  }

  bool get _hasUnread => _notifications.any((n) => !n.isRead);

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
  }

  void _markAsRead(NotificationItem item) {
    if (item.isRead) return;
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == item.id);
      if (index != -1) _notifications[index] = _notifications[index].copyWith(isRead: true);
    });
  }

  void _delete(NotificationItem item) {
    setState(() {
      _notifications.removeWhere((n) => n.id == item.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${item.title}" removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final results = _filtered;

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
          'Notifications',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: _hasUnread ? _markAllAsRead : null,
            child: Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: _hasUnread ? AppColors.primaryGreen : palette.iconInactive,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 14),
                child: NotificationTabs(
                  selected: _tab,
                  onChanged: (t) => setState(() => _tab = t),
                ),
              ),
            ),
            if (results.isEmpty)
              const SliverToBoxAdapter(child: NotificationsEmptyState())
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverList.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return NotificationCard(
                      item: item,
                      onTap: () => _markAsRead(item),
                      onDelete: () => _delete(item),
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