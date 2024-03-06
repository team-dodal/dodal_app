import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/user_calendar_data_model.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CalendarFeedBloc extends Bloc<CalendarFeedEvent, CalendarFeedState> {
  final int roomId;
  CalendarFeedBloc(this.roomId) : super(CalendarFeedState.init()) {
    on<ChangeDateEvent>(_changeDate);
    add(ChangeDateEvent(state.focusedDay));
  }

  Future<void> _changeDate(ChangeDateEvent event, emit) async {
    emit(state.copyWith(
      status: CommonStatus.loading,
      focusedDay: event.date,
      feedList: [],
    ));
    try {
      List<UserCalendarData> res = await UserService.getFeedListByDate(
        roomId: roomId,
        dateYM: DateFormat('yyyyMM').format(event.date),
      );
      emit(state.copyWith(
        status: CommonStatus.loaded,
        feedList: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
  }
}

abstract class CalendarFeedEvent extends Equatable {}

class ChangeDateEvent extends CalendarFeedEvent {
  final DateTime date;
  ChangeDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class CalendarFeedState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final int? roomId;
  final DateTime focusedDay;
  final List<UserCalendarData> feedList;

  const CalendarFeedState({
    required this.status,
    this.errorMessage,
    required this.roomId,
    required this.focusedDay,
    required this.feedList,
  });

  CalendarFeedState.init()
      : this(
          status: CommonStatus.init,
          roomId: null,
          focusedDay: DateTime.now(),
          feedList: [],
        );

  CalendarFeedState copyWith({
    CommonStatus? status,
    String? errorMessage,
    int? roomId,
    DateTime? focusedDay,
    List<UserCalendarData>? feedList,
  }) {
    return CalendarFeedState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      roomId: roomId ?? this.roomId,
      focusedDay: focusedDay ?? this.focusedDay,
      feedList: feedList ?? this.feedList,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, focusedDay, feedList, roomId];
}
