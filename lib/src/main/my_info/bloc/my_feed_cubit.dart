import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/feed_content_model.dart';
import 'package:dodal_app/src/common/repositories/feed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyFeedCubit extends Cubit<MyFeedState> {
  final int _feedId;
  MyFeedCubit(this._feedId) : super(const MyFeedState.init()) {
    load();
  }

  void load() async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final result = await FeedRepository.getOneFeedById(feedId: _feedId);
      emit(state.copyWith(
        status: CommonStatus.loaded,
        item: result,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '피드를 불러오는데 실패했습니다.',
      ));
    }
  }
}

class MyFeedState extends Equatable {
  final CommonStatus status;
  final FeedContent? item;
  final String? errorMessage;

  const MyFeedState({
    required this.status,
    required this.item,
    this.errorMessage,
  });

  const MyFeedState.init()
      : this(
          status: CommonStatus.init,
          item: null,
        );

  copyWith({
    CommonStatus? status,
    FeedContent? item,
    String? errorMessage,
  }) {
    return MyFeedState(
      status: status ?? this.status,
      item: item ?? this.item,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, item, errorMessage];
}
