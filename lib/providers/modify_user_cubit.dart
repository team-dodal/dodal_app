import 'dart:io';
import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    emit(state.copyWith(nickname: nickname, image: state.image));
  }

  updateContent(String content) {
    emit(state.copyWith(content: content, image: state.image));
  }

  updateImage(File? image) {
    emit(state.copyWith(image: image));
  }

  handleTag(Tag tag) {
    List<Tag> cloneList = [...state.category];
    bool isSelected = cloneList.contains(tag);
    isSelected ? cloneList.remove(tag) : cloneList.add(tag);
    emit(state.copyWith(category: cloneList, image: state.image));
  }

  Future<void> modifyUser() async {
    emit(state.copyWith(status: CommonStatus.loading, image: state.image));
    try {
      User res = await UserService.updateUser(
        nickname: state.nickname,
        profile: state.image,
        content: state.content,
        tagList: state.category.map((e) => e.value as String).toList(),
      );
      emit(state.copyWith(
        status: CommonStatus.loaded,
        response: res,
        image: state.image,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: CommonStatus.error,
        errorMessage: '에러가 발생하였습니다.',
        image: state.image,
      ));
      rethrow;
    }
  }
}

class ModifyUserState extends Equatable {
  final CommonStatus status;
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
          status: CommonStatus.init,
          nickname: nickname,
          content: content,
          image: image,
          category: category,
        );

  ModifyUserState copyWith({
    CommonStatus? status,
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
