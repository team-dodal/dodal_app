import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'common/main.dart';

class SignUpResponse {
  String? accessToken, refreshToken;

  SignUpResponse.fromJson(Map<String, dynamic> data)
      : accessToken = data['access_token'],
        refreshToken = data['refresh_token'];
}

class UserResponse {
  final int? id;
  final String? email, nickname, content, profileUrl, socialType;
  final DateTime? registerAt;
  final List<Tag>? tagList;

  UserResponse.formJson(Map<String, dynamic> data)
      : id = data['user_id'],
        email = data['email'],
        nickname = data['nickname'],
        content = data['content'],
        profileUrl = data['profile_url'],
        registerAt = data['register_at'] != null
            ? DateTime.parse(data['register_at'])
            : null,
        socialType = data['social_type'],
        tagList = (data['tag_list'] as List<dynamic>?)
                ?.map((e) => Tag(name: e['name'], value: e['value']))
                .toList() ??
            [];
}

class SignInResponse extends UserResponse {
  final String? accessToken, refreshToken;
  final bool isSigned;

  SignInResponse.fromJson(Map<String, dynamic> data)
      : accessToken = data['access_token'],
        refreshToken = data['refresh_token'],
        isSigned = data['is_signed']!.toLowerCase() == 'true',
        super.formJson(data);
}

class ModifyUserResponse extends UserResponse {
  ModifyUserResponse.fromJson(Map<String, dynamic> data) : super.formJson(data);
}

class UserService {
  static signIn(SocialType socialType, String socialId) async {
    try {
      final service = dio();
      final res = await service.post('/api/v1/users/sign-in',
          data: {"social_type": socialType.name, "social_id": socialId});
      return SignInResponse.fromJson(res.data['result']);
    } on DioException catch (err) {
      throw Exception(err);
    }
  }

  static signUp({
    required SocialType socialType,
    required String socialId,
    required String email,
    required String nickname,
    required File? profile,
    required String content,
    required List<String?> category,
  }) async {
    try {
      final service = dio();
      final formData = FormData.fromMap({
        "social_type": socialType.name,
        "social_id": socialId,
        "email": email,
        "nickname": nickname,
        "content": content,
        "tag_list": category,
      });
      if (profile != null) {
        formData.files.add(MapEntry(
          'profile',
          await MultipartFile.fromFile(profile.path),
        ));
      }
      final res = await service.post('/api/v1/users/sign-up', data: formData);
      return SignUpResponse.fromJson(res.data['result']);
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static Future<UserResponse?> user() async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/users/me');
      return UserResponse.formJson(res.data['result']);
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static updateUser({
    required String nickname,
    required String? profileUrl,
    required File? profile,
    required String content,
    required List<String> category,
  }) async {
    FormData formData = FormData.fromMap({
      "nickname": nickname,
      "content": content,
      "tag_list": category,
    });
    if (profile != null) {
      formData.files.add(MapEntry(
        'profile',
        await MultipartFile.fromFile(profile.path),
      ));
    }
    if (profileUrl != null) {
      formData.fields.add(MapEntry('profile_url', profileUrl));
    }

    try {
      final service = dio();
      service.options.contentType = 'multipart/form-data';
      final res = await service.patch('/api/v1/users/me', data: formData);
      return ModifyUserResponse.fromJson(res.data['result']);
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static updateFcmToken(String token) async {
    try {
      final service = dio();
      await service.post('/api/v1/users/fcm-token', data: {'fcm_token': token});
    } on DioException catch (err) {
      ResponseErrorDialog(err);
    }
  }

  static checkNickName(String nickname) async {
    try {
      final service = dio();
      await service.get('/api/v1/users/nickname/$nickname');
      return true;
    } on DioException catch (err) {
      ResponseErrorDialog(err);
    }
  }

  static removeUser() async {
    try {
      final service = dio();
      await service.delete('/api/v1/users/me');
    } on DioException catch (err) {
      ResponseErrorDialog(err);
    }
  }
}
