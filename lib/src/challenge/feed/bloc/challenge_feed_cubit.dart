import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/feed_content_model.dart';
import 'package:dodal_app/src/common/repositories/feed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const PAGE_SIZE = 10;

class ChallengeFeedCubit extends Cubit<ChallengeFeedState> {
  final int _roomId;
  ChallengeFeedCubit(this._roomId) : super(const ChallengeFeedState.init()) {
    load();
  }

  void load() async {
    if (state.status == CommonStatus.loading) return;
    if (state.status == CommonStatus.error) return;
    if (state.isLastPage) return;
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final result = await FeedRepository.getFeedsByRoomId(
        page: state.currentPage,
        pageSize: PAGE_SIZE,
        roomId: _roomId,
      );
      emit(state.copyWith(
        status: CommonStatus.loaded,
        feedList: List.unmodifiable([...state.feedList, ...result]),
        currentPage: state.currentPage + 1,
        isLastPage: result.length < PAGE_SIZE,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '피드를 불러오는데 실패했습니다.',
      ));
    }
  }
}

class ChallengeFeedState extends Equatable {
  final CommonStatus status;
  final List<FeedContent> feedList;
  final int currentPage;
  final bool isLastPage;
  final String? errorMessage;

  const ChallengeFeedState({
    required this.status,
    required this.feedList,
    required this.currentPage,
    required this.isLastPage,
    this.errorMessage,
  });

  const ChallengeFeedState.init()
      : this(
          status: CommonStatus.init,
          feedList: const [],
          currentPage: 0,
          isLastPage: false,
        );

  ChallengeFeedState copyWith({
    CommonStatus? status,
    List<FeedContent>? feedList,
    int? currentPage,
    bool? isLastPage,
    String? errorMessage,
  }) {
    return ChallengeFeedState(
      status: status ?? this.status,
      feedList: feedList ?? this.feedList,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, feedList, currentPage, isLastPage, errorMessage];
}
