import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<User?> {
  UserCubit() : super(null);

  void set(User user) {
    if (user.toString() != state.toString()) {
      emit(user);
    }
  }

  void clear() {
    emit(null);
  }
}

enum UserBlocStatus { init, loading, loaded, error }

class UserBloc extends Bloc<UserBlocEvent, UserBlocState> {
  String fcmToken;

  UserBloc(this.fcmToken) : super(const UserBlocState.init()) {
    on<LoadUserBlocEvent>(_loadData);
    add(LoadUserBlocEvent(fcmToken));
  }

  _loadData(LoadUserBlocEvent event, emit) async {
    emit(state.copyWith(status: UserBlocStatus.loading));
    User? res = await UserService.user();
    if (res == null) {
      emit(state.copyWith(
        status: UserBlocStatus.error,
        errorMessage: '유저 정보를 불러오는데에 실패하였습니다.',
      ));
    } else {
      emit(state.copyWith(
        status: UserBlocStatus.loaded,
        result: res,
      ));
      await _postFcmToken(event.fcmToken);
    }
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
