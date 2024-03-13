import 'package:dodal_app/src/common/repositories/feed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedReactCubit extends Cubit<FeedLikeState> {
  final int _feedId;
  FeedReactCubit(
    this._feedId, {
    required bool isLiked,
    required int likeCount,
    required int commentCount,
  }) : super(FeedLikeState(
          isLiked: isLiked,
          likeCount: likeCount,
          commentCount: commentCount,
        ));

  void changeLike() async {
    try {
      await FeedRepository.feedLike(
        feedId: _feedId,
        value: !state.isLiked,
      );
      state.isLiked ? _unLike() : _like();
    } catch (error) {}
  }

  void changeCommentCount(int count) {
    emit(state.copyWith(commentCount: count));
  }

  void _unLike() {
    emit(state.copyWith(
      isLiked: false,
      likeCount: state.likeCount - 1,
    ));
  }

  void _like() {
    emit(state.copyWith(
      isLiked: true,
      likeCount: state.likeCount + 1,
    ));
  }
}

class FeedLikeState extends Equatable {
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  const FeedLikeState({
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
  });

  copyWith({
    bool? isLiked,
    int? likeCount,
    int? commentCount,
  }) {
    return FeedLikeState(
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  @override
  List<Object?> get props => [isLiked, likeCount, commentCount];
}
