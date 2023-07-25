import 'dart:io';

import 'package:dodal_app/utilities/social_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm {
  final SocialType socialType;
  final String socialId, email;
  late String? nickname, content;
  late File? image;
  late List<String>? category;

  SignUpForm({
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
    List<String>? category,
  }) {
    return SignUpForm(
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

class SignUpFormCubit extends Cubit<SignUpForm> {
  final SocialType socialType;
  final String socialId, email;

  SignUpFormCubit({
    required this.socialId,
    required this.email,
    required this.socialType,
  }) : super(
          SignUpForm(
            socialId: socialId,
            email: email,
            nickname: null,
            image: null,
            content: null,
            category: [],
            socialType: socialType,
          ),
        );

  updateData(
    String? nickname,
    String? content,
    File? image,
    List<String>? category,
  ) {
    final updatedState = state.copyWith(
      nickname: nickname,
      image: image,
      content: content,
      category: category,
    );

    emit(updatedState);
  }
}
