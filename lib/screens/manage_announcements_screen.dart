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

/// Manage Announcements screen for the Admin Panel: search, All /
/// Published / Draft / Important filters, edit/delete per card (with a
/// confirmation dialog before deleting), and a FAB to add a new one.
/// Theme-aware, responsive, UI only — deletions are local State only
/// and reset when the screen is left.
class ManageAnnouncementsScreen extends StatefulWidget {
  const ManageAnnouncementsScreen({super.key});

  @override
  State<ManageAnnouncementsScreen> createState() => _ManageAnnouncementsScreenState();
}

class _ManageAnnouncementsScreenState extends State<ManageAnnouncementsScreen> {
  late List<AnnouncementItem> _announcements;
  late Map<String, AnnouncementStatus> _statusById;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  ManageFilter _filter = ManageFilter.all;

  @override
  void initState() {
    super.initState();
    _announcements = List.of(mockAnnouncements);
    _statusById = Map.of(mockAnnouncementStatus);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AnnouncementStatus _statusFor(AnnouncementItem item) =>
      _statusById[item.id] ?? AnnouncementStatus.published;

  List<AnnouncementItem> get _filtered {
    Iterable<AnnouncementItem> list = _announcements;

    switch (_filter) {
      case ManageFilter.all:
        break;
      case ManageFilter.published:
        list = list.where((a) => _statusFor(a) == AnnouncementStatus.published);
        break;
      case ManageFilter.draft:
        list = list.where((a) => _statusFor(a) == AnnouncementStatus.draft);
        break;
      case ManageFilter.important:
        list = list.where((a) => a.isImportant);
        break;
    }

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((a) => a.title.toLowerCase().contains(q));
    }

    return list.toList();
  }

  Future<void> _handleDelete(AnnouncementItem item) async {
    final confirmed = await DeleteConfirmationDialog.show(context, title: item.title);
    if (!confirmed) return;

    setState(() {
      _announcements.removeWhere((a) => a.id == item.id);
      _statusById.remove(item.id);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${item.title}" deleted')),
    );
  }

  void _handleEdit(AnnouncementItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editing "${item.title}" — coming soon')),
    );
  }

  void _handleAdd() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddAnnouncementScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final results = _filtered;
    final isFiltered = _query.trim().isNotEmpty || _filter != ManageFilter.all;

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
          'Manage Announcements',
          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ManageSearchBar(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    const SizedBox(height: 12),
                    ManageFilterChips(
                      selected: _filter,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                  ],
                ),
              ),
            ),
            if (results.isEmpty)
              SliverToBoxAdapter(child:ManageEmptyState(isFiltered: isFiltered)
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 90),
                sliver: SliverList.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return ManageAnnouncementCard(
                      item: item,
                      status: _statusFor(item),
                      onEdit: () => _handleEdit(item),
                      onDelete: () => _handleDelete(item),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAdd,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Announcement', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}