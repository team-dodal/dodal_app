import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/comment_model.dart';
import 'package:dodal_app/src/common/repositories/feed_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentBloc extends Bloc<CommentBlocEvent, CommentBlocState> {
  final int feedId;

  CommentBloc(this.feedId) : super(CommentBlocState.init()) {
    on<SubmitCommentBlocEvent>(_submitComment);
    on<LoadListCommentBlocEvent>(_loadCommentList);
    on<RemoveCommentBlocEvent>(_removeComment);
    add(LoadListCommentBlocEvent());
  }

  Future<void> _loadCommentList(LoadListCommentBlocEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await FeedRepository.getAllComments(feedId: feedId);
      emit(state.copyWith(status: CommonStatus.loaded, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '데이터를 불러오는 도중. 에러가 발생하였습니다.',
      ));
    }
  }

  Future<void> _removeComment(RemoveCommentBlocEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await FeedRepository.removeComment(
        feedId: feedId,
        commentId: event.commentId,
      );
      emit(state.copyWith(status: CommonStatus.loaded, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
  }

  Future<void> _submitComment(SubmitCommentBlocEvent event, emit) async {
    if (event.text.isEmpty) return;
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      final res = await FeedRepository.createComment(
        feedId: feedId,
        content: event.text,
      );
      emit(state.copyWith(status: CommonStatus.loaded, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
  }
}

abstract class CommentBlocEvent extends Equatable {}

class LoadListCommentBlocEvent extends CommentBlocEvent {
  @override
  List<Object?> get props => [];
}

class RemoveCommentBlocEvent extends CommentBlocEvent {
  final int commentId;
  RemoveCommentBlocEvent(this.commentId);
  @override
  List<Object?> get props => [commentId];
}

class SubmitCommentBlocEvent extends CommentBlocEvent {
  final String text;
  SubmitCommentBlocEvent(this.text);
  @override
  List<Object?> get props => [text];
}

class CommentBlocState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final List<CommentResponse> list;

  const CommentBlocState({
    required this.status,
    this.errorMessage,
    required this.list,
  });

  CommentBlocState.init()
      : this(
          status: CommonStatus.init,
          list: [],
        );

  CommentBlocState copyWith({
    CommonStatus? status,
    String? errorMessage,
    List<CommentResponse>? list,
  }) {
    return CommentBlocState(
      status: status ?? this.status,
      list: list ?? this.list,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, list];
}
