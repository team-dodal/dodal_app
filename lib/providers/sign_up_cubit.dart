import 'dart:io';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SignUpStatus { init, loading, success, error }

class SignUpCubit extends Cubit<SignUpState> {
  final FlutterSecureStorage secureStorage;
  final SocialType socialType;
  final String socialId;
  final String email;

  SignUpCubit({
    required this.secureStorage,
    required this.socialId,
    required this.email,
    required this.socialType,
  }) : super(SignUpState.init());

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

  signUp() async {
    emit(state.copyWith(status: SignUpStatus.loading));
    try {
      SignUpResponse res = await UserService.signUp(
        socialType: socialType,
        socialId: socialId,
        email: email,
        nickname: state.nickname,
        profile: state.image,
        content: state.content,
        category: state.category.map((e) => e.value as String).toList(),
      );
      await secureStorage.write(key: 'accessToken', value: res.accessToken);
      await secureStorage.write(key: 'refreshToken', value: res.refreshToken);
      emit(state.copyWith(status: SignUpStatus.success, result: res.user));
    } catch (error) {
      emit(state.copyWith(
        status: SignUpStatus.error,
        errorMessage: '에러가 발생하였습니다.',
      ));
    }
  }
}

class SignUpState extends Equatable {
  final SignUpStatus status;
  final String? errorMessage;
  final User? result;
  final String nickname;
  final String content;
  final File? image;
  final List<Tag> category;

  const SignUpState({
    required this.status,
    this.errorMessage,
    required this.result,
    required this.nickname,
    required this.image,
    required this.content,
    required this.category,
  });

  SignUpState.init()
      : this(
          status: SignUpStatus.init,
          result: null,
          nickname: '',
          image: null,
          content: '',
          category: [],
        );

  SignUpState copyWith({
    SignUpStatus? status,
    String? errorMessage,
    User? result,
    String? nickname,
    String? content,
    File? image,
    List<Tag>? category,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      result: result ?? this.result,
      nickname: nickname ?? this.nickname,
      image: image ?? this.image,
      content: content ?? this.content,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, result, nickname, content, image, category];
}
