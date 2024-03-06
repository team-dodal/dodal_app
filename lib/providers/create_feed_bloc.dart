import 'dart:io';

import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/utilities/add_watermark.dart';
import 'package:dodal_app/utilities/image_compress.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateFeedBloc extends Bloc<CreateFeedEvent, CreateFeedState> {
  CreateFeedBloc() : super(const CreateFeedState.init()) {
    on<ChangeContentCreateFeedEvent>(_changeContent);
    on<ChangeImageCreateFeedEvent>(_changeImage);
    on<SubmitCreateFeedEvent>(_submitFeed);
  }

  void _changeContent(ChangeContentCreateFeedEvent event, emit) {
    emit(state.copyWith(content: event.content));
  }

  void _changeImage(ChangeImageCreateFeedEvent event, emit) {
    emit(state.copyWith(image: event.image));
  }

  Future<void> _submitFeed(SubmitCreateFeedEvent event, emit) async {
    if (state.image == null) return;
    try {
      emit(state.copyWith(status: CommonStatus.loading));
      final file = await captureCreateImage(event.frameKey);
      if (file == null) return;
      final compressedFile = await imageCompress(file);

      await ChallengeService.createFeed(
        challengeId: event.challengeId,
        content: state.content,
        image: compressedFile,
      );
      emit(state.copyWith(status: CommonStatus.loaded));
    } catch (err) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '피드 생성에 실패하였습니다.',
      ));
    }
  }
}

abstract class CreateFeedEvent extends Equatable {}

class ChangeContentCreateFeedEvent extends CreateFeedEvent {
  final String content;
  ChangeContentCreateFeedEvent(this.content);
  @override
  List<Object?> get props => [content];
}

class ChangeImageCreateFeedEvent extends CreateFeedEvent {
  final File? image;
  ChangeImageCreateFeedEvent(this.image);
  @override
  List<Object?> get props => [image];
}

class SubmitCreateFeedEvent extends CreateFeedEvent {
  final int challengeId;
  final GlobalKey frameKey;
  SubmitCreateFeedEvent(this.challengeId, this.frameKey);
  @override
  List<Object?> get props => [challengeId, frameKey];
}

class CreateFeedState extends Equatable {
  final CommonStatus status;
  final File? image;
  final String content;
  final String? errorMessage;

  const CreateFeedState({
    required this.status,
    required this.image,
    required this.content,
    this.errorMessage,
  });

  const CreateFeedState.init()
      : this(
          status: CommonStatus.init,
          image: null,
          content: '',
        );

  CreateFeedState copyWith({
    CommonStatus? status,
    File? image,
    String? content,
    String? errorMessage,
  }) {
    return CreateFeedState(
      status: status ?? this.status,
      image: image ?? this.image,
      content: content ?? this.content,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, image, content, errorMessage];
}
