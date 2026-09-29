import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';

/// Responsive facilities grid (2 columns on phones, 3 on tablets).
class FacilitiesGrid extends StatelessWidget {
  final MasjidInfo masjidInfo;

  const FacilitiesGrid({

    super.key,

    required this.masjidInfo,

  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 500 ? 3 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: masjidInfo.facilities.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (context, index) {
            final facility = masjidInfo.facilities[index];
            return _FacilityTile(facility: facility);
          },
        );
      },
    );
  }
}

class _FacilityTile extends StatelessWidget {
  final MasjidFacility facility;
  const _FacilityTile({required this.facility});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.divider, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(facility.icon, size: 17, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              facility.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: palette.textPrimary, height: 1.2),
            ),
          ),
        ],
      ),
    );
  }
}