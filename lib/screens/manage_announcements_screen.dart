import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/announcement_data.dart';
import '../models/admin_dashboard_data.dart';
import '../widgets/manage_announcements/manage_search_bar.dart';
import '../widgets/manage_announcements/manage_filter_chips.dart';
import '../widgets/manage_announcements/manage_announcement_card.dart';
import '../widgets/manage_announcements/delete_confirmation_dialog.dart';
import '../widgets/manage_announcements/manage_empty_state.dart';
import 'add_announcement_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManageAnnouncementsScreen extends StatefulWidget {
  const ManageAnnouncementsScreen({super.key});

  @override
  State<ManageAnnouncementsScreen> createState() =>
      _ManageAnnouncementsScreenState();
}

class _ManageAnnouncementsScreenState
    extends State<ManageAnnouncementsScreen> {
  late List<AnnouncementItem> _announcements;
  late Map<String, AnnouncementStatus> _statusById;

  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  ManageFilter _filter = ManageFilter.all;

  @override
  void initState() {
    super.initState();

    _announcements = [];
    _statusById = {};

    _loadAnnouncements();
  }

  // --------------------------------------------------
  // Format Firestore Date
  // --------------------------------------------------

  String _formatDate(dynamic value) {
    if (value == null) return '';

    if (value is Timestamp) {
      final date = value.toDate();

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    return value.toString();
  }

  // --------------------------------------------------
  // Format Firestore Time
  // --------------------------------------------------

  String _formatTime(dynamic value) {
    if (value == null) return '';

    if (value is Timestamp) {
      final date = value.toDate();

      final hour = date.hour > 12
          ? date.hour - 12
          : (date.hour == 0 ? 12 : date.hour);

      final minute = date.minute.toString().padLeft(2, '0');

      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    }

    return value.toString();
  }

  // --------------------------------------------------
  // Load Announcements
  // --------------------------------------------------

  Future<void> _loadAnnouncements() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      // Get current admin
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) return;

      final adminData = adminDoc.data();

      if (adminData == null) return;

      final masjidId = adminData['masjidId'];

      if (masjidId == null) return;

      // Get announcements for this masjid
      final snapshot = await FirebaseFirestore.instance
          .collection('announcements')
          .where('masjidId', isEqualTo: masjidId)
          .orderBy('createdAt', descending: true)
          .get();

      final List<AnnouncementItem> loadedAnnouncements = [];
      final Map<String, AnnouncementStatus> loadedStatuses = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();

        final categoryString =
            data['category']?.toString() ?? 'general';

        AnnouncementCategory category;

        switch (categoryString) {
          case 'jumuah':
            category = AnnouncementCategory.jumuah;
            break;

          case 'ramadan':
            category = AnnouncementCategory.ramadan;
            break;

          case 'events':
            category = AnnouncementCategory.events;
            break;

          case 'emergency':
            category = AnnouncementCategory.emergency;
            break;

          default:
            category = AnnouncementCategory.general;
        }

        final isActive = data['isActive'] ?? true;

        loadedAnnouncements.add(
          AnnouncementItem(
            id: doc.id,
            category: category,
            title: data['title']?.toString() ?? '',
            description: data['message']?.toString() ?? '',
            dateLabel: _formatDate(data['date']),
            timeLabel: _formatTime(data['time']),
            isImportant: data['isImportant'] ?? false,
            hasThumbnail: false,
            fullDescription: data['message']?.toString(),
          ),
        );

        loadedStatuses[doc.id] = isActive
            ? AnnouncementStatus.published
            : AnnouncementStatus.draft;
      }

      if (!mounted) return;

      setState(() {
        _announcements = loadedAnnouncements;
        _statusById = loadedStatuses;
      });
    } catch (e) {
      debugPrint('Error loading announcements: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load announcements: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------
  // Status
  // --------------------------------------------------

  AnnouncementStatus _statusFor(AnnouncementItem item) {
    return _statusById[item.id] ??
        AnnouncementStatus.published;
  }

  // --------------------------------------------------
  // Search + Filter
  // --------------------------------------------------

  List<AnnouncementItem> get _filtered {
    Iterable<AnnouncementItem> list = _announcements;

    switch (_filter) {
      case ManageFilter.all:
        break;

      case ManageFilter.published:
        list = list.where(
              (a) =>
          _statusFor(a) == AnnouncementStatus.published,
        );
        break;

      case ManageFilter.draft:
        list = list.where(
              (a) => _statusFor(a) == AnnouncementStatus.draft,
        );
        break;

      case ManageFilter.important:
        list = list.where((a) => a.isImportant);
        break;
    }

    final q = _query.trim().toLowerCase();

    if (q.isNotEmpty) {
      list = list.where(
            (a) => a.title.toLowerCase().contains(q),
      );
    }

    return list.toList();
  }

  // --------------------------------------------------
  // DELETE
  // --------------------------------------------------

  Future<void> _handleDelete(AnnouncementItem item) async {
    final confirmed =
    await DeleteConfirmationDialog.show(
      context,
      title: item.title,
    );

    if (!confirmed) return;

    try {
      await FirebaseFirestore.instance
          .collection('announcements')
          .doc(item.id)
          .delete();

      if (!mounted) return;

      setState(() {
        _announcements.removeWhere(
              (a) => a.id == item.id,
        );

        _statusById.remove(item.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${item.title}" deleted successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete announcement: $e',
          ),
        ),
      );
    }
  }

  // --------------------------------------------------
  // EDIT
  // --------------------------------------------------

  Future<void> _handleEdit(AnnouncementItem item) async {
    final updated = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddAnnouncementScreen(
          announcementId: item.id,
        ),
      ),
    );

    // If edit screen saved successfully,
    // reload announcements from Firebase.
    if (updated == true && mounted) {
      await _loadAnnouncements();
    }
  }

  // --------------------------------------------------
  // ADD
  // --------------------------------------------------

  void _handleAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddAnnouncementScreen(),
      ),
    );
  }

  // --------------------------------------------------
  // BUILD
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final size = MediaQuery.of(context).size;

    final isTablet = size.width >= 600;

    final horizontalPadding =
    isTablet ? size.width * 0.1 : 18.0;

    final results = _filtered;

    final isFiltered =
        _query.trim().isNotEmpty ||
            _filter != ManageFilter.all;

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
          onPressed: () =>
              Navigator.of(context).maybePop(),
        ),

        title: Text(
          'Manage Announcements',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: CustomScrollView(
          slivers: [

            // Search + Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  12,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    ManageSearchBar(
                      controller: _searchController,
                      onChanged: (v) {
                        setState(() {
                          _query = v;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    ManageFilterChips(
                      selected: _filter,
                      onChanged: (f) {
                        setState(() {
                          _filter = f;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Empty state
            if (results.isEmpty)
              SliverToBoxAdapter(
                child: ManageEmptyState(
                  isFiltered: isFiltered,
                ),
              )

            // Announcement list
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  90,
                ),

                sliver: SliverList.separated(
                  itemCount: results.length,

                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),

                  itemBuilder: (context, index) {
                    final item = results[index];

                    return ManageAnnouncementCard(
                      item: item,
                      status: _statusFor(item),

                      onEdit: () =>
                          _handleEdit(item),

                      onDelete: () =>
                          _handleDelete(item),
                    );
                  },
                ),
              ),
          ],
        ),
      ),

      // Add Announcement
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: _handleAdd,

        backgroundColor:
        AppColors.primaryGreen,

        foregroundColor: Colors.white,

        icon: const Icon(
          Icons.add_rounded,
        ),

        label: const Text(
          'Add Announcement',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}