import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/app_colors.dart';
import '../models/announcement_data.dart';
import '../models/admin_dashboard_data.dart';

import '../widgets/home/section_title.dart';
import '../widgets/admin_dashboard/admin_header.dart';
import '../widgets/admin_dashboard/admin_stats_grid.dart';
import '../widgets/admin_dashboard/admin_quick_actions.dart';
import '../widgets/admin_dashboard/admin_announcement_row.dart';
import '../widgets/admin_dashboard/admin_prayer_timing_preview.dart';
import 'masjid_info_screen.dart';
import 'announcement_detail_screen.dart';
import 'add_announcement_screen.dart';
import 'manage_announcements_screen.dart';
import 'admin_prayer_timing_screen.dart';
import 'admin_masjid_settings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final String masjidId;
  final String adminName;

  const AdminDashboardScreen({
    super.key,
    required this.masjidId,
    required this.adminName,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // ------------------------------------------------------------
  // SHOW COMING SOON MESSAGE
  // ------------------------------------------------------------

  void _comingSoon(BuildContext context, String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label — coming soon')));
  }

  // ------------------------------------------------------------
  // QUICK ACTION HANDLER
  // ------------------------------------------------------------

  void _handleQuickAction(BuildContext context, AdminQuickAction action) {
    switch (action.label) {
      case 'Add Announcement':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddAnnouncementScreen()),
        );
        break;

      case 'Prayer Timings':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AdminPrayerTimingScreen()),
        );
        break;

      case 'Manage Announcements':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ManageAnnouncementsScreen()),
        );
        break;

      case 'Masjid Information':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MasjidInfoScreen()));
        break;

      default:
        _comingSoon(context, action.label);
    }
  }

  // ------------------------------------------------------------
  // FIRESTORE ANNOUNCEMENT → AnnouncementItem
  // ------------------------------------------------------------

  AnnouncementItem _announcementFromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    // -----------------------------
    // CATEGORY
    // -----------------------------

    AnnouncementCategory category = AnnouncementCategory.general;

    final categoryString = data['category']?.toString();

    for (final item in AnnouncementCategory.values) {
      if (item.name == categoryString) {
        category = item;
        break;
      }
    }

    // -----------------------------
    // DATE
    // -----------------------------

    String dateLabel = '';

    final dateValue = data['date'];

    if (dateValue is Timestamp) {
      final date = dateValue.toDate();

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      dateLabel = '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    // -----------------------------
    // TIME
    // -----------------------------

    final timeLabel = data['time']?.toString() ?? '';

    // -----------------------------
    // TITLE
    // -----------------------------

    final title = data['title']?.toString() ?? '';

    // -----------------------------
    // DESCRIPTION
    // -----------------------------

    final description = data['message']?.toString() ?? '';

    // -----------------------------
    // IMPORTANT
    // -----------------------------

    final isImportant = data['isImportant'] == true;

    // -----------------------------
    // CREATE MODEL
    // -----------------------------

    return AnnouncementItem(
      id: doc.id,
      category: category,
      title: title,
      description: description,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      isImportant: isImportant,
      hasThumbnail: false,
      fullDescription: description,
    );
  }

  // ------------------------------------------------------------
  // ANNOUNCEMENT STATUS
  // ------------------------------------------------------------

  AnnouncementStatus _getAnnouncementStatus(Map<String, dynamic> data) {
    final isActive = data['isActive'] == true;

    if (isActive) {
      return AnnouncementStatus.published;
    }

    return AnnouncementStatus.draft;
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final size = MediaQuery.of(context).size;

    final isTablet = size.width >= 600;

    final horizontalPadding = isTablet ? size.width * 0.08 : 18.0;

    // ----------------------------------------------------------
    // FIRESTORE QUERY
    // ----------------------------------------------------------

    final announcementStream = FirebaseFirestore.instance
        .collection('announcements')
        .where('masjidId', isEqualTo: widget.masjidId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(4)
        .snapshots();

    return Scaffold(
      backgroundColor: palette.background,

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ==================================================
            // TOP CONTENT
            // ==================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  14,
                  horizontalPadding,
                  0,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ==================================================
                    // ADMIN HEADER
                    // ==================================================
                    AdminHeader(
                      masjidId: widget.masjidId,

                      adminName: widget.adminName,

                      onProfileTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AdminMasjidSettingsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // ==================================================
                    // STATS
                    // ==================================================
                    AdminStatsGrid(
                      masjidId: widget.masjidId,
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // QUICK ACTIONS
                    // ==================================================
                    const SectionTitle(
                      title: 'Quick Actions',
                      icon: Icons.bolt_rounded,
                    ),

                    const SizedBox(height: 12),

                    AdminQuickActions(
                      onTap: (action) {
                        _handleQuickAction(context, action);
                      },
                    ),

                    const SizedBox(height: 24),

                    // ==================================================
                    // RECENT ANNOUNCEMENTS HEADER
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const SectionTitle(
                          title: 'Recent Announcements',
                          icon: Icons.campaign_rounded,
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ManageAnnouncementsScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            'Manage',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // ==================================================
                    // FIRESTORE ANNOUNCEMENTS
                    // ==================================================
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: announcementStream,

                      builder: (context, snapshot) {
                        // ------------------------------------------
                        // LOADING
                        // ------------------------------------------

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),

                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        // ------------------------------------------
                        // ERROR
                        // ------------------------------------------

                        if (snapshot.hasError) {
                          return Container(
                            width: double.infinity,

                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: palette.cardSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: palette.divider),
                            ),

                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline_rounded,
                                  size: 32,
                                  color: AppColors.warning,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  'Unable to load announcements',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: palette.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  '${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // ------------------------------------------
                        // EMPTY
                        // ------------------------------------------

                        final docs = snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return Container(
                            width: double.infinity,

                            padding: const EdgeInsets.symmetric(
                              vertical: 30,
                              horizontal: 20,
                            ),

                            decoration: BoxDecoration(
                              color: palette.cardSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: palette.divider),
                            ),

                            child: Column(
                              children: [
                                Icon(
                                  Icons.campaign_outlined,
                                  size: 38,
                                  color: palette.textSecondary,
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  'No announcements yet',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: palette.textPrimary,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Published announcements will appear here.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // ------------------------------------------
                        // SHOW ANNOUNCEMENTS
                        // ------------------------------------------

                        return Column(
                          children: [
                            for (final doc in docs) ...[
                              Builder(
                                builder: (context) {
                                  final item = _announcementFromFirestore(doc);

                                  final status = _getAnnouncementStatus(
                                    doc.data(),
                                  );

                                  return AdminAnnouncementRow(
                                    item: item,

                                    status: status,

                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              AnnouncementDetailScreen(
                                                item: item,
                                              ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                              const SizedBox(height: 10),
                            ],
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // PRAYER TIMINGS
                    // ==================================================
                    const SectionTitle(
                      title: 'Prayer Timing',
                      icon: Icons.access_time_outlined,
                    ),

                    const SizedBox(height: 10),

                    AdminPrayerTimingPreview(
                      masjidId: widget.masjidId,

                      onEdit: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AdminPrayerTimingScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
