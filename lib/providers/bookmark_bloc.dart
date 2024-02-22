import 'package:dodal_app/services/challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum BookmarkStatus { initial, loading, success, error }

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final int roomId;
  final void Function(int roomId)? successCallback;

  BookmarkBloc({
    required this.roomId,
    required bool isBookmarked,
    this.successCallback,
  }) : super(BookmarkState.init(isBookmarked)) {
    on<ChangeBookmarkEvent>(_onChangeBookmark);
  }
  _onChangeBookmark(ChangeBookmarkEvent event, emit) async {
    emit(state.copyWith(status: BookmarkStatus.loading));
    try {
      bool res = await ChallengeService.bookmark(
        roomId: roomId,
        value: !state.isBookmarked,
      );
      emit(state.copyWith(
        status: BookmarkStatus.success,
        isBookmarked: res,
      ));
      if (successCallback != null) {
        successCallback!(roomId);
      }
    } catch (error) {
      emit(state.copyWith(
        status: BookmarkStatus.error,
        errorMessage: '북마크 변경에 실패했습니다.',
      ));
    }
  }
}

abstract class BookmarkEvent extends Equatable {}

class ChangeBookmarkEvent extends BookmarkEvent {
  @override
  List<Object?> get props => [];
}

class BookmarkState extends Equatable {
  final BookmarkStatus status;
  final String? errorMessage;
  final bool isBookmarked;

  const BookmarkState({
    required this.status,
    this.errorMessage,
    required this.isBookmarked,
  });

  const BookmarkState.init(bool isBookmarked)
      : this(
          status: BookmarkStatus.initial,
          isBookmarked: isBookmarked,
        );

  BookmarkState copyWith({
    BookmarkStatus? status,
    String? errorMessage,
    bool? isBookmarked,
  }) {
    return BookmarkState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, isBookmarked];
}