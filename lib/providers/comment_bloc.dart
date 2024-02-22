import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/services/feed/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CommentBlocStatus { init, loading, success, error }

class CommentBloc extends Bloc<CommentBlocEvent, CommentBlocState> {
  final int feedId;

  CommentBloc(this.feedId) : super(CommentBlocState.init()) {
    on<SubmitCommentBlocEvent>(_submitComment);
    on<LoadListCommentBlocEvent>(_loadCommentList);
    on<RemoveCommentBlocEvent>(_removeComment);
    add(LoadListCommentBlocEvent());
  }

  Future<void> _loadCommentList(LoadListCommentBlocEvent event, emit) async {
    emit(state.copyWith(status: CommentBlocStatus.loading));
    try {
      final res = await FeedService.getAllComments(feedId: feedId);
      emit(state.copyWith(status: CommentBlocStatus.success, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommentBlocStatus.error,
        errorMessage: '데이터를 불러오는 도중. 에러가 발생하였습니다.',
      ));
    }
  }

  Future<void> _removeComment(RemoveCommentBlocEvent event, emit) async {
    emit(state.copyWith(status: CommentBlocStatus.loading));
    try {
      final res = await FeedService.removeComment(
        feedId: feedId,
        commentId: event.commentId,
      );
      emit(state.copyWith(status: CommentBlocStatus.success, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommentBlocStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
  }

  Future<void> _submitComment(SubmitCommentBlocEvent event, emit) async {
    if (event.text.isEmpty) return;
    emit(state.copyWith(status: CommentBlocStatus.loading));
    try {
      final res = await FeedService.createComment(
        feedId: feedId,
        content: event.text,
      );
      emit(state.copyWith(status: CommentBlocStatus.success, list: res));
    } catch (error) {
      emit(state.copyWith(
        status: CommentBlocStatus.error,
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
  final CommentBlocStatus status;
  final String? errorMessage;
  final List<CommentResponse> list;

  const CommentBlocState({
    required this.status,
    this.errorMessage,
    required this.list,
  });

  CommentBlocState.init()
      : this(
          status: CommentBlocStatus.init,
          list: [],
        );

  CommentBlocState copyWith({
    CommentBlocStatus? status,
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
