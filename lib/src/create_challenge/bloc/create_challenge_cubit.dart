import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/tag_model.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengeBloc
    extends Bloc<CreateChallengeEvent, CreateChallengeState> {
  final int? roomId;
  CreateChallengeBloc({
    this.roomId,
    String? title,
    String? content,
    String? certContent,
    dynamic thumbnailImg,
    dynamic certCorrectImg,
    dynamic certWrongImg,
    int? recruitCnt,
    int? certCnt,
    Tag? tagValue,
  }) : super(
          CreateChallengeState.init(
            isUpdate: roomId != null,
            title: title,
            content: content,
            certContent: certContent,
            thumbnailImg: thumbnailImg,
            certCorrectImg: certCorrectImg,
            certWrongImg: certWrongImg,
            recruitCnt: recruitCnt,
            certCnt: certCnt,
            tagValue: tagValue,
          ),
        ) {
    on<SubmitCreateChallengeEvent>(_submit);
    on<ChangeTitleEvent>((ChangeTitleEvent event, emit) {
      emit(state.copyWith(title: event.title));
    });
    on<ChangeContentEvent>((ChangeContentEvent event, emit) {
      emit(state.copyWith(content: event.content));
    });
    on<ChangeTagEvent>((ChangeTagEvent event, emit) {
      emit(state.copyWith(tagValue: event.tag));
    });
    on<ChangeRecruitCntEvent>((ChangeRecruitCntEvent event, emit) {
      emit(state.copyWith(recruitCnt: event.recruitCnt));
    });
    on<ChangeCertCntEvent>((ChangeCertCntEvent event, emit) {
      emit(state.copyWith(certCnt: event.certCnt));
    });
    on<ChangeCertContentEvent>((ChangeCertContentEvent event, emit) {
      emit(state.copyWith(certContent: event.certContent));
    });
    on<ChangeThumbnailImgEvent>((ChangeThumbnailImgEvent event, emit) {
      emit(state.copyWith(thumbnailImg: event.thumbnailImg));
    });
    on<ChangeCertCorrectImgEvent>((ChangeCertCorrectImgEvent event, emit) {
      emit(state.copyWith(certCorrectImg: event.certCorrectImg));
    });
    on<ChangeCertWrongImgEvent>((ChangeCertWrongImgEvent event, emit) {
      emit(state.copyWith(certWrongImg: event.certWrongImg));
    });
  }

  Future<void> _submit(SubmitCreateChallengeEvent event, emit) async {
    emit(state.copyWith(status: CommonStatus.loading));
    try {
      state.isUpdate ? await _update() : await _create();
      emit(state.copyWith(status: CommonStatus.loaded));
    } catch (error) {
      emit(
        state.copyWith(
          status: CommonStatus.error,
          errorMessage: '챌린지 생성에 실패하였습니다.',
        ),
      );
    }
  }

  Future<void> _update() async {
    await ChallengeRepository.updateChallenge(
      id: roomId!,
      title: state.title,
      content: state.content,
      tagValue: state.tagValue!.value,
      recruitCnt: state.recruitCnt,
      certCnt: state.certCnt,
      certContent: state.certContent,
      thumbnailImg: state.thumbnailImg,
      certCorrectImg: state.certCorrectImg,
      certWrongImg: state.certWrongImg,
    );
  }

  Future<void> _create() async {
    await ChallengeRepository.createChallenge(
      title: state.title,
      content: state.content,
      thumbnailImg: state.thumbnailImg,
      tagValue: state.tagValue!.value,
      recruitCnt: state.recruitCnt,
      certCnt: state.certCnt,
      certContent: state.certContent,
      certCorrectImg: state.certCorrectImg,
      certWrongImg: state.certWrongImg,
    );
  }
}

abstract class CreateChallengeEvent extends Equatable {}

class SubmitCreateChallengeEvent extends CreateChallengeEvent {
  @override
  List<Object?> get props => [];
}

class ChangeTitleEvent extends CreateChallengeEvent {
  final String title;
  ChangeTitleEvent(this.title);
  @override
  List<Object?> get props => [title];
}

class ChangeContentEvent extends CreateChallengeEvent {
  final String content;
  ChangeContentEvent(this.content);
  @override
  List<Object?> get props => [content];
}

class ChangeTagEvent extends CreateChallengeEvent {
  final Tag tag;
  ChangeTagEvent(this.tag);
  @override
  List<Object?> get props => [tag];
}

class ChangeRecruitCntEvent extends CreateChallengeEvent {
  final int recruitCnt;
  ChangeRecruitCntEvent(this.recruitCnt);
  @override
  List<Object?> get props => [recruitCnt];
}

class ChangeCertCntEvent extends CreateChallengeEvent {
  final int certCnt;
  ChangeCertCntEvent(this.certCnt);
  @override
  List<Object?> get props => [certCnt];
}

class ChangeCertContentEvent extends CreateChallengeEvent {
  final String certContent;
  ChangeCertContentEvent(this.certContent);
  @override
  List<Object?> get props => [certContent];
}

class ChangeThumbnailImgEvent extends CreateChallengeEvent {
  final dynamic thumbnailImg;
  ChangeThumbnailImgEvent(this.thumbnailImg);
  @override
  List<Object?> get props => [thumbnailImg];
}

class ChangeCertCorrectImgEvent extends CreateChallengeEvent {
  final dynamic certCorrectImg;
  ChangeCertCorrectImgEvent(this.certCorrectImg);
  @override
  List<Object?> get props => [certCorrectImg];
}

class ChangeCertWrongImgEvent extends CreateChallengeEvent {
  final dynamic certWrongImg;
  ChangeCertWrongImgEvent(this.certWrongImg);
  @override
  List<Object?> get props => [certWrongImg];
}

class CreateChallengeState extends Equatable {
  final CommonStatus status;
  final String? errorMessage;
  final bool isUpdate;
  final String title;
  final String content;
  final String certContent;
  final dynamic thumbnailImg;
  final dynamic certCorrectImg;
  final dynamic certWrongImg;
  final int recruitCnt;
  final int certCnt;
  final Tag? tagValue;

  const CreateChallengeState({
    required this.status,
    this.errorMessage,
    required this.isUpdate,
    required this.title,
    required this.content,
    required this.certContent,
    required this.thumbnailImg,
    required this.certCorrectImg,
    required this.certWrongImg,
    required this.recruitCnt,
    required this.certCnt,
    required this.tagValue,
  });

  const CreateChallengeState.init({
    required bool isUpdate,
    required String? title,
    required String? content,
    required String? certContent,
    required dynamic thumbnailImg,
    required dynamic certCorrectImg,
    required dynamic certWrongImg,
    required int? recruitCnt,
    required int? certCnt,
    required Tag? tagValue,
  }) : this(
          status: CommonStatus.init,
          isUpdate: isUpdate,
          title: title ?? '',
          content: content ?? '',
          certContent: certContent ?? '',
          thumbnailImg: thumbnailImg,
          certCorrectImg: certCorrectImg,
          certWrongImg: certWrongImg,
          recruitCnt: recruitCnt ?? 0,
          certCnt: certCnt ?? 1,
          tagValue: tagValue,
        );

  CreateChallengeState copyWith({
    CommonStatus? status,
    String? errorMessage,
    String? title,
    String? content,
    String? certContent,
    dynamic thumbnailImg,
    dynamic certCorrectImg,
    dynamic certWrongImg,
    int? recruitCnt,
    int? certCnt,
    Tag? tagValue,
  }) {
    return CreateChallengeState(
      status: status ?? this.status,
      isUpdate: isUpdate,
      title: title ?? this.title,
      content: content ?? this.content,
      certContent: certContent ?? this.certContent,
      thumbnailImg: thumbnailImg ?? this.thumbnailImg,
      certCorrectImg: certCorrectImg ?? this.certCorrectImg,
      certWrongImg: certWrongImg ?? this.certWrongImg,
      recruitCnt: recruitCnt ?? this.recruitCnt,
      certCnt: certCnt ?? this.certCnt,
      tagValue: tagValue ?? this.tagValue,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        title,
        content,
        certContent,
        thumbnailImg,
        certCorrectImg,
        certWrongImg,
        recruitCnt,
        certCnt,
        tagValue,
      ];
}
