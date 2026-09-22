import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/announcement_data.dart';
import '../models/admin_dashboard_data.dart';
import '../widgets/home/section_title.dart';
import '../widgets/admin_dashboard/admin_header.dart';
import '../widgets/admin_dashboard/admin_stats_grid.dart';
import '../widgets/admin_dashboard/admin_quick_actions.dart';
import '../widgets/admin_dashboard/admin_announcement_row.dart';
import '../widgets/admin_dashboard/admin_event_card.dart';
import 'masjid_info_screen.dart';
import 'announcement_detail_screen.dart';
import 'add_announcement_screen.dart';
import 'manage_announcements_screen.dart';
import 'admin_prayer_timing_screen.dart';
import 'admin_masjid_settings_screen.dart';

/// Professional Admin Dashboard for mosque administrators: statistics,
/// quick actions, recent announcements with publication status, and
/// upcoming events. Theme-aware, responsive, UI only — no backend.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — coming soon')),
    );
  }

  void _handleQuickAction(BuildContext context, AdminQuickAction action) {
    switch (action.label) {
      case 'Add Announcement':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddAnnouncementScreen()));
        break;
      case 'Prayer Timings':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminPrayerTimingScreen()));
        break;
      case 'Manage Announcements':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ManageAnnouncementsScreen()));
        break;
      case 'Masjid Information':
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MasjidInfoScreen()));
        break;
      default:
        _comingSoon(context, action.label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.08 : 18.0;

    // Most recent 4 announcements for the admin list.
    final recentAnnouncements = mockAnnouncements.take(4).toList();

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminHeader(
                      onProfileTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AdminMasjidSettingsScreen()),
                      ),
                      onNotificationTap: () => _comingSoon(context, 'Admin Notifications'),
                    ),
                    const SizedBox(height: 20),
                    const AdminStatsGrid(),
                    const SizedBox(height: 24),

                    const SectionTitle(title: 'Quick Actions', icon: Icons.bolt_rounded),
                    const SizedBox(height: 12),
                    AdminQuickActions(
                      onTap: (action) => _handleQuickAction(context, action),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionTitle(title: 'Recent Announcements', icon: Icons.campaign_rounded),
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ManageAnnouncementsScreen()),
                          ),
                          child: const Text(
                            'Manage',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    for (final item in recentAnnouncements) ...[
                      AdminAnnouncementRow(
                        item: item,
                        status: mockAnnouncementStatus[item.id] ?? AnnouncementStatus.published,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AnnouncementDetailScreen(item: item)),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 14),

                    const SectionTitle(title: 'Upcoming Events', icon: Icons.event_rounded),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  itemCount: mockUpcomingEvents.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final event = mockUpcomingEvents[index];
                    return AdminEventCard(
                      event: event,
                      onTap: () => _comingSoon(context, event.title),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}