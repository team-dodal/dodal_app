import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/utilities/social_auth.dart';

class UserService {
  static signIn(SocialType socialType, String socialId) async {
    try {
      final service = dio();
      final res = await service.post('/api/v1/users/sign-in',
          data: {"social_type": socialType.name, "social_id": socialId});
      return SignInResponse.fromJson(res.data['result']);
    } on DioException catch (error) {
      ResponseErrorDialog(error);
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
      ResponseErrorDialog(err, err.response!.data['result']);
      return null;
    }
  }

  static Future<User?> user() async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/users/me');
      return User.formJson(res.data['result']);
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
      return User.formJson(res.data['result']);
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
      ResponseErrorDialog(err, '사용할 수 없는 닉네임 입니다.');
      return false;
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
