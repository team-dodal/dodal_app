import 'package:dodal_app/screens/sign_up/nickname_check_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Status { init, loading, loaded, error }

class NicknameCheckBloc extends Bloc<NicknameCheckEvent, NicknameCheckState> {
  final NicknameCheckRepository _nicknameCheckRepository;

  NicknameCheckBloc(this._nicknameCheckRepository)
      : super(const NicknameCheckState.init()) {
    on<NicknameCheckEvent>(_checkNickname);
  }

  _checkNickname(NicknameCheckEvent event, emit) async {
    emit(state.copyWith(status: Status.loading));
    bool res = await _nicknameCheckRepository.checkNickname(state.nickname);
    if (res) {
      emit(state.copyWith(status: Status.loaded));
    } else {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: '사용할 수 없는 닉네임입니다!',
      ));
    }
  }
}

abstract class NicknameCheckEvent extends Equatable {}

class NicknameCheckState extends Equatable {
  final Status status;
  final String nickname;
  final String? errorMessage;

  const NicknameCheckState({
    required this.status,
    required this.nickname,
    this.errorMessage,
  });

  const NicknameCheckState.init() : this(status: Status.init, nickname: '');

  NicknameCheckState copyWith({
    Status? status,
    String? nickname,
    String? errorMessage,
  }) {
    return NicknameCheckState(
      status: status ?? this.status,
      nickname: nickname ?? this.nickname,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, nickname, errorMessage];
}
