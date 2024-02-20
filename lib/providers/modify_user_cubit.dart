import 'dart:io';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ModifyUserStatus { init, loading, success, error }

class ModifyUserCubit extends Cubit<ModifyUserState> {
  final String nickname;
  final String content;
  final dynamic image;
  final List<Tag> category;

  ModifyUserCubit({
    required this.nickname,
    required this.content,
    required this.image,
    required this.category,
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

  Future<void> modifyUser() async {
    emit(state.copyWith(
      status: ModifyUserStatus.loading,
      image: state.image,
    ));
    try {
      User res = await UserService.updateUser(
        nickname: state.nickname,
        profile: state.image,
        content: state.content,
        tagList: state.category.map((e) => e.value as String).toList(),
      );
      emit(state.copyWith(
        status: ModifyUserStatus.success,
        image: state.image,
        response: res,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: ModifyUserStatus.error,
        image: state.image,
        errorMessage: error.toString(),
      ));
      rethrow;
    }
  }
}

class ModifyUserState extends Equatable {
  final ModifyUserStatus status;
  final User? response;
  final String nickname;
  final String content;
  final dynamic image;
  final List<Tag> category;
  final String? errorMessage;

  const ModifyUserState({
    required this.status,
    required this.nickname,
    required this.image,
    required this.content,
    required this.category,
    this.response,
    this.errorMessage,
  });

  const ModifyUserState.init({
    required String nickname,
    required String content,
    required dynamic image,
    required List<Tag> category,
  }) : this(
          status: ModifyUserStatus.init,
          nickname: nickname,
          content: content,
          image: image,
          category: category,
        );

  ModifyUserState copyWith({
    ModifyUserStatus? status,
    String? nickname,
    String? content,
    dynamic image,
    List<Tag>? category,
    User? response,
    String? errorMessage,
  }) {
    return ModifyUserState(
      status: status ?? this.status,
      nickname: nickname ?? this.nickname,
      image: image,
      content: content ?? this.content,
      category: category ?? this.category,
      response: response ?? this.response,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, nickname, content, image, category, response, errorMessage];
}
