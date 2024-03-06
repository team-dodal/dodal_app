import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/users_rooms_info_model.dart';
import 'package:dodal_app/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserRoomFeedInfoBloc
    extends Bloc<UserRoomFeedInfoEvent, UserRoomFeedInfoState> {
  UserRoomFeedInfoBloc() : super(UserRoomFeedInfoState.init()) {
    on<RequestUserInfoEvent>(_getUserRoomFeedInfo);
    on<ChangeSelectedRoomIdEvent>(_changeSelectedRoomId);
    add(RequestUserInfoEvent());
  }

  Future<void> _getUserRoomFeedInfo(RequestUserInfoEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await UserRepository.getUsersRoomFeed();
      emit(state.copyWith(
        status: CommonStatus.loaded,
        challengeList: res.challengeRoomList,
        selectedId: res.challengeRoomList.isNotEmpty
            ? res.challengeRoomList[0].roomId
            : null,
        totalCertCnt: res.totalCertCnt,
        maxContinueCertCnt: res.maxContinueCertCnt,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '서버와의 통신에 실패했습니다',
      ));
    }
  }

  _changeSelectedRoomId(ChangeSelectedRoomIdEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    await Future.delayed(const Duration(milliseconds: 200));
    emit(state.copyWith(
      status: CommonStatus.loaded,
      selectedId: event.roomId,
    ));
  }
}

abstract class UserRoomFeedInfoEvent extends Equatable {}

class RequestUserInfoEvent extends UserRoomFeedInfoEvent {
  @override
  List<Object?> get props => [];
}

class ChangeSelectedRoomIdEvent extends UserRoomFeedInfoEvent {
  final int roomId;
  ChangeSelectedRoomIdEvent(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class UserRoomFeedInfoState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final List<UsersChallengeRoom> challengeList;
  final int? selectedId;
  final int totalCertCnt;
  final int maxContinueCertCnt;

  const UserRoomFeedInfoState({
    required this.status,
    this.errorMessage,
    required this.challengeList,
    required this.selectedId,
    required this.totalCertCnt,
    required this.maxContinueCertCnt,
  });

  UserRoomFeedInfoState.init()
      : this(
          status: CommonStatus.init,
          challengeList: [],
          selectedId: null,
          totalCertCnt: 0,
          maxContinueCertCnt: 0,
        );

  UserRoomFeedInfoState copyWith({
    CommonStatus? status,
    String? errorMessage,
    List<UsersChallengeRoom>? challengeList,
    int? selectedId,
    int? totalCertCnt,
    int? maxContinueCertCnt,
  }) {
    return UserRoomFeedInfoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      challengeList: challengeList ?? this.challengeList,
      selectedId: selectedId ?? this.selectedId,
      totalCertCnt: totalCertCnt ?? this.totalCertCnt,
      maxContinueCertCnt: maxContinueCertCnt ?? this.maxContinueCertCnt,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        challengeList,
        selectedId,
        totalCertCnt,
        maxContinueCertCnt,
      ];
}
