import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Masjid logo with a "Change Logo" affordance. UI only — tapping
/// toggles a mock "changed" state; no real file picker is wired up.
class LogoChangeField extends StatelessWidget {
  final bool isChanged;
  final VoidCallback onChangeTap;

  const LogoChangeField({super.key, required this.isChanged, required this.onChangeTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: AppColors.logoGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: AppColors.primaryGreenDark.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: Icon(
                isChanged ? Icons.check_rounded : Icons.mosque_rounded,
                size: 32,
                color: AppColors.goldLight,
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Material(
                color: AppColors.gold,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onChangeTap,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.camera_alt_rounded, size: 15, color: AppColors.primaryGreenDark),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masjid Logo',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const SizedBox(height: 3),
              Text(
                isChanged ? 'New logo selected' : 'PNG or JPG, square image recommended',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: palette.textSecondary),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: onChangeTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Change Logo', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}