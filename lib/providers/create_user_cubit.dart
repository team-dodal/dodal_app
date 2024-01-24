import 'dart:io';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  final SocialType socialType;
  final String socialId;
  final String email;

  CreateUserCubit({
    required this.socialId,
    required this.email,
    required this.socialType,
  }) : super(CreateUserState.init(
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

  handleTag(Tag tag) {
    List<Tag> cloneList = [...state.category];
    bool isSelected = cloneList.contains(tag);
    isSelected ? cloneList.remove(tag) : cloneList.add(tag);
    emit(state.copyWith(category: cloneList));
  }

  Future<Map<String, String>?> createUser() async {
    SignUpResponse? res = await UserService.signUp(
      socialType: state.socialType,
      socialId: state.socialId,
      email: state.email,
      nickname: state.nickname,
      profile: state.image,
      content: state.content,
      category: state.category.map((e) => e.value as String).toList(),
    );
    if (res == null) return null;
    return {"accessToken": res.accessToken!, "refreshToken": res.refreshToken!};
  }
}

class CreateUserState extends Equatable {
  final SocialType socialType;
  final String socialId;
  final String email;
  final String nickname;
  final String content;
  final File? image;
  final List<Tag> category;

  const CreateUserState({
    required this.socialId,
    required this.email,
    required this.socialType,
    required this.nickname,
    required this.image,
    required this.content,
    required this.category,
  });

  CreateUserState.init({
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

  CreateUserState copyWith({
    String? nickname,
    String? content,
    File? image,
    List<Tag>? category,
  }) {
    return CreateUserState(
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
