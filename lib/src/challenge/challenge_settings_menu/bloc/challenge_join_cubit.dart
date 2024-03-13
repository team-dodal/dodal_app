import 'package:dio/dio.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:dodal_app/src/common/repositories/manage_challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeJoinCubit extends Cubit<ChallengeJoinState> {
  final ChallengeDetail _challenge;
  final bool _isAdmin;
  ChallengeJoinCubit(
    this._challenge,
    this._isAdmin,
  ) : super(const ChallengeJoinState.init());

  void out() {
    if (_challenge.userCnt <= 1 && _isAdmin) {
      _deleteChallenge();
    } else {
      _outChallenge();
    }
  }

  void join() async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      await ChallengeRepository.join(challengeId: _challenge.id);
      emit(state.copyWith(status: CommonStatus.loaded));
    } on DioException catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: error.response?.data['result'] ?? '',
      ));
    }
  }

  void _outChallenge() async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      await ChallengeRepository.out(challengeId: _challenge.id);
      emit(state.copyWith(status: CommonStatus.loaded));
    } on DioException catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: error.response?.data['result'] ?? '',
      ));
    }
  }

  void _deleteChallenge() async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      await ManageChallengeRepository.deleteChallenge(
        challengeId: _challenge.id,
      );
    } on DioException catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: error.response?.data['result'] ?? '',
      ));
    }
  }
}

class ChallengeJoinState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;

  const ChallengeJoinState({
    required this.status,
    this.errorMessage,
  });

  const ChallengeJoinState.init() : this(status: CommonStatus.init);

  copyWith({
    CommonStatus? status,
    String? errorMessage,
  }) {
    return ChallengeJoinState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
