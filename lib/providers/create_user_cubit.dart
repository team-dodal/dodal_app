import 'dart:io';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserCubit extends Cubit<CreateUser> {
  final SocialType socialType;
  final String socialId;
  final String email;

  CreateUserCubit({
    required this.socialId,
    required this.email,
    required this.socialType,
  }) : super(CreateUser.init(
          socialId: socialId,
          email: email,
          socialType: socialType,
        ));

  updateNickname(String nickname) {
    emit(state.copyWith(nickname: nickname));
  }

  updateContent(String content) {
    emit(state.copyWith(content: content));
  }

  updateImage(File? image) {
    emit(state.copyWith(image: image));
  }

  updateCategory(List<Tag> category) {
    emit(state.copyWith(category: category));
  }
}

class CreateUser extends Equatable {
  final SocialType socialType;
  final String socialId;
  final String email;
  final String nickname;
  final String content;
  final File? image;
  final List<Tag> category;

  const CreateUser({
    required this.socialId,
    required this.email,
    required this.socialType,
    required this.nickname,
    required this.image,
    required this.content,
    required this.category,
  });

  CreateUser.init({
    required String socialId,
    required String email,
    required SocialType socialType,
  }) : this(
          socialId: socialId,
          email: email,
          nickname: '',
          image: null,
          content: '',
          category: [],
          socialType: socialType,
        );

  CreateUser copyWith({
    String? nickname,
    String? content,
    File? image,
    List<Tag>? category,
  }) {
    return CreateUser(
      socialId: socialId,
      email: email,
      socialType: socialType,
      nickname: nickname ?? this.nickname,
      image: image ?? this.image,
      content: content ?? this.content,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props =>
      [socialType, socialId, email, nickname, content, image, category];
}
