import 'dart:io';
import 'package:dodal_app/model/authentication_model.dart';
import 'package:dodal_app/model/user_calendar_data_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/model/users_rooms_info_model.dart';
import 'package:dodal_app/repositories/common/main.dart';
import 'package:dodal_app/repositories/presigned_url_repository.dart';
import 'package:dodal_app/utilities/social_auth.dart';

class UserRepository {
  static final service = dio();

  static signIn(SocialType socialType, String socialId) async {
    final res = await service.post('/api/v1/users/sign-in',
        data: {"social_type": socialType.name, "social_id": socialId});

    final isSigned = res.data['result']['is_signed'] == 'true';
    if (isSigned) {
      return Authentication.fromJson(res.data['result']);
    } else {
      return null;
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
    final data = {
      "social_type": socialType.name,
      "social_id": socialId,
      "email": email,
      "nickname": nickname,
      "content": content,
      "tag_list": category,
    };

    if (profile != null) {
      String s3Url = await PresignedUrlRepository.create(file: profile);
      data['profile_url'] = s3Url;
    }

    final res = await service.post('/api/v1/users/sign-up', data: data);
    return Authentication.fromJson(res.data['result']);
  }

  static Future<User?> user() async {
    final res = await service.get('/api/v1/users/me');
    return User.fromJson(res.data['result']);
  }

  static updateUser({
    required String nickname,
    required String content,
    required dynamic profile,
    required List<String> tagList,
  }) async {
    String? s3Url;
    if (profile.runtimeType.toString() == 'String') {
      s3Url = profile;
    }
    if (profile.runtimeType.toString() == '_File') {
      s3Url = await PresignedUrlRepository.create(file: profile);
    }

    final data = {
      "nickname": nickname,
      "content": content,
      "tag_list": tagList,
      "profile_url": s3Url
    };

    final res = await service.patch('/api/v1/users/me', data: data);
    return User.fromJson(res.data['result']);
  }

  static updateFcmToken(String token) async {
    await service.post('/api/v1/users/fcm-token', data: {'fcm_token': token});
  }

  static checkNickName(String nickname) async {
    await service.get('/api/v1/users/nickname/$nickname');
    return true;
  }

  static removeUser() async {
    await service.delete('/api/v1/users/me');
  }

  static Future<UsersRoomsInfo> getUsersRoomFeed() async {
    final res = await service.get('/api/v1/users/my-page');
    return UsersRoomsInfo.fromJson(res.data['result']);
  }

  static Future<List<UserCalendarData>> getFeedListByDate({
    required int roomId,
    required String dateYM,
  }) async {
    final res = await service.get(
      '/api/v1/users/my-page/challenge-room/$roomId?date_ym=$dateYM',
    );
    return (res.data['result']['my_page_calender_info_list'] as List)
        .map((data) => UserCalendarData.fromJson(data))
        .toList();
  }
}
