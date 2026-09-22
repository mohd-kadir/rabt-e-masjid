import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/admin_prayer_timing/prayer_timing_card.dart';
import '../widgets/admin_prayer_timing/jumuah_timing_card.dart';
import '../widgets/admin_prayer_timing/time_format_utils.dart';

/// Admin Prayer Timing Management screen: editable Azan/Jamaat times for
/// all 5 daily prayers plus Jumu'ah Khutbah/Salah, using native time
/// pickers. Theme-aware, UI only — "Save" shows a success snackbar but
/// writes nothing to a backend; edits are local State only and reset
/// when the screen is left.
class AdminPrayerTimingScreen extends StatefulWidget {
  const AdminPrayerTimingScreen({super.key});

  @override
  State<AdminPrayerTimingScreen> createState() => _AdminPrayerTimingScreenState();
}

class _AdminPrayerTimingScreenState extends State<AdminPrayerTimingScreen> {
  late List<_EditablePrayer> _prayers;
  late TimeOfDay _khutbahTime;
  late TimeOfDay _salahTime;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _prayers = MockData.prayers
        .map((p) => _EditablePrayer(
      name: p.name,
      icon: p.icon,
      azan: parseTimeLabel(p.azanTime),
      jamaat: parseTimeLabel(p.jamaatTime),
    ))
        .toList();
    _khutbahTime = parseTimeLabel(MockData.jumuah.khutbahTime);
    _salahTime = parseTimeLabel(MockData.jumuah.salahTime);
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 700)); // mock save
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Prayer timings saved successfully'),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final horizontalPadding = isTablet ? size.width * 0.1 : 18.0;
    final today = formatTodayLabel(DateTime.now());

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
          'Prayer Timings',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: palette.textPrimary),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 14, color: palette.goldMuted),
                  const SizedBox(width: 6),
                  Text(
                    today,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: palette.goldMuted),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              for (int i = 0; i < _prayers.length; i++) ...[
                PrayerTimingCard(
                  name: _prayers[i].name,
                  icon: _prayers[i].icon,
                  azanTime: _prayers[i].azan,
                  jamaatTime: _prayers[i].jamaat,
                  onAzanChanged: (t) => setState(() => _prayers[i] = _prayers[i].copyWith(azan: t)),
                  onJamaatChanged: (t) => setState(() => _prayers[i] = _prayers[i].copyWith(jamaat: t)),
                ),
                const SizedBox(height: 14),
              ],

              JumuahTimingCard(
                khutbahTime: _khutbahTime,
                salahTime: _salahTime,
                onKhutbahChanged: (t) => setState(() => _khutbahTime = t),
                onSalahChanged: (t) => setState(() => _salahTime = t),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                  )
                      : const Text(
                    'Save Prayer Timings',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Local mutable copy of a prayer's editable timing state.
class _EditablePrayer {
  final String name;
  final IconData icon;
  final TimeOfDay azan;
  final TimeOfDay jamaat;

  const _EditablePrayer({
    required this.name,
    required this.icon,
    required this.azan,
    required this.jamaat,
  });

  _EditablePrayer copyWith({TimeOfDay? azan, TimeOfDay? jamaat}) {
    return _EditablePrayer(
      name: name,
      icon: icon,
      azan: azan ?? this.azan,
      jamaat: jamaat ?? this.jamaat,
    );
  }
}