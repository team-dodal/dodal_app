import 'dart:io';
import 'package:dodal_app/model/tag_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallenge {
  String? title, content, certContent;
  File? thumbnailImg, certCorrectImg, certWrongImg;
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
    File? thumbnailImg,
    File? certCorrectImg,
    File? certWrongImg,
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
  CreateChallengeCubit()
      : super(
          CreateChallenge(
            title: '',
            content: '',
            certContent: '',
            tagValue: null,
            thumbnailImg: null,
            certCorrectImg: null,
            certWrongImg: null,
            recruitCnt: null,
            certCnt: 1,
          ),
        );

  updateData({
    String? title,
    String? content,
    String? certContent,
    Tag? tagValue,
    File? thumbnailImg,
    File? certCorrectImg,
    File? certWrongImg,
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
