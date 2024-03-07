import 'package:animations/animations.dart';
import 'package:dodal_app/src/common/model/user_calendar_data_model.dart';
import 'package:dodal_app/src/main/my_info/bloc/calendar_feed_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/main/my_info/widget/calendar_marker.dart';
import 'package:dodal_app/src/main/my_info/widget/my_feed_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Widget _cellBuilder({
    required DateTime day,
    required DateTime focusedDay,
    bool disabled = false,
  }) {
    final list = context.read<CalendarFeedBloc>().state.feedList;
    List<UserCalendarData> findList = list
        .where((element) => element.day == DateFormat('d').format(day))
        .toList();
    bool isInclude = findList.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: isInclude
          ? OpenContainer(
              transitionType: ContainerTransitionType.fadeThrough,
              closedBuilder: (context, action) {
                return ImageCalendarCell(
                  text: '${day.day}',
                  imageUrl: findList[0].certImageUrl,
                );
              },
              openBuilder: (context, action) {
                return MyFeedBox(feedId: findList[0].feedId);
              },
            )
          : CalendarCell(text: '${day.day}', disabled: disabled),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarFeedBloc, CalendarFeedState>(
      builder: (context, state) {
        return TableCalendar(
          availableGestures: AvailableGestures.none,
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.now(),
          focusedDay: state.focusedDay,
          onPageChanged: (focusedDay) {
            context.read<CalendarFeedBloc>().add(ChangeDateEvent(focusedDay));
          },
          locale: 'ko-KR',
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: context.body1(fontWeight: FontWeight.bold),
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
            weekdayStyle: context.caption(),
            weekendStyle: context.caption(),
          ),
          calendarStyle: const CalendarStyle(outsideDaysVisible: false),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) => _cellBuilder(
              day: day,
              focusedDay: focusedDay,
            ),
            todayBuilder: (context, day, focusedDay) => _cellBuilder(
              day: day,
              focusedDay: focusedDay,
            ),
            disabledBuilder: (context, day, focusedDay) => _cellBuilder(
              day: day,
              focusedDay: focusedDay,
              disabled: true,
            ),
          ),
        );
      },
    );
  }
}
