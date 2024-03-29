import 'package:dodal_app/src/common/model/challenge_notice_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeNoticeListBloc
    extends Bloc<ChallengeNoticeListEvent, ChallengeNoticeListState> {
  ChallengeNoticeListBloc(int roomId, int? targetIndex, bool isAdmin)
      : super(ChallengeNoticeListState.init(roomId, targetIndex, isAdmin)) {
    on<LoadChallengeNoticeListEvent>(_load);
    on<ChangeTargetIndexEvent>(_changeTargetIndex);
    add(LoadChallengeNoticeListEvent());
  }

  Future<void> _load(LoadChallengeNoticeListEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final noticeList =
          await ChallengeRepository.getNoticeList(roomId: state.roomId);
      emit(state.copyWith(
        status: CommonStatus.loaded,
        noticeList: noticeList,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
  }

  void _changeTargetIndex(ChangeTargetIndexEvent event, emit) {
    final list = [...state.openIndexList];
    if (list.contains(event.targetIndex)) {
      list.remove(event.targetIndex);
    } else {
      list.add(event.targetIndex);
    }
    emit(state.copyWith(openIndexList: list));
  }
}

abstract class ChallengeNoticeListEvent extends Equatable {}

class LoadChallengeNoticeListEvent extends ChallengeNoticeListEvent {
  @override
  List<Object?> get props => [];
}

class ChangeTargetIndexEvent extends ChallengeNoticeListEvent {
  final int targetIndex;
  ChangeTargetIndexEvent(this.targetIndex);
  @override
  List<Object?> get props => [targetIndex];
}

class ChallengeNoticeListState extends Equatable {
  final CommonStatus status;
  final int roomId;
  final bool isAdmin;
  final List<ChallengeNotice> noticeList;
  final List<int> openIndexList;
  final String? errorMessage;

  const ChallengeNoticeListState({
    required this.status,
    required this.roomId,
    required this.isAdmin,
    required this.noticeList,
    required this.openIndexList,
    this.errorMessage,
  });

  ChallengeNoticeListState.init(int roomId, int? targetIndex, bool isAdmin)
      : this(
          status: CommonStatus.init,
          roomId: roomId,
          isAdmin: isAdmin,
          noticeList: [],
          openIndexList: targetIndex != null ? [targetIndex] : [],
        );

  ChallengeNoticeListState copyWith({
    CommonStatus? status,
    int? roomId,
    bool? isAdmin,
    List<ChallengeNotice>? noticeList,
    List<int>? openIndexList,
    String? errorMessage,
  }) {
    return ChallengeNoticeListState(
      status: status ?? this.status,
      roomId: roomId ?? this.roomId,
      isAdmin: isAdmin ?? this.isAdmin,
      noticeList: noticeList ?? this.noticeList,
      openIndexList: openIndexList ?? this.openIndexList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [roomId, isAdmin, status, noticeList, openIndexList, errorMessage];
}
