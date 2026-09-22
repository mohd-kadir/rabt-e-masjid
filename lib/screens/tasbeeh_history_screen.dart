import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/zikr_data.dart';
import '../models/tasbeeh_session.dart';
import '../services/tasbeeh_storage_service.dart';
import '../widgets/tasbeeh_history/history_summary_cards.dart';
import '../widgets/tasbeeh_history/history_progress_section.dart';
import '../widgets/tasbeeh_history/history_filter_chips.dart';
import '../widgets/tasbeeh_history/history_day_group.dart';

/// Tasbeeh History screen: summary cards (Today/Week/Month), a simple
/// visual progress chart of recent activity, Today/Week/Month filtering,
/// and a day-grouped log of past Zikr sessions. Data comes from
/// TasbeehStorageService (SharedPreferences).
class TasbeehHistoryScreen extends StatefulWidget {
  const TasbeehHistoryScreen({super.key});

  @override
  State<TasbeehHistoryScreen> createState() => _TasbeehHistoryScreenState();
}

class _TasbeehHistoryScreenState extends State<TasbeehHistoryScreen> {
  HistoryFilter _filter = HistoryFilter.month;
  bool _loading = true;
  List<TasbeehSession> _allSessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _loading = true);
    final sessions = await TasbeehStorageService.getAllSessions();
    if (!mounted) return;
    setState(() {
      _allSessions = sessions;
      _loading = false;
    });
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  int _sumWithin(int days) {
    return _allSessions.where((s) {
      final d = DateTime(s.timestamp.year, s.timestamp.month, s.timestamp.day);
      final diff = _today.difference(d).inDays;
      return diff >= 0 && diff <= days;
    }).fold(0, (sum, s) => sum + s.count);
  }

  int get _todayCount => _sumWithin(0);
  int get _weekCount => _sumWithin(6);
  int get _monthCount => _sumWithin(29);

  List<TasbeehSession> get _filteredSessions {
    final maxDays = switch (_filter) {
      HistoryFilter.today => 0,
      HistoryFilter.week => 6,
      HistoryFilter.month => 29,
    };
    return _allSessions.where((s) {
      final d = DateTime(s.timestamp.year, s.timestamp.month, s.timestamp.day);
      final diff = _today.difference(d).inDays;
      return diff >= 0 && diff <= maxDays;
    }).toList();
  }

  /// Groups filtered sessions into day-wise logs (newest first).
  List<DailyZikrLog> get _groupedLogs {
    final sessions = _filteredSessions;
    final Map<String, List<TasbeehSession>> byDay = {};
    for (final s in sessions) {
      final key = '${s.timestamp.year}-${s.timestamp.month}-${s.timestamp.day}';
      byDay.putIfAbsent(key, () => []).add(s);
    }

    final logs = <DailyZikrLog>[];
    byDay.forEach((_, daySessions) {
      final date = daySessions.first.timestamp;
      final d = DateTime(date.year, date.month, date.day);
      final diff = _today.difference(d).inDays;

      // Merge same zikr names, sum counts.
      final Map<String, ZikrLogEntry> merged = {};
      for (final s in daySessions) {
        final existing = merged[s.zikrName];
        if (existing == null) {
          merged[s.zikrName] = ZikrLogEntry(
            name: s.zikrName,
            arabic: s.zikrArabic,
            count: s.count,
          );
        } else {
          merged[s.zikrName] = ZikrLogEntry(
            name: existing.name,
            arabic: existing.arabic,
            count: existing.count + s.count,
          );
        }
      }

      logs.add(DailyZikrLog(
        dateLabel: buildDayLabel(d, _today),
        daysAgo: diff,
        entries: merged.values.toList(),
      ));
    });

    logs.sort((a, b) => a.daysAgo.compareTo(b.daysAgo));
    return logs;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final logs = _groupedLogs;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 19, color: palette.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Tasbeeh History',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
        actions: [
          if (_allSessions.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline_rounded,
                  size: 20, color: palette.textSecondary),
              tooltip: 'Clear history',
              onPressed: _confirmClear,
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _loading
            ? Center(child: CircularProgressIndicator(color: palette.goldMuted))
            : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 8, horizontalPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HistorySummaryCards(
                      todayCount: _todayCount,
                      weekCount: _weekCount,
                      monthCount: _monthCount,
                    ),
                    const SizedBox(height: 16),
                    HistoryProgressSection(logs: logs),
                    const SizedBox(height: 20),
                    HistoryFilterChips(
                      selected: _filter,
                      onChanged: (f) => setState(() => _filter = f),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (logs.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Column(
                    children: [
                      Icon(Icons.history_toggle_off_rounded,
                          size: 38, color: palette.iconInactive),
                      const SizedBox(height: 12),
                      Text(
                        'No Tasbeeh sessions in this range yet',
                        style: TextStyle(
                          fontSize: 13,
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    horizontalPadding, 0, horizontalPadding, 24),
                sliver: SliverList.separated(
                  itemCount: logs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      HistoryDayGroup(log: logs[index]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Tasbeeh history?'),
        content: const Text(
            'This will permanently remove all saved Tasbeeh sessions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await TasbeehStorageService.clearAll();
      await _loadSessions();
    }
  }
}