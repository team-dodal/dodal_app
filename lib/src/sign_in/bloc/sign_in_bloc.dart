import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/authentication_model.dart';
import 'package:dodal_app/src/common/model/user_model.dart';
import 'package:dodal_app/src/common/repositories/user_repository.dart';
import 'package:dodal_app/src/common/utils/social_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FlutterSecureStorage secureStorage;

  SignInBloc(this.secureStorage) : super(const SignInState.init()) {
    on<SocialSignInEvent>(_signIn);
  }

  Future<void> _signIn(SocialSignInEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final data = await _getSocialIdAndEmail(event.type);
      emit(state.copyWith(
        socialInfoData: SocialResponse(
          id: data.id,
          email: data.email,
          type: event.type,
        ),
      ));
      Authentication? res = await UserRepository.signIn(event.type, data.id);
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
          type: SocialType.GOOGLE,
        );
      case SocialType.KAKAO:
        final res = await KakaoAuthService.signIn();
        return SocialResponse(
          id: res!['id'].toString(),
          email: res['email'].toString(),
          type: SocialType.KAKAO,
        );
      case SocialType.APPLE:
        final res = await AppleAuthService.signIn();
        return SocialResponse(
          id: res!['id'].toString(),
          email: res['email'].toString(),
          type: SocialType.APPLE,
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
  final SocialResponse? socialInfoData;
  final User? user;

  const SignInState({
    required this.status,
    this.errorMessage,
    required this.user,
    required this.socialInfoData,
  });

  const SignInState.init()
      : this(
          status: CommonStatus.init,
          errorMessage: null,
          user: null,
          socialInfoData: null,
        );

  SignInState copyWith({
    CommonStatus? status,
    String? errorMessage,
    User? user,
    SocialResponse? socialInfoData,
  }) {
    return SignInState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      socialInfoData: socialInfoData ?? this.socialInfoData,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user, socialInfoData];
}
