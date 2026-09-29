import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AdminStatsGrid extends StatelessWidget {
  final String masjidId;

  const AdminStatsGrid({
    super.key,
    required this.masjidId,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 520;
        final crossAxisCount = isWide ? 3 : 2;

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('announcements')
              .where('masjidId', isEqualTo: masjidId)
              .snapshots(),

          builder: (context, announcementSnapshot) {
            final announcementCount =
                announcementSnapshot.data?.docs.length ?? 0;

            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('prayerTimings')
                  .doc(masjidId)
                  .snapshots(),

              builder: (context, prayerSnapshot) {
                final prayerUpdatesCount =
                prayerSnapshot.data?.exists == true ? 1 : 0;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isWide ? 1.3 : 1.5,

                  children: [
                    const _StatCard(
                      label: 'Total Users',
                      value: '—',
                      icon: Icons.people_alt_rounded,
                      filled: true,
                    ),

                    _StatCard(
                      label: 'Announcements',
                      value: '$announcementCount',
                      icon: Icons.campaign_rounded,
                    ),

                    _StatCard(
                      label: 'Prayer Updates',
                      value: '$prayerUpdatesCount',
                      icon: Icons.mosque_rounded,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool filled;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: filled
            ? AppColors.primaryGreen
            : palette.cardSurface,

        borderRadius: BorderRadius.circular(18),

        border: filled
            ? null
            : Border.all(
          color: palette.divider,
          width: 1,
        ),

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Icon(
            icon,
            size: 20,
            color: filled
                ? AppColors.goldLight
                : AppColors.primaryGreen,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: filled
                      ? Colors.white
                      : palette.textPrimary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: filled
                      ? Colors.white.withOpacity(0.85)
                      : palette.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}