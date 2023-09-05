import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/mypage/calendar_marker.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      availableGestures: AvailableGestures.none,
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2033, 3, 14),
      focusedDay: DateTime.now(),
      locale: 'ko-KR',
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: context.body1(fontWeight: FontWeight.bold)!,
        leftChevronIcon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColors.systemGrey2,
          size: 24,
        ),
        rightChevronIcon: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.systemGrey2,
          size: 24,
        ),
        headerMargin: const EdgeInsets.only(bottom: 4),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: context.caption()!,
        weekendStyle: context.caption()!,
      ),
      calendarStyle: const CalendarStyle(outsideDaysVisible: false),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: CalendarCell(text: '${day.day}'),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: CalendarCell(text: '${day.day}'),
          );
        },
      ),
    );
  }
}
