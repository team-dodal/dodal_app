import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengeNoticeBloc
    extends Bloc<CreateChallengeNoticeEvent, CreateChallengeNoticeState> {
  final int roomId;
  CreateChallengeNoticeBloc({required this.roomId})
      : super(const CreateChallengeNoticeState.init()) {
    on<CreateEvent>(_create);
    on<ChangeTitleEvent>((event, emit) {
      emit(state.copyWith(title: event.title));
    });
    on<ChangeContentEvent>((event, emit) {
      emit(state.copyWith(content: event.content));
    });
  }

  Future<void> _create(CreateChallengeNoticeEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      await ChallengeService.createNotice(
        roomId: roomId,
        title: state.title,
        content: state.content,
      );
      emit(state.copyWith(status: CommonStatus.loaded));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
  }
}

abstract class CreateChallengeNoticeEvent extends Equatable {}

class CreateEvent extends CreateChallengeNoticeEvent {
  @override
  List<Object?> get props => [];
}

class ChangeTitleEvent extends CreateChallengeNoticeEvent {
  final String title;
  ChangeTitleEvent(this.title);
  @override
  List<Object?> get props => [title];
}

class ChangeContentEvent extends CreateChallengeNoticeEvent {
  final String content;
  ChangeContentEvent(this.content);
  @override
  List<Object?> get props => [content];
}

class CreateChallengeNoticeState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final String title;
  final String content;

  const CreateChallengeNoticeState({
    required this.status,
    this.errorMessage,
    required this.title,
    required this.content,
  });

  const CreateChallengeNoticeState.init()
      : this(
          status: CommonStatus.init,
          title: '',
          content: '',
          errorMessage: null,
        );

  CreateChallengeNoticeState copyWith({
    CommonStatus? status,
    String? errorMessage,
    String? title,
    String? content,
  }) {
    return CreateChallengeNoticeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, title, content];
}
