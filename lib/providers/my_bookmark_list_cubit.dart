import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MyBookmarkListStatus { init, loading, success, error }

class MyBookmarkListCubit extends Cubit<MyBookmarkListState> {
  MyBookmarkListCubit() : super(MyBookmarkListState.init()) {
    _loadData();
  }

  _loadData() async {
    emit(state.copyWith(status: MyBookmarkListStatus.loading));
    final list = await ChallengeService.getBookmarkList();
    if (list != null) {
      emit(state.copyWith(
        status: MyBookmarkListStatus.success,
        result: list,
      ));
    } else {
      emit(state.copyWith(
        status: MyBookmarkListStatus.error,
        errorMessage: '데이터를 불러오는데 실패하였습니다.',
      ));
    }
  }
}

class MyBookmarkListState extends Equatable {
  final MyBookmarkListStatus status;
  final List<Challenge> result;
  final String? errorMessage;

  const MyBookmarkListState({
    required this.status,
    required this.result,
    this.errorMessage,
  });

  MyBookmarkListState.init()
      : this(status: MyBookmarkListStatus.init, result: []);

  MyBookmarkListState copyWith({
    MyBookmarkListStatus? status,
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
