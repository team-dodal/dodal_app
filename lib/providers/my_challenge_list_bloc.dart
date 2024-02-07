import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MyChallengeListStatus { init, loading, success, error }

class MyChallengeListBloc
    extends Bloc<MyChallengeListEvent, MyChallengeListState> {
  MyChallengeListBloc() : super(MyChallengeListState.init()) {
    on<LoadJoinedListEvent>(_loadJoinedList);
    on<LoadAdminListEvent>(_loadAdminList);
    add(LoadJoinedListEvent());
    add(LoadAdminListEvent());
  }

  _loadJoinedList(LoadJoinedListEvent event, emit) async {
    emit(state.copyWith(status: MyChallengeListStatus.loading));
    final res = await ManageChallengeService.joinedChallenges();
    if (res != null) {
      emit(state.copyWith(
        status: MyChallengeListStatus.success,
        joinedList: res,
      ));
    } else {
      emit(state.copyWith(
        status: MyChallengeListStatus.error,
        errorMessage: '불러오는 도중 에러가 발생하였습니다',
      ));
    }
  }

  _loadAdminList(LoadAdminListEvent event, emit) async {
    emit(state.copyWith(status: MyChallengeListStatus.loading));
    final res = await ManageChallengeService.hostChallenges();
    if (res != null) {
      emit(state.copyWith(
        status: MyChallengeListStatus.success,
        adminList: res,
      ));
    } else {
      emit(state.copyWith(
        status: MyChallengeListStatus.error,
        errorMessage: '불러오는 도중 에러가 발생하였습니다',
      ));
    }
  }
}

abstract class MyChallengeListEvent extends Equatable {}

class LoadJoinedListEvent extends MyChallengeListEvent {
  @override
  List<Object?> get props => [];
}

class LoadAdminListEvent extends MyChallengeListEvent {
  @override
  List<Object?> get props => [];
}

class MyChallengeListState extends Equatable {
  final MyChallengeListStatus status;
  final String? errorMessage;
  final List<JoinedChallengesResponse> joinedList;
  final List<HostChallengesResponse> adminList;

  const MyChallengeListState({
    required this.status,
    this.errorMessage,
    required this.joinedList,
    required this.adminList,
  });

  MyChallengeListState.init()
      : this(
          status: MyChallengeListStatus.init,
          joinedList: [],
          adminList: [],
        );

  MyChallengeListState copyWith({
    MyChallengeListStatus? status,
    String? errorMessage,
    List<JoinedChallengesResponse>? joinedList,
    List<HostChallengesResponse>? adminList,
  }) {
    return MyChallengeListState(
      status: status ?? this.status,
      joinedList: joinedList ?? this.joinedList,
      adminList: adminList ?? this.adminList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, joinedList, adminList];
}
