import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum NicknameStatus { init, loading, success, error }

class NicknameBloc extends Bloc<NicknameEvent, NicknameState> {
  NicknameBloc() : super(const NicknameState.init()) {
    on<CheckNicknameEvent>(_checkNickname);
    on<ChangeNicknameEvent>(_changeNickname);
  }

  _changeNickname(ChangeNicknameEvent event, emit) {
    if (state.status == NicknameStatus.success) {
      emit(state.copyWith(status: NicknameStatus.init));
    }
    emit(state.copyWith(nickname: event.nickname));
  }

  _checkNickname(NicknameEvent event, emit) async {
    if (state.nickname.isEmpty) {
      emit(state.copyWith(
        status: NicknameStatus.error,
        errorMessage: '닉네임을 입력해주세요!',
      ));
    }
    emit(state.copyWith(status: NicknameStatus.loading));
    bool res = await UserService.checkNickName(state.nickname);
    if (res) {
      emit(state.copyWith(status: NicknameStatus.success));
    } else {
      emit(state.copyWith(
        status: NicknameStatus.error,
        errorMessage: '사용할 수 없는 닉네임입니다!',
      ));
    }
  }
}

abstract class NicknameEvent extends Equatable {}

class ChangeNicknameEvent extends NicknameEvent {
  final String nickname;
  ChangeNicknameEvent(this.nickname);
  @override
  List<Object?> get props => [nickname];
}

class CheckNicknameEvent extends NicknameEvent {
  @override
  List<Object?> get props => [];
}

class NicknameState extends Equatable {
  final NicknameStatus status;
  final String nickname;
  final String? errorMessage;

  const NicknameState({
    required this.status,
    required this.nickname,
    this.errorMessage,
  });

  const NicknameState.init() : this(status: NicknameStatus.init, nickname: '');

  NicknameState copyWith({
    NicknameStatus? status,
    String? nickname,
    String? errorMessage,
  }) {
    return NicknameState(
      status: status ?? this.status,
      nickname: nickname ?? this.nickname,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, nickname, errorMessage];
}
