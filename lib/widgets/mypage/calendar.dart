import 'package:animations/animations.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/mypage/calendar_marker.dart';
import 'package:dodal_app/widgets/mypage/my_feed_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.roomId});

  final int roomId;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  List<MyPageCalenderInfo> _feedList = [];

  _requestFeedDate(DateTime focusDay) async {
    String dateYM = DateFormat('yyyyMM').format(focusDay);
    final res = await UserService.getFeedListByDate(
      roomId: widget.roomId,
      dateYM: dateYM,
    );
    if (res == null) return;
    setState(() {
      _feedList = res.myPageCalenderInfoList!;
    });
  }

  Widget calenderBuilderFunction({
    required DateTime day,
    required DateTime focusedDay,
    bool disabled = false,
  }) {
    List<MyPageCalenderInfo> findList = _feedList
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
  void initState() {
    _requestFeedDate(_focusedDay);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Calendar oldWidget) {
    if (oldWidget.roomId != widget.roomId) {
      _requestFeedDate(_focusedDay);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      availableGestures: AvailableGestures.none,
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.now(),
      focusedDay: _focusedDay,
      onPageChanged: (focusedDay) {
        _requestFeedDate(focusedDay);
        setState(() {
          _focusedDay = focusedDay;
        });
      },
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
        defaultBuilder: (context, day, focusedDay) => calenderBuilderFunction(
          day: day,
          focusedDay: focusedDay,
        ),
        todayBuilder: (context, day, focusedDay) => calenderBuilderFunction(
          day: day,
          focusedDay: focusedDay,
        ),
        disabledBuilder: (context, day, focusedDay) => calenderBuilderFunction(
          day: day,
          focusedDay: focusedDay,
          disabled: true,
        ),
      ),
    );
  }
}
