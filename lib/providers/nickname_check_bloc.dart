import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NicknameBloc extends Bloc<NicknameEvent, NicknameState> {
  final String? nickname;

  NicknameBloc({this.nickname}) : super(NicknameState.init(nickname)) {
    on<CheckNicknameEvent>(_checkNickname);
    on<ChangeNicknameEvent>(_changeNickname);
  }

  _changeNickname(ChangeNicknameEvent event, emit) {
    if (state.status == CommonStatus.loaded) {
      emit(state.copyWith(status: CommonStatus.init));
    }
    emit(state.copyWith(nickname: event.nickname));
  }

  _checkNickname(NicknameEvent event, emit) async {
    if (state.nickname.isEmpty) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '닉네임을 입력해주세요!',
      ));
    }
    emit(state.copyWith(status: CommonStatus.loading));
    bool res = await UserService.checkNickName(state.nickname);
    if (res) {
      emit(state.copyWith(status: CommonStatus.loaded));
    } else {
      emit(state.copyWith(
        status: CommonStatus.error,
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
  final CommonStatus status;
  final String nickname;
  final String? errorMessage;

  const NicknameState({
    required this.status,
    required this.nickname,
    this.errorMessage,
  });

  const NicknameState.init(String? nickname)
      : this(
          status: nickname == null ? CommonStatus.init : CommonStatus.loaded,
          nickname: nickname ?? '',
        );

  NicknameState copyWith({
    CommonStatus? status,
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
