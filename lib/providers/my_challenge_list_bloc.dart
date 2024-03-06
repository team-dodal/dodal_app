import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/host_challenge_model.dart';
import 'package:dodal_app/model/joined_challenge_model.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyChallengeListBloc
    extends Bloc<MyChallengeListEvent, MyChallengeListState> {
  MyChallengeListBloc() : super(MyChallengeListState.init()) {
    on<LoadJoinedListEvent>(_loadJoinedList);
    on<LoadAdminListEvent>(_loadAdminList);
    add(LoadJoinedListEvent());
    add(LoadAdminListEvent());
  }

  _loadJoinedList(LoadJoinedListEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ManageChallengeService.joinedChallenges();
      emit(state.copyWith(
        status: CommonStatus.loaded,
        joinedList: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '불러오는 도중 에러가 발생하였습니다',
      ));
    }
  }

  _loadAdminList(LoadAdminListEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ManageChallengeService.hostChallenges();
      emit(state.copyWith(
        status: CommonStatus.loaded,
        adminList: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
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
  final CommonStatus status;
  final String? errorMessage;
  final List<JoinedChallenge> joinedList;
  final List<HostChallenge> adminList;

  const MyChallengeListState({
    required this.status,
    this.errorMessage,
    required this.joinedList,
    required this.adminList,
  });

  MyChallengeListState.init()
      : this(
          status: CommonStatus.init,
          joinedList: [],
          adminList: [],
        );

  MyChallengeListState copyWith({
    CommonStatus? status,
    String? errorMessage,
    List<JoinedChallenge>? joinedList,
    List<HostChallenge>? adminList,
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
