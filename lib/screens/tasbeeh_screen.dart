import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import '../theme/app_colors.dart';
import '../models/zikr_data.dart';
import '../models/tasbeeh_session.dart';
import '../services/tasbeeh_storage_service.dart';
import '../widgets/tasbeeh/tasbeeh_header.dart';
import '../widgets/tasbeeh/zikr_selector_chips.dart';
import '../widgets/tasbeeh/tasbeeh_counter_circle.dart';
import '../widgets/tasbeeh/tasbeeh_bottom_actions.dart';
import '../widgets/tasbeeh/set_target_sheet.dart';
import '../widgets/tasbeeh/tasbeeh_settings_sheet.dart';
import '../widgets/tasbeeh/custom_zikr_dialog.dart';
import 'tasbeeh_history_screen.dart';

/// Digital Tasbeeh counter screen. Tapping the large circle increments
/// the count with a smooth animated progress ring, a tap-scale bounce,
/// and (when enabled) real device vibration. Sessions are persisted
/// locally, including the currently running count.
class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen>
    with WidgetsBindingObserver {
  ZikrPreset _selectedZikr = zikrPresets.first; // SubhanAllah
  int _count = 0;
  int _target = 100;
  int _round = 1;

  bool _hapticEnabled = true;
  bool _keepScreenOn = false;

  bool _restored = false;

  /// True if device actually has a vibrator (null = not checked yet).
  bool? _hasVibrator;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreInProgress();
    _checkVibrator();

    // Safety net: if restore takes too long, don't block the UI.
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && !_restored) {
        setState(() => _restored = true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _persistCurrentSession();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _persistCurrentSession();
    }
  }

  /// Checks once whether the device has a vibrator.
  Future<void> _checkVibrator() async {
    try {
      final has = await Vibration.hasVibrator();
      if (!mounted) return;
      setState(() => _hasVibrator = has);
    } catch (_) {
      if (!mounted) return;
      setState(() => _hasVibrator = false);
    }
  }

  /// Fire a short vibration. Falls back to HapticFeedback if the
  /// `vibration` package can't find a vibrator.
  Future<void> _vibrate({bool strong = false}) async {
    if (!_hapticEnabled) return;
    try {
      if (_hasVibrator == true) {
        if (strong) {
          await Vibration.vibrate(duration: 60);
        } else {
          await Vibration.vibrate(duration: 25);
        }
      } else {
        if (strong) {
          await HapticFeedback.mediumImpact();
        } else {
          await HapticFeedback.lightImpact();
        }
      }
    } catch (_) {
      try {
        if (strong) {
          await HapticFeedback.mediumImpact();
        } else {
          await HapticFeedback.lightImpact();
        }
      } catch (_) {}
    }
  }

  /// Loads any previously running count (from a prior navigation away).
  /// Always ends with _restored = true so the UI is never stuck loading.
  Future<void> _restoreInProgress() async {
    TasbeehSession? saved;
    try {
      saved = await TasbeehStorageService.loadInProgress();
    } catch (_) {
      saved = null;
    }

    if (!mounted) return;

    if (saved == null) {
      setState(() => _restored = true);
      return;
    }

    final savedSession = saved;
    ZikrPreset zikr = zikrPresets.firstWhere(
          (p) => p.name == savedSession.zikrName,
      orElse: () => ZikrPreset(
        name: savedSession.zikrName,
        arabic: savedSession.zikrArabic,
        isCustom: true,
      ),
    );

    setState(() {
      _selectedZikr = zikr;
      _count = savedSession.count;
      _target = savedSession.target;
      _restored = true;
    });
  }

  /// Save current running count to in-progress storage.
  Future<void> _persistCurrentSession() async {
    if (_count <= 0) {
      await TasbeehStorageService.clearInProgress();
      return;
    }
    final session = TasbeehSession(
      zikrName: _selectedZikr.name,
      zikrArabic: _selectedZikr.arabic,
      count: _count,
      target: _target,
      timestamp: DateTime.now(),
    );
    await TasbeehStorageService.saveInProgress(session);
  }

  /// Moves the completed round into permanent history.
  Future<void> _commitToHistory(int count, int target) async {
    final session = TasbeehSession(
      zikrName: _selectedZikr.name,
      zikrArabic: _selectedZikr.arabic,
      count: count,
      target: target,
      timestamp: DateTime.now(),
    );
    await TasbeehStorageService.saveSession(session);
    await TasbeehStorageService.clearInProgress();
  }

  void _incrementCount() {
    _vibrate();

    setState(() {
      _count++;
      if (_count >= _target) {
        _vibrate(strong: true);

        _commitToHistory(_count, _target);
        _round++;
        _count = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'MashaAllah! Round ${_round - 1} of ${_selectedZikr.name} completed 🤲',
            ),
          ),
        );
      } else {
        _persistCurrentSession();
      }
    });
  }

  Future<void> _resetCount() async {
    if (_count > 0) {
      await _commitToHistory(_count, _target);
    } else {
      await TasbeehStorageService.clearInProgress();
    }
    if (!mounted) return;
    setState(() {
      _count = 0;
      _round = 1;
    });
  }

  Future<void> _selectZikr(ZikrPreset preset) async {
    if (_count > 0) {
      await _commitToHistory(_count, _target);
    }
    if (!mounted) return;
    setState(() {
      _selectedZikr = preset;
      _count = 0;
      _round = 1;
    });
  }

  void _openCustomZikrDialog() {
    showDialog(
      context: context,
      builder: (_) => CustomZikrDialog(onSubmit: _selectZikr),
    );
  }

  void _openSetTargetSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.palette.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SetTargetSheet(
        currentTarget: _target,
        onSelect: (value) => setState(() => _target = value),
      ),
    );
  }

  Future<void> _openHistorySheet() async {
    await _persistCurrentSession();
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TasbeehHistoryScreen()),
    );
  }

  void _openSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.palette.cardSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return TasbeehSettingsSheet(
              hapticEnabled: _hapticEnabled,
              keepScreenOn: _keepScreenOn,
              onHapticChanged: (v) {
                setState(() => _hapticEnabled = v);
                setSheetState(() {});
                if (v) _vibrate();
              },
              onKeepScreenOnChanged: (v) {
                setState(() => _keepScreenOn = v);
                setSheetState(() {});
              },
            );
          },
        );
      },
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              horizontalPadding, 14, horizontalPadding, 16),
          child: Column(
            children: [
              TasbeehHeader(
                onHistoryTap: _openHistorySheet,
                onSettingsTap: _openSettingsSheet,
              ),
              const SizedBox(height: 18),
              ZikrSelectorChips(
                selected: _selectedZikr,
                onSelect: _selectZikr,
                onCustomTap: _openCustomZikrDialog,
              ),
              if (_round > 1) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Round $_round',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: palette.goldMuted,
                      ),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Always show the counter — no blocking spinner.
              TasbeehCounterCircle(
                count: _count,
                target: _target,
                zikrName: _selectedZikr.name,
                zikrArabic: _selectedZikr.arabic,
                onTap: _incrementCount,
              ),
              const Spacer(),
              TasbeehBottomActions(
                onReset: _resetCount,
                onSetTarget: _openSetTargetSheet,
                onHistory: _openHistorySheet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}