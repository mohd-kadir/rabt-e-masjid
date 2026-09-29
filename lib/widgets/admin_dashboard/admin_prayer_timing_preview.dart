import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../theme/app_colors.dart';

class AdminPrayerTimingPreview extends StatelessWidget {
  final String masjidId;
  final VoidCallback onEdit;

  const AdminPrayerTimingPreview({
    super.key,
    required this.masjidId,
    required this.onEdit,
  });

  String _time(Map<String, dynamic> data, String key) {
    return data[key]?.toString() ?? '--:--';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('prayerTimings')
          .doc(masjidId)
          .snapshots(),

      builder: (context, snapshot) {
        // ========================================================
        // LOADING
        // ========================================================

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.divider),
            ),
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.2),
              ),
            ),
          );
        }

        // ========================================================
        // ERROR
        // ========================================================

        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.divider),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Unable to load prayer timings.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // ========================================================
        // NO DATA
        // ========================================================

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Prayer Timings',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                    TextButton(onPressed: onEdit, child: const Text('Add')),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Prayer timings have not been added yet.',
                  style: TextStyle(fontSize: 12, color: palette.textSecondary),
                ),
              ],
            ),
          );
        }

        // ========================================================
        // FIRESTORE DATA
        // ========================================================

        final data = snapshot.data!.data();

        if (data == null) {
          return const SizedBox.shrink();
        }

        // ========================================================
        // PRAYER LIST
        // ========================================================

        final prayers = [
          _PrayerPreviewData(
            name: 'Fajr',
            icon: Icons.wb_twilight_rounded,
            azan: _time(data, 'fajrAzan'),
            jamaat: _time(data, 'fajrJamaat'),
          ),
          _PrayerPreviewData(
            name: 'Dhuhr',
            icon: Icons.wb_sunny_outlined,
            azan: _time(data, 'dhuhrAzan'),
            jamaat: _time(data, 'dhuhrJamaat'),
          ),
          _PrayerPreviewData(
            name: 'Asr',
            icon: Icons.sunny_snowing,
            azan: _time(data, 'asrAzan'),
            jamaat: _time(data, 'asrJamaat'),
          ),
          _PrayerPreviewData(
            name: 'Maghrib',
            icon: Icons.wb_twilight,
            azan: _time(data, 'maghribAzan'),
            jamaat: _time(data, 'maghribJamaat'),
          ),
          _PrayerPreviewData(
            name: 'Isha',
            icon: Icons.nights_stay_outlined,
            azan: _time(data, 'ishaAzan'),
            jamaat: _time(data, 'ishaJamaat'),
          ),
        ];

        // ========================================================
        // DISPLAY
        // ========================================================

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.divider),
            boxShadow: [
              BoxShadow(
                color: palette.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: onEdit,
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              // ==================================================
              // TABLE HEADER
              // ==================================================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: palette.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 38),

                    Expanded(
                      child: Text(
                        'Prayer',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 72,
                      child: Text(
                        'AZAN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 78,
                      child: Text(
                        'JAMAAT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: palette.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // ==================================================
              // PRAYER ROWS
              // ==================================================
              for (final prayer in prayers)
                _PrayerRow(prayer: prayer, palette: palette),

              const SizedBox(height: 8),

              // ==================================================
              // JUMUAH
              // ==================================================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.mosque_rounded,
                        size: 18,
                        color: AppColors.primaryGreen,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Jumuah',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 72,
                      child: Text(
                        _time(data, 'jumuahKhutbah'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 78,
                      child: Text(
                        _time(data, 'jumuahSalah'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// PRAYER PREVIEW DATA
// ============================================================

class _PrayerPreviewData {
  final String name;
  final IconData icon;
  final String azan;
  final String jamaat;

  const _PrayerPreviewData({
    required this.name,
    required this.icon,
    required this.azan,
    required this.jamaat,
  });
}

// ============================================================
// PRAYER ROW
// ============================================================

class _PrayerRow extends StatelessWidget {
  final _PrayerPreviewData prayer;
  final dynamic palette;

  const _PrayerRow({required this.prayer, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: palette.divider.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.07),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(prayer.icon, size: 17, color: AppColors.primaryGreen),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              prayer.name,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ),

          SizedBox(
            width: 72,
            child: Text(
              prayer.azan,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
          ),

          SizedBox(
            width: 78,
            child: Text(
              prayer.jamaat,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
