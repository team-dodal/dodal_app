import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/challenge_member_model.dart';
import 'package:dodal_app/src/common/repositories/manage_challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageChallengeMemberBloc
    extends Bloc<ManageChallengeMemberEvent, ManageChallengeMemberState> {
  final int _challengeId;
  ManageChallengeMemberBloc(this._challengeId)
      : super(ManageChallengeMemberState.init()) {
    on<LoadManageChallengeMemberEvent>(_loadManageChallengeMemberEvent);
    on<BanishUserEvent>(_banishUser);
    on<AssignmentAdminEvent>(_assignment);
    add(LoadManageChallengeMemberEvent());
  }

  void _loadManageChallengeMemberEvent(event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res =
          await ManageChallengeRepository.manageUsers(roomId: _challengeId);
      emit(state.copyWith(
        status: CommonStatus.loaded,
        result: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생했습니다.',
      ));
    }
  }

  void _banishUser(BanishUserEvent event, emit) async {
    try {
      await ManageChallengeRepository.banishUser(
        roomId: _challengeId,
        userId: event.userId,
      );
      add(LoadManageChallengeMemberEvent());
    } catch (error) {
      emit(
        state.copyWith(
          status: CommonStatus.error,
          errorMessage: '에러가 발생했습니다.',
        ),
      );
    }
  }

  void _assignment(AssignmentAdminEvent event, emit) async {
    try {
      await ManageChallengeRepository.handOverAdmin(
        roomId: _challengeId,
        userId: event.userId,
      );
      add(LoadManageChallengeMemberEvent());
    } catch (error) {
      emit(
        state.copyWith(
          status: CommonStatus.error,
          errorMessage: '에러가 발생했습니다.',
        ),
      );
    }
  }
}

abstract class ManageChallengeMemberEvent extends Equatable {}

class LoadManageChallengeMemberEvent extends ManageChallengeMemberEvent {
  @override
  List<Object?> get props => [];
}

class BanishUserEvent extends ManageChallengeMemberEvent {
  final int userId;
  BanishUserEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AssignmentAdminEvent extends ManageChallengeMemberEvent {
  final int userId;
  AssignmentAdminEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ManageChallengeMemberState extends Equatable {
  final CommonStatus status;
  final List<ChallengeMember> result;
  final String? errorMessage;

  const ManageChallengeMemberState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  ManageChallengeMemberState.init()
      : this(
          status: CommonStatus.init,
          result: [],
        );

  ManageChallengeMemberState copyWith({
    CommonStatus? status,
    List<ChallengeMember>? result,
    String? errorMessage,
  }) {
    return ManageChallengeMemberState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
