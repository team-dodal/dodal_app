import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum ManageChallengeFeedStatus { init, loading, success, error }

class ManageChallengeFeedBloc
    extends Bloc<ManageChallengeFeedEvent, ManageChallengeFeedState> {
  final int challengeId;
  ManageChallengeFeedBloc(this.challengeId)
      : super(ManageChallengeFeedState.init()) {
    on<RequestCertFeedListEvent>(_requestCertList);
    on<ChangeMonthEvent>(_changeMonth);
    on<ApproveOrRejectEvent>(_approveOrReject);
    add(RequestCertFeedListEvent());
  }

  _requestCertList(RequestCertFeedListEvent event, emit) async {
    emit(state.copyWith(status: ManageChallengeFeedStatus.loading));
    final res = await ManageChallengeService.getCertificationList(
      roomId: challengeId,
      dateYM: DateFormat('yyyyMM').format(state.date),
    );
    if (res == null) {
      emit(state.copyWith(
        status: ManageChallengeFeedStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
      return;
    }
    emit(state.copyWith(
      status: ManageChallengeFeedStatus.success,
      itemListByDate: res,
    ));
  }

  _changeMonth(ChangeMonthEvent event, emit) async {
    final changedDate = DateTime(
      state.date.year,
      state.date.month + event.month,
      state.date.day,
    );
    if (changedDate.isAfter(DateTime.now())) return;
    emit(state.copyWith(date: changedDate));
    add(RequestCertFeedListEvent());
  }

  _approveOrReject(ApproveOrRejectEvent event, emit) async {
    final res = await ManageChallengeService.approveOrRejectFeed(
      roomId: challengeId,
      feedId: event.feedId,
      confirmValue: event.approve,
    );
    if (res == null) return;
    add(RequestCertFeedListEvent());
  }
}

abstract class ManageChallengeFeedEvent extends Equatable {}

class RequestCertFeedListEvent extends ManageChallengeFeedEvent {
  @override
  List<Object?> get props => [];
}

class ChangeMonthEvent extends ManageChallengeFeedEvent {
  final int month;
  ChangeMonthEvent(this.month);
  @override
  List<Object?> get props => [month];
}

class ApproveOrRejectEvent extends ManageChallengeFeedEvent {
  final int feedId;
  final bool approve;
  ApproveOrRejectEvent({
    required this.feedId,
    required this.approve,
  });
  @override
  List<Object?> get props => [feedId, approve];
}

class ManageChallengeFeedState extends Equatable {
  final ManageChallengeFeedStatus status;
  final DateTime date;
  final Map<String, List<FeedItem>> itemListByDate;
  final String? errorMessage;

  const ManageChallengeFeedState({
    required this.status,
    required this.itemListByDate,
    required this.date,
    this.errorMessage,
  });

  ManageChallengeFeedState.init()
      : this(
          status: ManageChallengeFeedStatus.init,
          itemListByDate: const {},
          date: DateTime.now(),
        );

  ManageChallengeFeedState copyWith({
    ManageChallengeFeedStatus? status,
    DateTime? date,
    Map<String, List<FeedItem>>? itemListByDate,
    String? errorMessage,
  }) {
    return ManageChallengeFeedState(
      status: status ?? this.status,
      date: date ?? this.date,
      itemListByDate: itemListByDate ?? this.itemListByDate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, itemListByDate, date, errorMessage];
}
