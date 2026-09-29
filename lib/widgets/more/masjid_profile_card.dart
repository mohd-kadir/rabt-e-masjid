import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/masjid_info_data.dart';

/// Masjid profile card at the top of the More screen: logo mark, name,
/// and location. Tapping it opens the full Masjid Information screen.
class MasjidProfileCard extends StatelessWidget {
  final VoidCallback? onTap;

  const MasjidProfileCard({super.key, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppColors.nextPrayerGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreenDark.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldLight.withOpacity(0.5), width: 1.2),
                ),
                child: const Icon(Icons.mosque_rounded, size: 27, color: AppColors.goldLight),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                       'Masjid Al-Noor',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 13, color: AppColors.goldLight.withOpacity(0.9)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Sector-5, Darka',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.85)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }
}