import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChallengeInfoStatus { init, loading, success, error }

class ChallengeInfoBloc extends Bloc<ChallengeInfoEvent, ChallengeInfoState> {
  final int challengeId;
  ChallengeInfoBloc(this.challengeId) : super(const ChallengeInfoState.init()) {
    on<LoadChallengeInfoEvent>(_load);
    add(LoadChallengeInfoEvent());
  }

  Future<void> _load(LoadChallengeInfoEvent event, emit) async {
    emit(state.copyWith(status: ChallengeInfoStatus.loading));
    try {
      final result =
          await ChallengeService.getChallengeOne(challengeId: challengeId);
      emit(state.copyWith(
        status: ChallengeInfoStatus.success,
        result: result,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ChallengeInfoStatus.error,
        errorMessage: '챌린지 정보를 불러오는데 실패했습니다.',
      ));
    }
  }
}

abstract class ChallengeInfoEvent extends Equatable {}

class LoadChallengeInfoEvent extends ChallengeInfoEvent {
  @override
  List<Object?> get props => [];
}

class ChallengeInfoState extends Equatable {
  final ChallengeInfoStatus status;
  final String? errorMessage;
  final OneChallengeResponse? result;

  const ChallengeInfoState({
    required this.status,
    this.errorMessage,
    required this.result,
  });

  const ChallengeInfoState.init()
      : this(
          status: ChallengeInfoStatus.init,
          result: null,
        );

  ChallengeInfoState copyWith({
    ChallengeInfoStatus? status,
    String? errorMessage,
    OneChallengeResponse? result,
  }) {
    return ChallengeInfoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, result];
}
