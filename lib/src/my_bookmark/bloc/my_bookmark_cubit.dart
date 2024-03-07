import 'package:dodal_app/src/common/model/challenge_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBookmarkCubit extends Cubit<MyBookmarkListState> {
  MyBookmarkCubit() : super(MyBookmarkListState.init()) {
    loadData();
  }

  Future<void> loadData() async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      List<Challenge>? res = await ChallengeRepository.getBookmarkList();
      emit(state.copyWith(
        status: CommonStatus.loaded,
        result: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '데이터를 불러오는데 실패하였습니다.',
      ));
    }
  }

  removeItem(int roomId) {
    List<Challenge> list = [...state.result];
    list.removeWhere((e) => e.id == roomId);
    emit(state.copyWith(result: list));
  }
}

class MyBookmarkListState extends Equatable {
  final CommonStatus status;
  final List<Challenge> result;
  final String? errorMessage;

  const MyBookmarkListState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  MyBookmarkListState.init() : this(status: CommonStatus.init, result: []);

  MyBookmarkListState copyWith({
    CommonStatus? status,
    List<Challenge>? result,
    String? errorMessage,
  }) {
    return MyBookmarkListState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, result, errorMessage];
}
