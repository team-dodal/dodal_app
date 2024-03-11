import 'package:dodal_app/src/common/model/user_model.dart';
import 'package:dodal_app/src/common/repositories/user_repository.dart';
import 'package:dodal_app/src/common/utils/social_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthStatus { init, unknown, authenticated, unauthenticated, error }

class AuthBloc extends Bloc<UserBlocEvent, UserBlocState> with ChangeNotifier {
  String fcmToken;
  FlutterSecureStorage secureStorage;

  AuthBloc(
    this.fcmToken,
    this.secureStorage,
  ) : super(const UserBlocState.init()) {
    on<LoadUserBlocEvent>(_loadData);
    on<SignInUserBlocEvent>(_signInUser);
    on<UpdateUserBlocEvent>(_updateUser);
    on<ClearUserBlocEvent>(_clearUser);
    on<RemoveUserBlocEvent>(_removeUser);
    add(LoadUserBlocEvent(fcmToken));
  }

  _loadData(LoadUserBlocEvent event, emit) async {
    try {
      User res = await UserRepository.user();
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        result: res,
      ));
      await UserRepository.updateFcmToken(fcmToken);
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.unknown));
    }
    notifyListeners();
  }

  _signInUser(SignInUserBlocEvent event, emit) {
    if (event.user != null) {
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        result: event.user,
        signInInfoData: event.signInInfoData,
      ));
    } else {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        signInInfoData: event.signInInfoData,
      ));
    }
    notifyListeners();
  }

  _updateUser(UpdateUserBlocEvent event, emit) {
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      result: event.user,
    ));
    notifyListeners();
  }

  _clearUser(ClearUserBlocEvent event, emit) async {
    await secureStorage.deleteAll();
    emit(state.copyWith(status: AuthStatus.unknown, result: null));
    notifyListeners();
  }

  _removeUser(RemoveUserBlocEvent event, emit) async {
    try {
      await UserRepository.removeUser();
      await secureStorage.deleteAll();
      emit(state.copyWith(status: AuthStatus.unknown, result: null));
    } catch (error) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: '회원 탈퇴에 실패하였습니다.',
      ));
    }
    notifyListeners();
  }
}

abstract class UserBlocEvent extends Equatable {}

class LoadUserBlocEvent extends UserBlocEvent {
  final String fcmToken;
  LoadUserBlocEvent(this.fcmToken);
  @override
  List<Object?> get props => [fcmToken];
}

class SignInUserBlocEvent extends UserBlocEvent {
  final User? user;
  final SocialResponse signInInfoData;
  SignInUserBlocEvent(this.user, this.signInInfoData);
  @override
  List<Object?> get props => [user, signInInfoData];
}

class UpdateUserBlocEvent extends UserBlocEvent {
  final User user;
  UpdateUserBlocEvent(this.user);
  @override
  List<Object?> get props => [user];
}

class ClearUserBlocEvent extends UserBlocEvent {
  @override
  List<Object?> get props => [];
}

class RemoveUserBlocEvent extends UserBlocEvent {
  @override
  List<Object?> get props => [];
}

class UserBlocState extends Equatable {
  final AuthStatus status;
  final User? user;
  final SocialResponse? signInInfoData;
  final String? errorMessage;

  const UserBlocState({
    required this.status,
    required this.user,
    required this.signInInfoData,
    this.errorMessage,
  });

  const UserBlocState.init()
      : this(
          status: AuthStatus.init,
          user: null,
          signInInfoData: null,
        );

  UserBlocState copyWith({
    AuthStatus? status,
    User? result,
    SocialResponse? signInInfoData,
    String? errorMessage,
  }) {
    return UserBlocState(
      status: status ?? this.status,
      user: result ?? user,
      signInInfoData: signInInfoData ?? this.signInInfoData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, signInInfoData, errorMessage];
}
