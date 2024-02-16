import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum CalendarFeedStatus { init, loading, success, error }

class CalendarFeedBloc extends Bloc<CalendarFeedEvent, CalendarFeedState> {
  final int roomId;
  CalendarFeedBloc(this.roomId) : super(CalendarFeedState.init()) {
    on<ChangeDateEvent>(_changeDate);
    add(ChangeDateEvent(state.focusedDay));
  }

  Future<void> _changeDate(ChangeDateEvent event, emit) async {
    emit(state.copyWith(
      status: CalendarFeedStatus.loading,
      focusedDay: event.date,
      feedList: [],
    ));
    try {
      FeedListByDateResponse res = await UserService.getFeedListByDate(
        roomId: roomId,
        dateYM: DateFormat('yyyyMM').format(event.date),
      );
      emit(state.copyWith(
        status: CalendarFeedStatus.success,
        feedList: res.myPageCalenderInfoList,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CalendarFeedStatus.error,
        errorMessage: error.toString(),
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
  final CalendarFeedStatus status;
  final String? errorMessage;
  final int? roomId;
  final DateTime focusedDay;
  final List<MyPageCalenderInfo> feedList;

  const CalendarFeedState({
    required this.status,
    this.errorMessage,
    required this.roomId,
    required this.focusedDay,
    required this.feedList,
  });

  CalendarFeedState.init()
      : this(
          status: CalendarFeedStatus.init,
          roomId: null,
          focusedDay: DateTime.now(),
          feedList: [],
        );

  CalendarFeedState copyWith({
    CalendarFeedStatus? status,
    String? errorMessage,
    int? roomId,
    DateTime? focusedDay,
    List<MyPageCalenderInfo>? feedList,
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
