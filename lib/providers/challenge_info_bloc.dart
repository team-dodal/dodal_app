import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/challenge_detail_model.dart';
import 'package:dodal_app/repositories/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeInfoBloc extends Bloc<ChallengeInfoEvent, ChallengeInfoState> {
  final int challengeId;
  ChallengeInfoBloc(this.challengeId) : super(const ChallengeInfoState.init()) {
    on<LoadChallengeInfoEvent>(_load);
    on<JoinChallengeEvent>(_join);
    add(LoadChallengeInfoEvent());
  }

  Future<void> _load(LoadChallengeInfoEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final result =
          await ChallengeRepository.getChallengeOne(challengeId: challengeId);
      emit(state.copyWith(
        status: CommonStatus.loaded,
        result: result,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '챌린지 정보를 불러오는데 실패했습니다.',
      ));
    }
  }

  Future<void> _join(JoinChallengeEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      await ChallengeRepository.join(challengeId: challengeId);
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다. 다시 시도해주세요.',
      ));
    }
    await Future.delayed(const Duration(seconds: 1));
    add(LoadChallengeInfoEvent());
  }
}

abstract class ChallengeInfoEvent extends Equatable {}

class LoadChallengeInfoEvent extends ChallengeInfoEvent {
  @override
  List<Object?> get props => [];
}

class JoinChallengeEvent extends ChallengeInfoEvent {
  @override
  List<Object?> get props => [];
}

class ChallengeInfoState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final ChallengeDetail? result;

  const ChallengeInfoState({
    required this.status,
    this.errorMessage,
    required this.result,
  });

  const ChallengeInfoState.init()
      : this(
          status: CommonStatus.init,
          result: null,
        );

  ChallengeInfoState copyWith({
    CommonStatus? status,
    String? errorMessage,
    ChallengeDetail? result,
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
