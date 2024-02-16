import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ManageChallengeMemberStatus { init, loading, success, error }

class ManageChallengeMemberBloc
    extends Bloc<ManageChallengeMemberEvent, ManageChallengeMemberState> {
  final int roomId;
  ManageChallengeMemberBloc(this.roomId)
      : super(ManageChallengeMemberState.init()) {
    on<LoadManageChallengeMemberEvent>(_loadManageChallengeMemberEvent);
    add(LoadManageChallengeMemberEvent());
  }

  Future<void> _loadManageChallengeMemberEvent(event, emit) async {
    emit(state.copyWith(status: ManageChallengeMemberStatus.loading));
    final res = await ManageChallengeService.manageUsers(roomId: roomId);
    if (res == null) {
      emit(state.copyWith(
        status: ManageChallengeMemberStatus.error,
        errorMessage: '에러가 발생했습니다.',
      ));
      return;
    }
    emit(state.copyWith(
      status: ManageChallengeMemberStatus.success,
      result: res,
    ));
  }
}

abstract class ManageChallengeMemberEvent extends Equatable {}

class LoadManageChallengeMemberEvent extends ManageChallengeMemberEvent {
  @override
  List<Object?> get props => [];
}

class ManageChallengeMemberState extends Equatable {
  final ManageChallengeMemberStatus status;
  final List<ChallengeUser> result;
  final String? errorMessage;

  const ManageChallengeMemberState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  ManageChallengeMemberState.init()
      : this(
          status: ManageChallengeMemberStatus.init,
          result: [],
        );

  ManageChallengeMemberState copyWith({
    ManageChallengeMemberStatus? status,
    List<ChallengeUser>? result,
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
