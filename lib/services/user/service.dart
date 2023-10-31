import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/common/presigned_s3.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/utilities/social_auth.dart';

class UserService {
  static signIn(SocialType socialType, String socialId) async {
    try {
      final service = dio();
      final res = await service.post('/api/v1/users/sign-in',
          data: {"social_type": socialType.name, "social_id": socialId});

      final isSigned = res.data['result']['is_signed'] == 'true';
      if (isSigned) {
        return SignInResponse.fromJson(res.data['result']);
      } else {
        return null;
      }
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
    required String content,
    required File? profile,
    required List<String> tagList,
  }) async {
    late String s3Url;
    if (profile != null) {
      String fileName = 'user_${nickname}_date_${DateTime.now()}';
      s3Url = await PresignedS3.upload(
        uploadUrl: await PresignedS3.getUrl(fileName: fileName),
        file: profile,
        fileName: fileName,
      );
    }

    final data = {
      "nickname": nickname,
      "content": content,
      "tag_list": tagList,
    };
    if (profile != null) data['profile_url'] = s3Url;

    try {
      final service = dio();
      final res = await service.patch('/api/v1/users/me', data: data);
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

  static Future<UserResponse?> me() async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/users/my-page');
      return UserResponse.fromJson(res.data['result']);
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static Future<FeedListByDateResponse?> getFeedListByDate({
    required int roomId,
    required String dateYM,
  }) async {
    try {
      final service = dio();
      final res = await service.get(
        '/api/v1/users/my-page/challenge-room/$roomId?date_ym=$dateYM',
      );
      return FeedListByDateResponse.fromJson(res.data['result']);
    } on DioException catch (err) {
      print(err);
      ResponseErrorDialog(err);
      return null;
    }
  }
}
