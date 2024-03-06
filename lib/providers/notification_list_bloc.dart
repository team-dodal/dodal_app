import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/alarm_content_model.dart';
import 'package:dodal_app/services/alarm/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await AlarmService.getAllAlarmList(userId: userId);
      emit(state.copyWith(status: CommonStatus.loaded, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '데이터를 불러오는데 실패하였습니다.',
      ));
    }
  }

  Future<void> _clearData(ClearNotificationListEvent event, emit) async {
    if (state.list.isEmpty) return;
    emit(state.copyWith(status: CommonStatus.loaded, list: []));
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
  final CommonStatus status;
  final List<AlarmContent> list;
  final String? errorMessage;

  const NotificationListState({
    required this.list,
    required this.status,
    this.errorMessage,
  });

  NotificationListState.init()
      : this(
          list: [],
          status: CommonStatus.init,
        );

  NotificationListState copyWith({
    CommonStatus? status,
    List<AlarmContent>? list,
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
