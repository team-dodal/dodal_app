import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/challenge_member_model.dart';
import 'package:dodal_app/src/common/repositories/manage_challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageChallengeMemberBloc
    extends Bloc<ManageChallengeMemberEvent, ManageChallengeMemberState> {
  ManageChallengeMemberBloc(int challengeId)
      : super(ManageChallengeMemberState.init(challengeId)) {
    on<LoadManageChallengeMemberEvent>(_loadManageChallengeMemberEvent);
    add(LoadManageChallengeMemberEvent());
  }

  Future<void> _loadManageChallengeMemberEvent(event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ManageChallengeRepository.manageUsers(
          roomId: state.challengeId);
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
}

abstract class ManageChallengeMemberEvent extends Equatable {}

class LoadManageChallengeMemberEvent extends ManageChallengeMemberEvent {
  @override
  List<Object?> get props => [];
}

class ManageChallengeMemberState extends Equatable {
  final int challengeId;
  final CommonStatus status;
  final List<ChallengeMember> result;
  final String? errorMessage;

  const ManageChallengeMemberState({
    required this.status,
    required this.challengeId,
    required this.result,
    this.errorMessage,
  });

  ManageChallengeMemberState.init(int challengeId)
      : this(
          status: CommonStatus.init,
          challengeId: challengeId,
          result: [],
        );

  ManageChallengeMemberState copyWith({
    CommonStatus? status,
    int? challengeId,
    List<ChallengeMember>? result,
    String? errorMessage,
  }) {
    return ManageChallengeMemberState(
      status: status ?? this.status,
      challengeId: challengeId ?? this.challengeId,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [challengeId, status, result, errorMessage];
}
