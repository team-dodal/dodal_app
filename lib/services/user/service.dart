import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/common/presigned_s3.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/utilities/social_auth.dart';

class UserService {
  static final service = dio();

  static signIn(SocialType socialType, String socialId) async {
    try {
      final res = await service.post('/api/v1/users/sign-in',
          data: {"social_type": socialType.name, "social_id": socialId});

      final isSigned = res.data['result']['is_signed'] == 'true';
      if (isSigned) {
        return SignInResponse.fromJson(res.data['result']);
      } else {
        return null;
      }
    } on DioException {
      rethrow;
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
      final data = {
        "social_type": socialType.name,
        "social_id": socialId,
        "email": email,
        "nickname": nickname,
        "content": content,
        "tag_list": category,
      };

      if (profile != null) {
        String fileName = 'user_userProfile_date_${DateTime.now()}';
        String s3Url = await PresignedS3.upload(
          uploadUrl: await PresignedS3.getUrl(fileName: fileName),
          file: profile,
          fileName: fileName,
        );
        data['profile_url'] = s3Url;
      }

      final res = await service.post('/api/v1/users/sign-up', data: data);
      return SignUpResponse.fromJson(res.data['result']);
    } on DioException {
      rethrow;
    }
  }

  static Future<User?> user() async {
    try {
      final res = await service.get('/api/v1/users/me');
      return User.formJson(res.data['result']);
    } on DioException {
      rethrow;
    }
  }

  static updateUser({
    required String nickname,
    required String content,
    required dynamic profile,
    required List<String> tagList,
    String? profileUrl,
  }) async {
    String? s3Url;
    if (profile.runtimeType is String) {
      s3Url = profile;
    }
    if (profile.runtimeType.toString() == '_File') {
      String fileName = '${nickname}_${DateTime.now()}';
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
    if (s3Url != null) data['profile_url'] = s3Url;

    try {
      final res = await service.patch('/api/v1/users/me', data: data);
      return User.formJson(res.data['result']);
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static updateFcmToken(String token) async {
    try {
      await service.post('/api/v1/users/fcm-token', data: {'fcm_token': token});
    } on DioException catch (err) {
      ResponseErrorDialog(err);
    }
  }

  static checkNickName(String nickname) async {
    try {
      await service.get('/api/v1/users/nickname/$nickname');
      return true;
    } on DioException catch (err) {
      ResponseErrorDialog(err, '사용할 수 없는 닉네임 입니다.');
      return false;
    }
  }

  static removeUser() async {
    try {
      await service.delete('/api/v1/users/me');
    } on DioException catch (err) {
      ResponseErrorDialog(err);
    }
  }

  static Future<UsersRoomFeedResponse?> getUsersRoomFeed() async {
    try {
      final res = await service.get('/api/v1/users/my-page');
      return UsersRoomFeedResponse.fromJson(res.data['result']);
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static Future<FeedListByDateResponse> getFeedListByDate({
    required int roomId,
    required String dateYM,
  }) async {
    final res = await service.get(
      '/api/v1/users/my-page/challenge-room/$roomId?date_ym=$dateYM',
    );
    return FeedListByDateResponse.fromJson(res.data['result']);
  }
}
