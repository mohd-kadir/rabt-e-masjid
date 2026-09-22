import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/admin_dashboard_data.dart';

/// Event card for the Admin Dashboard's Upcoming Events section:
/// icon, title, date/time, location, and expected attendee count.
class AdminEventCard extends StatelessWidget {
  final MosqueEvent event;
  final VoidCallback? onTap;

  const AdminEventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: palette.cardSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.divider, width: 1),
            boxShadow: [
              BoxShadow(color: palette.shadowColor, blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.goldAccentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(event.icon, size: 19, color: AppColors.primaryGreenDark),
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: palette.textPrimary, height: 1.3),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 11, color: palette.goldMuted),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '${event.dateLabel} · ${event.timeLabel}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: palette.goldMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 11, color: palette.textSecondary),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      event.location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: palette.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.people_alt_rounded, size: 12, color: AppColors.primaryGreen),
                  const SizedBox(width: 5),
                  Text(
                    '${event.attendeeCount} attending',
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}