import 'dart:io';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUser {
  final SocialType socialType;
  final String socialId, email;
  late String nickname, content;
  late File? image;
  late List<String?> category;

  CreateUser({
    required this.socialId,
    required this.email,
    required this.socialType,
    required this.nickname,
    required this.image,
    required this.content,
    required this.category,
  });

  copyWith({
    String? nickname,
    String? content,
    File? image,
    List<String?>? category,
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
}

class CreateUserCubit extends Cubit<CreateUser> {
  final SocialType socialType;
  final String socialId, email;

  CreateUserCubit({
    required this.socialId,
    required this.email,
    required this.socialType,
  }) : super(
          CreateUser(
            socialId: socialId,
            email: email,
            nickname: '',
            image: null,
            content: '',
            category: [],
            socialType: socialType,
          ),
        );

  updateData({
    String? nickname,
    String? content,
    File? image,
    List<String?>? category,
  }) {
    final updatedState = state.copyWith(
      nickname: nickname,
      image: image,
      content: content,
      category: category,
    );

    emit(updatedState);
  }
}
