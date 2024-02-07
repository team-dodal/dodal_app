import 'dart:io';

import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum UserBlocStatus { init, success, loaded, error }

class UserBloc extends Bloc<UserBlocEvent, UserBlocState> {
  String fcmToken;
  FlutterSecureStorage secureStorage;

  UserBloc(
    this.fcmToken,
    this.secureStorage,
  ) : super(const UserBlocState.init()) {
    on<LoadUserBlocEvent>(_loadData);
    on<SignUpUserBlocEvent>(_signUp);
    on<UpdateUserBlocEvent>(_updateUser);
    on<ClearUserBlocEvent>(_clearUser);
    add(LoadUserBlocEvent(fcmToken));
  }

  _loadData(LoadUserBlocEvent event, emit) async {
    emit(state.copyWith(status: UserBlocStatus.success));
    try {
      User? res = await UserService.user();
      emit(state.copyWith(
        status: UserBlocStatus.loaded,
        result: res,
      ));
      await _postFcmToken(event.fcmToken);
    } catch (error) {
      emit(state.copyWith(
        status: UserBlocStatus.error,
        errorMessage: '유저 정보를 불러오는데에 실패하였습니다.',
      ));
    }
  }

  _signUp(SignUpUserBlocEvent event, emit) async {
    SignUpResponse? res = await UserService.signUp(
      socialType: event.socialType,
      socialId: event.socialId,
      email: event.email,
      nickname: event.nickname,
      profile: event.profile,
      content: event.content,
      category: event.tagList.map((e) => e.value as String).toList(),
    );
    if (res == null) {
      emit(state.copyWith(
        status: UserBlocStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    } else {
      await secureStorage.write(key: 'accessToken', value: res.accessToken);
      await secureStorage.write(key: 'refreshToken', value: res.refreshToken);
      emit(state.copyWith(status: UserBlocStatus.success, result: res.user));
    }
  }

  _updateUser(UpdateUserBlocEvent event, emit) async {
    emit(state.copyWith(result: event.user));
  }

  _clearUser(ClearUserBlocEvent event, emit) async {
    emit(const UserBlocState.init());
  }

  _postFcmToken(String fcmToken) async {
    await UserService.updateFcmToken(fcmToken);
  }
}

abstract class UserBlocEvent extends Equatable {}

class LoadUserBlocEvent extends UserBlocEvent {
  final String fcmToken;
  LoadUserBlocEvent(this.fcmToken);
  @override
  List<Object?> get props => [fcmToken];
}

class SignUpUserBlocEvent extends UserBlocEvent {
  final SocialType socialType;
  final String socialId;
  final String email;
  final String nickname;
  final String content;
  final File? profile;
  final List<Tag> tagList;
  SignUpUserBlocEvent({
    required this.socialType,
    required this.socialId,
    required this.email,
    required this.nickname,
    required this.content,
    required this.profile,
    required this.tagList,
  });
  @override
  List<Object?> get props =>
      [socialType, socialId, email, nickname, content, profile, tagList];
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

class UserBlocState extends Equatable {
  final UserBlocStatus status;
  final User? result;
  final String? errorMessage;

  const UserBlocState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  const UserBlocState.init() : this(status: UserBlocStatus.init, result: null);

  UserBlocState copyWith({
    UserBlocStatus? status,
    User? result,
    String? errorMessage,
  }) {
    return UserBlocState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
