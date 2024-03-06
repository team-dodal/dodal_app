import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/challenge_member_model.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageChallengeMemberBloc
    extends Bloc<ManageChallengeMemberEvent, ManageChallengeMemberState> {
  final int roomId;
  ManageChallengeMemberBloc(this.roomId)
      : super(ManageChallengeMemberState.init()) {
    on<LoadManageChallengeMemberEvent>(_loadManageChallengeMemberEvent);
    add(LoadManageChallengeMemberEvent());
  }

  Future<void> _loadManageChallengeMemberEvent(event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await ManageChallengeService.manageUsers(roomId: roomId);
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
