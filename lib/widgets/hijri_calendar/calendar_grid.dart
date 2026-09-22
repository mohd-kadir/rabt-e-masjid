import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../models/hijri_calendar_data.dart';
import '../../services/hijri_calendar_service.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime displayedMonth;
  final DateTime todayDate;
  final int hijriAdjustment;
  final List<IslamicEvent> events;
  final ValueChanged<DateTime>? onDayTap;

  const CalendarGrid({
    super.key,
    required this.displayedMonth,
    required this.todayDate,
    required this.hijriAdjustment,
    required this.events,
    this.onDayTap,
  });

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final leadingEmptyCells = firstOfMonth.weekday % 7;
    final gridStart = firstOfMonth.subtract(Duration(days: leadingEmptyCells));

    final cells = List<DateTime>.generate(42, (i) => gridStart.add(Duration(days: i)));

    return Column(
      children: [
        Row(
          children: [
            for (final label in weekdayShortLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.goldMuted,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.85,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            final date = cells[index];
            final isCurrentMonth = date.month == displayedMonth.month && date.year == displayedMonth.year;
            final isToday = _sameDay(date, todayDate);
            final isFriday = date.weekday == DateTime.friday;
            final matchingEvents = events.where((e) => _sameDay(e.gregorianDate, date));
            final hasEvent = matchingEvents.isNotEmpty;

            // ✅ Service se adjusted Hijri date lein
            final hijriDate = HijriCalendarService.convertGregorianToHijri(
              date,
              adjustment: hijriAdjustment,
            );

            return _DayCell(
              gregorianDay: date.day,
              hijriDay: hijriDate.day, // ✅ Already adjusted
              isCurrentMonth: isCurrentMonth,
              isToday: isToday,
              isFriday: isFriday,
              hasEvent: hasEvent,
              onTap: onDayTap == null ? null : () => onDayTap!(date),
            );
          },
        ),
      ],
    );
  }
}

// _DayCell class same rahegi
class _DayCell extends StatelessWidget {
  final int gregorianDay;
  final int hijriDay;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isFriday;
  final bool hasEvent;
  final VoidCallback? onTap;

  const _DayCell({
    required this.gregorianDay,
    required this.hijriDay,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isFriday,
    required this.hasEvent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isToday
        ? AppColors.primaryGreen
        : isFriday
        ? AppColors.gold.withOpacity(0.12)
        : Colors.transparent;

    final Color hijriColor = isToday
        ? Colors.white
        : isCurrentMonth
        ? const Color(0xFF1A1A1A)
        : Colors.grey.shade400;

    final Color gregColor = isToday
        ? Colors.white.withOpacity(0.85)
        : Colors.grey.shade600;

    return Opacity(
      opacity: isCurrentMonth ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: isFriday && !isToday
                ? Border.all(color: AppColors.gold.withOpacity(0.4), width: 1)
                : null,
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$hijriDay',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: hijriColor,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$gregorianDay',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: gregColor,
                ),
              ),
              if (hasEvent) ...[
                const SizedBox(height: 2),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isToday ? AppColors.goldLight : AppColors.gold,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}