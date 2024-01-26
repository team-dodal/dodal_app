import 'dart:io';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModifyUserCubit extends Cubit<ModifyUserState> {
  late String nickname;
  late String content;
  late dynamic image;
  late List<Tag> category;

  ModifyUserCubit({
    required String nickname,
    required String content,
    required dynamic image,
    required List<Tag> category,
  }) : super(
          ModifyUserState.init(
            nickname: nickname,
            content: content,
            image: image,
            category: category,
          ),
        );

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

  Future<User?> modifyUser() async {
    User? res = await UserService.updateUser(
      nickname: state.nickname,
      profile: state.image,
      content: state.content,
      tagList: state.category.map((e) => e.value as String).toList(),
    );
    if (res == null) return null;
    return res;
  }
}

class ModifyUserState extends Equatable {
  final String nickname;
  final String content;
  final dynamic image;
  final List<Tag> category;

  const ModifyUserState({
    required this.nickname,
    required this.image,
    required this.content,
    required this.category,
  });

  const ModifyUserState.init({
    required String nickname,
    required String content,
    required dynamic image,
    required List<Tag> category,
  }) : this(
          nickname: nickname,
          image: image,
          content: content,
          category: category,
        );

  ModifyUserState copyWith({
    String? nickname,
    String? content,
    File? image,
    List<Tag>? category,
  }) {
    return ModifyUserState(
      nickname: nickname ?? this.nickname,
      image: image ?? this.image,
      content: content ?? this.content,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [nickname, content, image, category];
}
