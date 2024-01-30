import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallenge {
  String? title, content, certContent;
  dynamic thumbnailImg, certCorrectImg, certWrongImg;
  int? recruitCnt, certCnt;
  Tag? tagValue;

  CreateChallenge({
    required this.title,
    required this.content,
    required this.certContent,
    required this.tagValue,
    required this.thumbnailImg,
    required this.certCorrectImg,
    required this.certWrongImg,
    required this.recruitCnt,
    required this.certCnt,
  });

  copyWith({
    String? title,
    String? content,
    String? certContent,
    Tag? tagValue,
    dynamic thumbnailImg,
    dynamic certCorrectImg,
    dynamic certWrongImg,
    int? recruitCnt,
    int? certCnt,
  }) {
    return CreateChallenge(
      title: title ?? this.title,
      content: content ?? this.content,
      certContent: certContent ?? this.certContent,
      tagValue: tagValue ?? this.tagValue,
      thumbnailImg: thumbnailImg ?? this.thumbnailImg,
      certCorrectImg: certCorrectImg ?? this.certCorrectImg,
      certWrongImg: certWrongImg ?? this.certWrongImg,
      recruitCnt: recruitCnt ?? this.recruitCnt,
      certCnt: certCnt ?? this.certCnt,
    );
  }
}

class CreateChallengeCubit extends Cubit<CreateChallenge> {
  CreateChallengeCubit({
    String? title,
    String? content,
    String? certContent,
    Tag? tagValue,
    String? thumbnailImg,
    String? certCorrectImg,
    String? certWrongImg,
    int? recruitCnt,
    int? certCnt,
  }) : super(
          CreateChallenge(
            title: title ?? '',
            content: content ?? '',
            certContent: certContent ?? '',
            tagValue: tagValue,
            thumbnailImg: thumbnailImg,
            certCorrectImg: certCorrectImg,
            certWrongImg: certWrongImg,
            recruitCnt: recruitCnt,
            certCnt: certCnt ?? 1,
          ),
        );

  updateData({
    String? title,
    String? content,
    String? certContent,
    Tag? tagValue,
    dynamic thumbnailImg,
    dynamic certCorrectImg,
    dynamic certWrongImg,
    int? recruitCnt,
    int? certCnt,
  }) {
    final updatedState = state.copyWith(
      title: title,
      content: content,
      certContent: certContent,
      tagValue: tagValue,
      thumbnailImg: thumbnailImg,
      certCorrectImg: certCorrectImg,
      certWrongImg: certWrongImg,
      recruitCnt: recruitCnt,
      certCnt: certCnt,
    );

    emit(updatedState);
  }
}

enum CreateChallengeStatus { init, loading, success, error }

class CreateChallengeBloc
    extends Bloc<CreateChallengeEvent, CreateChallengeState> {
  CreateChallengeBloc({
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
          title != null
              ? CreateChallengeState.updateInit(
                  title,
                  content!,
                  certContent!,
                  thumbnailImg,
                  certCorrectImg,
                  certWrongImg,
                  recruitCnt!,
                  certCnt!,
                  tagValue!,
                )
              : const CreateChallengeState.createInit(),
        ) {
    on<SubmitCreateChallengeEvent>(_submit);
    on<ChangeTitleEvent>(_changeTitle);
    on<ChangeContentEvent>(_changeContent);
    on<ChangeTagEvent>(_changeTag);
    on<ChangeRecruitCntEvent>(_changeRecruitCnt);
    on<ChangeCertCntEvent>(_changeCertCnt);
    on<ChangeCertContentEvent>(_changeCertContent);
    on<ChangeThumbnailImgEvent>(_changeThumbnail);
    on<ChangeCertCorrectImgEvent>(_changeCertCorrectImg);
    on<ChangeCertWrongImgImgEvent>(_changeCertWrongImg);
  }

  void _changeTitle(ChangeTitleEvent event, emit) {
    emit(state.copyWith(title: event.title));
  }

  void _changeContent(ChangeContentEvent event, emit) {
    emit(state.copyWith(content: event.content));
  }

  void _changeTag(ChangeTagEvent event, emit) {
    emit(state.copyWith(tagValue: event.tag));
  }

  void _changeRecruitCnt(ChangeRecruitCntEvent event, emit) {
    emit(state.copyWith(recruitCnt: event.recruitCnt));
  }

  void _changeCertCnt(ChangeCertCntEvent event, emit) {
    emit(state.copyWith(certCnt: event.certCnt));
  }

  void _changeCertContent(ChangeCertContentEvent event, emit) {
    emit(state.copyWith(certContent: event.certContent));
  }

  void _changeThumbnail(ChangeThumbnailImgEvent event, emit) {
    emit(state.copyWith(thumbnailImg: event.thumbnailImg));
  }

  void _changeCertCorrectImg(ChangeCertCorrectImgEvent event, emit) {
    emit(state.copyWith(certCorrectImg: event.certCorrectImg));
  }

  void _changeCertWrongImg(ChangeCertWrongImgImgEvent event, emit) {
    emit(state.copyWith(certWrongImg: event.certWrongImg));
  }

  Future<void> _submit(SubmitCreateChallengeEvent event, emit) async {
    emit(state.copyWith(status: CreateChallengeStatus.loading));
    late bool res;
    if (state.isUpdate) {
      res = await _update(event.roomId!);
    } else {
      res = await _create();
    }
    emit(
      state.copyWith(
          status: res
              ? CreateChallengeStatus.success
              : CreateChallengeStatus.error),
    );
  }

  Future<bool> _update(int roomId) async {
    final res = await ChallengeService.updateChallenge(
      id: roomId,
      title: state.title,
      content: state.content,
      tagValue: state.tagValue!.value,
      recruitCnt: state.recruitCnt!,
      certCnt: state.certCnt!,
      certContent: state.certContent,
      thumbnailImg: state.thumbnailImg,
      certCorrectImg: state.certCorrectImg,
      certWrongImg: state.certWrongImg,
    );
    if (res == null) return false;
    return true;
  }

  Future<bool> _create() async {
    final res = await ChallengeService.createChallenge(
      title: state.title,
      content: state.content,
      thumbnailImg: state.thumbnailImg,
      tagValue: state.tagValue!.value,
      recruitCnt: state.recruitCnt!,
      certCnt: state.certCnt!,
      certContent: state.certContent,
      certCorrectImg: state.certCorrectImg,
      certWrongImg: state.certWrongImg,
    );
    if (res == null) return false;
    return true;
  }
}

abstract class CreateChallengeEvent extends Equatable {}

class SubmitCreateChallengeEvent extends CreateChallengeEvent {
  final int? roomId;
  SubmitCreateChallengeEvent(this.roomId);
  @override
  List<Object?> get props => [roomId];
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

class ChangeCertWrongImgImgEvent extends CreateChallengeEvent {
  final dynamic certWrongImg;
  ChangeCertWrongImgImgEvent(this.certWrongImg);
  @override
  List<Object?> get props => [certWrongImg];
}

class CreateChallengeState extends Equatable {
  final CreateChallengeStatus status;
  final String? errorMessage;
  final bool isUpdate;
  final String title;
  final String content;
  final String certContent;
  final dynamic thumbnailImg;
  final dynamic certCorrectImg;
  final dynamic certWrongImg;
  final int? recruitCnt;
  final int? certCnt;
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

  const CreateChallengeState.createInit()
      : this(
          status: CreateChallengeStatus.init,
          isUpdate: false,
          title: '',
          content: '',
          certContent: '',
          thumbnailImg: null,
          certCorrectImg: null,
          certWrongImg: null,
          recruitCnt: 0,
          certCnt: 0,
          tagValue: null,
        );

  const CreateChallengeState.updateInit(
    String title,
    String content,
    String certContent,
    dynamic thumbnailImg,
    dynamic certCorrectImg,
    dynamic certWrongImg,
    int recruitCnt,
    int certCnt,
    Tag tagValue,
  ) : this(
          status: CreateChallengeStatus.init,
          isUpdate: true,
          title: title,
          content: content,
          certContent: certContent,
          thumbnailImg: thumbnailImg,
          certCorrectImg: certCorrectImg,
          certWrongImg: certWrongImg,
          recruitCnt: recruitCnt,
          certCnt: certCnt,
          tagValue: tagValue,
        );

  CreateChallengeState copyWith({
    CreateChallengeStatus? status,
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
