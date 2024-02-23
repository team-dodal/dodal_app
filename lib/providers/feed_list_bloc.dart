import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const pageSize = 10;

enum FeedListStatus { init, loading, success, error }

class FeedListBloc extends Bloc<FeedListEvent, FeedListState> {
  FeedListBloc() : super(FeedListState.init()) {
    on<LoadFeedListEvent>(_load);
    add(LoadFeedListEvent());
  }

  _load(LoadFeedListEvent event, emit) async {
    if (state.status == FeedListStatus.loading) return;
    if (state.status == FeedListStatus.error) return;
    if (state.isLastPage) return;
    emit(state.copyWith(status: FeedListStatus.loading));
    try {
      List<FeedContentResponse> res = await FeedService.getAllFeeds(
        page: state.currentPage,
        pageSize: pageSize,
      );
      emit(state.copyWith(
        status: FeedListStatus.success,
        list: [...state.list, ...res],
        currentPage: state.currentPage + 1,
        isLastPage: res.length < pageSize,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FeedListStatus.error,
        errorMessage: '불러오는 도중 에러가 발생하였습니다.',
      ));
    }
  }
}

abstract class FeedListEvent extends Equatable {}

class LoadFeedListEvent extends FeedListEvent {
  @override
  List<Object?> get props => [];
}

class FeedListState extends Equatable {
  final FeedListStatus status;
  final List<FeedContentResponse> list;
  final String? errorMessage;
  final int currentPage;
  final bool isLastPage;

  const FeedListState({
    required this.status,
    required this.list,
    this.errorMessage,
    required this.currentPage,
    required this.isLastPage,
  });

  FeedListState.init()
      : this(
          status: FeedListStatus.init,
          list: [],
          currentPage: 0,
          isLastPage: false,
        );

  FeedListState copyWith({
    FeedListStatus? status,
    List<FeedContentResponse>? list,
    String? errorMessage,
    int? currentPage,
    bool? isLastPage,
  }) {
    return FeedListState(
      status: status ?? this.status,
      list: list ?? this.list,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props =>
      [status, list, errorMessage, currentPage, isLastPage];
}
