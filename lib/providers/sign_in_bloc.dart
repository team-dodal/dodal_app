import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/authentication_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FlutterSecureStorage secureStorage;

  SignInBloc(this.secureStorage) : super(const SignInState.init()) {
    on<SocialSignInEvent>(_signIn);
  }

  Future<void> _signIn(SocialSignInEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading, type: event.type));
    try {
      final data = await _getSocialIdAndEmail(event.type);
      emit(state.copyWith(id: data.id, email: data.email));
      Authentication? res = await UserService.signIn(event.type, data.id);
      if (res != null) {
        secureStorage.write(key: 'accessToken', value: res.accessToken);
        secureStorage.write(key: 'refreshToken', value: res.refreshToken);
        emit(state.copyWith(status: CommonStatus.loaded, user: res.user));
      } else {
        emit(state.copyWith(status: CommonStatus.loaded));
      }
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '로그인에 실패하였습니다.',
      ));
    }
  }

  Future<SocialResponse> _getSocialIdAndEmail(SocialType type) async {
    switch (type) {
      case SocialType.GOOGLE:
        final res = await GoogleAuthService.signIn();
        return SocialResponse(
          id: res!['id'].toString(),
          email: res['email'].toString(),
        );
      case SocialType.KAKAO:
        final res = await KakaoAuthService.signIn();
        return SocialResponse(
          id: res!['id'].toString(),
          email: res['email'].toString(),
        );
      case SocialType.APPLE:
        final res = await AppleAuthService.signIn();
        return SocialResponse(
          id: res!['id'].toString(),
          email: res['email'].toString(),
        );
    }
  }
}

abstract class SignInEvent extends Equatable {}

class SocialSignInEvent extends SignInEvent {
  final SocialType type;
  SocialSignInEvent(this.type);
  @override
  List<Object?> get props => [type];
}

class SignInState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final String id;
  final String email;
  final User? user;
  final SocialType? type;

  const SignInState({
    required this.status,
    this.errorMessage,
    required this.id,
    required this.email,
    required this.user,
    required this.type,
  });

  const SignInState.init()
      : this(
          status: CommonStatus.init,
          id: '',
          email: '',
          user: null,
          type: null,
        );

  SignInState copyWith({
    CommonStatus? status,
    String? errorMessage,
    String? id,
    String? email,
    User? user,
    SocialType? type,
  }) {
    return SignInState(
      status: status ?? this.status,
      id: id ?? this.id,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, id, email];
}

class SocialResponse extends Equatable {
  final String id;
  final String email;
  const SocialResponse({
    required this.id,
    required this.email,
  });
  @override
  List<Object?> get props => [id, email];
}
