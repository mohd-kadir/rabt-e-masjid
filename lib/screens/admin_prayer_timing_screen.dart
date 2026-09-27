import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_colors.dart';
import '../models/mock_data.dart';
import '../widgets/admin_prayer_timing/prayer_timing_card.dart';
import '../widgets/admin_prayer_timing/jumuah_timing_card.dart';
import '../widgets/admin_prayer_timing/time_format_utils.dart';

class AdminPrayerTimingScreen extends StatefulWidget {
  const AdminPrayerTimingScreen({super.key});

  @override
  State<AdminPrayerTimingScreen> createState() =>
      _AdminPrayerTimingScreenState();
}

class _AdminPrayerTimingScreenState
    extends State<AdminPrayerTimingScreen> {
  late List<_EditablePrayer> _prayers;

  late TimeOfDay _khutbahTime;
  late TimeOfDay _salahTime;

  bool _isSaving = false;
  bool _isLoading = true;

  String? _masjidId;

  @override
  void initState() {
    super.initState();

    // Initially use mock values.
    // Firestore data will replace them if available.
    _prayers = MockData.prayers
        .map(
          (p) => _EditablePrayer(
        name: p.name,
        icon: p.icon,
        azan: parseTimeLabel(p.azanTime),
        jamaat: parseTimeLabel(p.jamaatTime),
      ),
    )
        .toList();

    _khutbahTime = parseTimeLabel(MockData.jumuah.khutbahTime);
    _salahTime = parseTimeLabel(MockData.jumuah.salahTime);

    _loadPrayerTimings();
  }

  // ============================================================
  // LOAD PRAYER TIMINGS FROM FIRESTORE
  // ============================================================

  Future<void> _loadPrayerTimings() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Admin is not logged in.');
      }

      // Get admin profile
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) {
        throw Exception('Admin profile not found.');
      }

      final adminData = adminDoc.data();

      if (adminData == null) {
        throw Exception('Admin data is empty.');
      }

      final masjidId = adminData['masjidId']?.toString();

      if (masjidId == null || masjidId.isEmpty) {
        throw Exception('Masjid ID not found.');
      }

      _masjidId = masjidId;

      // Get prayer timing document
      final prayerDoc = await FirebaseFirestore.instance
          .collection('prayerTimings')
          .doc(masjidId)
          .get();

      // If no timings have been saved yet,
      // keep mock/default timings.
      if (!prayerDoc.exists) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      final data = prayerDoc.data();

      if (data == null) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      // -----------------------------
      // Fajr
      // -----------------------------

      _prayers[0] = _prayers[0].copyWith(
        azan: _parseFirestoreTime(
          data['fajrAzan'],
          _prayers[0].azan,
        ),
        jamaat: _parseFirestoreTime(
          data['fajrJamaat'],
          _prayers[0].jamaat,
        ),
      );

      // -----------------------------
      // Dhuhr
      // -----------------------------

      _prayers[1] = _prayers[1].copyWith(
        azan: _parseFirestoreTime(
          data['dhuhrAzan'],
          _prayers[1].azan,
        ),
        jamaat: _parseFirestoreTime(
          data['dhuhrJamaat'],
          _prayers[1].jamaat,
        ),
      );

      // -----------------------------
      // Asr
      // -----------------------------

      _prayers[2] = _prayers[2].copyWith(
        azan: _parseFirestoreTime(
          data['asrAzan'],
          _prayers[2].azan,
        ),
        jamaat: _parseFirestoreTime(
          data['asrJamaat'],
          _prayers[2].jamaat,
        ),
      );

      // -----------------------------
      // Maghrib
      // -----------------------------

      _prayers[3] = _prayers[3].copyWith(
        azan: _parseFirestoreTime(
          data['maghribAzan'],
          _prayers[3].azan,
        ),
        jamaat: _parseFirestoreTime(
          data['maghribJamaat'],
          _prayers[3].jamaat,
        ),
      );

      // -----------------------------
      // Isha
      // -----------------------------

      _prayers[4] = _prayers[4].copyWith(
        azan: _parseFirestoreTime(
          data['ishaAzan'],
          _prayers[4].azan,
        ),
        jamaat: _parseFirestoreTime(
          data['ishaJamaat'],
          _prayers[4].jamaat,
        ),
      );

      // -----------------------------
      // Jumuah
      // -----------------------------

      _khutbahTime = _parseFirestoreTime(
        data['jumuahKhutbah'],
        _khutbahTime,
      );

      _salahTime = _parseFirestoreTime(
        data['jumuahSalah'],
        _salahTime,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading prayer timings: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load prayer timings: $e'),
        ),
      );
    }
  }

  // ============================================================
  // PARSE FIRESTORE TIME
  // ============================================================

  TimeOfDay _parseFirestoreTime(
      dynamic value,
      TimeOfDay fallback,
      ) {
    if (value == null) return fallback;

    try {
      return parseTimeLabel(value.toString());
    } catch (_) {
      return fallback;
    }
  }

  // ============================================================
  // SAVE PRAYER TIMINGS
  // ============================================================

  Future<void> _handleSave() async {
    if (_masjidId == null || _masjidId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masjid information not available.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('Admin is not logged in.');
      }

      // Re-check admin profile
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) {
        throw Exception('Admin profile not found.');
      }

      final adminData = adminDoc.data();

      if (adminData == null ||
          adminData['role'] != 'admin' ||
          adminData['masjidId']?.toString() != _masjidId) {
        throw Exception(
          'You are not authorized to update these timings.',
        );
      }

      await FirebaseFirestore.instance
          .collection('prayerTimings')
          .doc(_masjidId)
          .set({
        // -----------------------------
        // Fajr
        // -----------------------------
        'fajrAzan': _formatTime(_prayers[0].azan),
        'fajrJamaat': _formatTime(_prayers[0].jamaat),

        // -----------------------------
        // Dhuhr
        // -----------------------------
        'dhuhrAzan': _formatTime(_prayers[1].azan),
        'dhuhrJamaat': _formatTime(_prayers[1].jamaat),

        // -----------------------------
        // Asr
        // -----------------------------
        'asrAzan': _formatTime(_prayers[2].azan),
        'asrJamaat': _formatTime(_prayers[2].jamaat),

        // -----------------------------
        // Maghrib
        // -----------------------------
        'maghribAzan': _formatTime(_prayers[3].azan),
        'maghribJamaat': _formatTime(_prayers[3].jamaat),

        // -----------------------------
        // Isha
        // -----------------------------
        'ishaAzan': _formatTime(_prayers[4].azan),
        'ishaJamaat': _formatTime(_prayers[4].jamaat),

        // -----------------------------
        // Jumuah
        // -----------------------------
        'jumuahKhutbah': _formatTime(_khutbahTime),
        'jumuahSalah': _formatTime(_salahTime),

        // -----------------------------
        // Extra information
        // -----------------------------
        'masjidId': _masjidId,
        'updatedBy': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 10),
              Text('Prayer timings saved successfully'),
            ],
          ),
        ),
      );

// Save ke baad previous screen par wapas
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error saving prayer timings: $e');

      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save prayer timings: $e'),
        ),
      );
    }
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final minute = time.minute.toString().padLeft(2, '0');

    final period =
    time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final size = MediaQuery.of(context).size;

    final isTablet = size.width >= 600;

    final horizontalPadding =
    isTablet ? size.width * 0.1 : 18.0;

    final today = formatTodayLabel(DateTime.now());

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
          'Prayer Timings',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
          ),
        ),
      ),

      body: SafeArea(
        top: false,

        child: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            8,
            horizontalPadding,
            24,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: palette.goldMuted,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    today,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.goldMuted,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              for (int i = 0;
              i < _prayers.length;
              i++) ...[
                PrayerTimingCard(
                  name: _prayers[i].name,
                  icon: _prayers[i].icon,
                  azanTime: _prayers[i].azan,
                  jamaatTime: _prayers[i].jamaat,

                  onAzanChanged: (t) {
                    setState(() {
                      _prayers[i] =
                          _prayers[i].copyWith(
                            azan: t,
                          );
                    });
                  },

                  onJamaatChanged: (t) {
                    setState(() {
                      _prayers[i] =
                          _prayers[i].copyWith(
                            jamaat: t,
                          );
                    });
                  },
                ),

                const SizedBox(height: 14),
              ],

              JumuahTimingCard(
                khutbahTime: _khutbahTime,
                salahTime: _salahTime,

                onKhutbahChanged: (t) {
                  setState(() {
                    _khutbahTime = t;
                  });
                },

                onSalahChanged: (t) {
                  setState(() {
                    _salahTime = t;
                  });
                },
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed:
                  _isSaving ? null : _handleSave,

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primaryGreen,
                    foregroundColor: Colors.white,

                    disabledBackgroundColor:
                    AppColors.primaryGreen
                        .withOpacity(0.6),

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),

                    elevation: 0,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),

                  child: _isSaving
                      ? const SizedBox(
                    width: 20,
                    height: 20,

                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    'Save Prayer Timings',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w700,
                    ),
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


// ============================================================
// EDITABLE PRAYER MODEL
// ============================================================

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

  _EditablePrayer copyWith({
    TimeOfDay? azan,
    TimeOfDay? jamaat,
  }) {
    return _EditablePrayer(
      name: name,
      icon: icon,
      azan: azan ?? this.azan,
      jamaat: jamaat ?? this.jamaat,
    );
  }
}