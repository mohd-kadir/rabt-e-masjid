import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/dua_data.dart';

/// A single Dua category card: icon, name, short description,
/// number of duas, and an arrow affordance.
class DuaCategoryCard extends StatelessWidget {
  final DuaCategory category;
  final VoidCallback? onTap;

  const DuaCategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldAccentGradient,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(category.icon, size: 21, color: AppColors.primaryGreenDark),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded, size: 13, color: palette.iconInactive),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: palette.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w400, color: palette.textSecondary, height: 1.3),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${category.duaCount} Duas',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}