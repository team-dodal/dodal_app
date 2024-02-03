import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserBlocStatus { init, loading, loaded, error }

class UserBloc extends Bloc<UserBlocEvent, UserBlocState> {
  String fcmToken;

  UserBloc(this.fcmToken) : super(const UserBlocState.init()) {
    on<LoadUserBlocEvent>(_loadData);
    on<UpdateUserBlocEvent>(_updateUser);
    on<ClearUserBlocEvent>(_clearUser);
    add(LoadUserBlocEvent(fcmToken));
  }

  _loadData(LoadUserBlocEvent event, emit) async {
    emit(state.copyWith(status: UserBlocStatus.loading));
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

  _updateUser(UpdateUserBlocEvent event, emit) async {
    emit(state.copyWith(result: event.user));
  }

  _clearUser(ClearUserBlocEvent event, emit) async {
    emit(state.copyWith(result: null));
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

class UpdateUserBlocEvent extends UserBlocEvent {
  final User user;
  UpdateUserBlocEvent(this.user);
  @override
  List<Object?> get props => [user];
}

class ClearUserBlocEvent extends UserBlocEvent {
  ClearUserBlocEvent();
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
