import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/members_feed_model.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ManageChallengeService.getCertificationList(
        roomId: challengeId,
        dateYM: DateFormat('yyyyMM').format(state.date),
      );
      emit(state.copyWith(
        status: CommonStatus.loaded,
        itemListByDate: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
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
    try {
      await ManageChallengeService.approveOrRejectFeed(
        roomId: challengeId,
        feedId: event.feedId,
        confirmValue: event.approve,
      );
      add(RequestCertFeedListEvent());
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
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
  final CommonStatus status;
  final DateTime date;
  final Map<String, List<MembersFeed>> itemListByDate;
  final String? errorMessage;

  const ManageChallengeFeedState({
    required this.status,
    required this.itemListByDate,
    required this.date,
    this.errorMessage,
  });

  ManageChallengeFeedState.init()
      : this(
          status: CommonStatus.init,
          itemListByDate: const {},
          date: DateTime.now(),
        );

  ManageChallengeFeedState copyWith({
    CommonStatus? status,
    DateTime? date,
    Map<String, List<MembersFeed>>? itemListByDate,
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
