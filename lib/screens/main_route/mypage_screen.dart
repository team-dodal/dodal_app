import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/mypage/calendar_marker.dart';
import 'package:dodal_app/widgets/mypage/user_info_box.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UserInfoBox(),
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2033, 3, 14),
            focusedDay: DateTime.now(),
            locale: 'ko-KR',
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: AppColors.danger),
              markersAlignment: Alignment.center,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) return null;
                return CalendarMarker(text: day.day.toString());
              },
            ),
            eventLoader: (day) {
              if (day.day % 2 == 0) return [];
              return ['test'];
            },
          )
        ],
      ),
    );
  }
}
