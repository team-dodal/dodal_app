import 'package:dodal_app/services/alarm/response.dart';
import 'package:dodal_app/services/alarm/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NotificationListStatus { init, loading, success, error }

class NotificationListBloc
    extends Bloc<NotificationListEvent, NotificationListState> {
  final int userId;
  NotificationListBloc({required this.userId})
      : super(NotificationListState.init()) {
    on<LoadNotificationListEvent>(_loadData);
    on<ClearNotificationListEvent>(_clearData);
    add(LoadNotificationListEvent());
  }

  Future<void> _loadData(LoadNotificationListEvent event, emit) async {
    emit(state.copyWith(status: NotificationListStatus.loading));
    try {
      final res = await AlarmService.getAllAlarmList(userId: userId);
      emit(state.copyWith(status: NotificationListStatus.success, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: NotificationListStatus.error,
        errorMessage: '데이터를 불러오는데 실패하였습니다.',
      ));
    }
  }

  Future<void> _clearData(ClearNotificationListEvent event, emit) async {
    if (state.list.isEmpty) return;
    emit(state.copyWith(status: NotificationListStatus.success, list: []));
    await AlarmService.deleteAllAlarmList(userId: userId);
  }
}

abstract class NotificationListEvent extends Equatable {}

class LoadNotificationListEvent extends NotificationListEvent {
  @override
  List<Object?> get props => [];
}

class ClearNotificationListEvent extends NotificationListEvent {
  @override
  List<Object?> get props => [];
}

class NotificationListState extends Equatable {
  final NotificationListStatus status;
  final List<AlarmResponse> list;
  final String? errorMessage;

  const NotificationListState({
    required this.list,
    required this.status,
    this.errorMessage,
  });

  NotificationListState.init()
      : this(
          list: [],
          status: NotificationListStatus.init,
        );

  NotificationListState copyWith({
    NotificationListStatus? status,
    List<AlarmResponse>? list,
    String? errorMessage,
  }) {
    return NotificationListState(
      status: status ?? this.status,
      list: list ?? this.list,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, list, errorMessage];
}
