import 'package:dodal_app/screens/modify_user/main.dart';
import 'package:dodal_app/widgets/mypage/calendar_marker.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const ModifyUserScreen()));
            },
            child: const Text('유저 수정'),
          ),
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
              weekendTextStyle: TextStyle(color: Colors.red),
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
