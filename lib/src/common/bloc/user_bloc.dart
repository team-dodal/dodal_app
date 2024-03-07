import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/user_model.dart';
import 'package:dodal_app/src/common/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserBloc extends Bloc<UserBlocEvent, UserBlocState> with ChangeNotifier {
  String fcmToken;
  FlutterSecureStorage secureStorage;

  UserBloc(
    this.fcmToken,
    this.secureStorage,
  ) : super(const UserBlocState.init()) {
    on<LoadUserBlocEvent>(_loadData);
    on<UpdateUserBlocEvent>((event, emit) {
      emit(state.copyWith(result: event.user));
    });
    on<ClearUserBlocEvent>(_clearUser);
    on<RemoveUserBlocEvent>(_removeUser);
    add(LoadUserBlocEvent(fcmToken));
  }

  _loadData(LoadUserBlocEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      User? res = await UserRepository.user();
      emit(state.copyWith(
        status: CommonStatus.loaded,
        result: res,
      ));
      await UserRepository.updateFcmToken(fcmToken);
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '유저 정보를 불러오는데에 실패하였습니다.',
      ));
    }
    notifyListeners();
  }

  _clearUser(ClearUserBlocEvent event, emit) async {
    await secureStorage.deleteAll();
    emit(const UserBlocState.init());
  }

  _removeUser(RemoveUserBlocEvent event, emit) async {
    try {
      await UserRepository.removeUser();
      await secureStorage.deleteAll();
      emit(const UserBlocState.init());
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '회원 탈퇴에 실패하였습니다.',
      ));
    }
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
  @override
  List<Object?> get props => [];
}

class RemoveUserBlocEvent extends UserBlocEvent {
  @override
  List<Object?> get props => [];
}

class UserBlocState extends Equatable {
  final CommonStatus status;
  final User? result;
  final String? errorMessage;

  const UserBlocState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  const UserBlocState.init() : this(status: CommonStatus.init, result: null);

  UserBlocState copyWith({
    CommonStatus? status,
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
