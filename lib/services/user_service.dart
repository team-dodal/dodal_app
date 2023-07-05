import 'package:dodal_app/utilities/social_auth.dart';

import 'common/main.dart';

class SignInResponse {
  bool isSigned;
  String? accessToken, refreshToken;

  SignInResponse.fromJson(Map<String, dynamic> data)
      : isSigned = data['is_signed']!.toLowerCase() == 'true',
        accessToken = data['access_token'],
        refreshToken = data['refresh_token'];
}

class SignUpResponse {
  String? accessToken, refreshToken;

  SignUpResponse.fromJson(Map<String, dynamic> data)
      : accessToken = data['access_token'],
        refreshToken = data['refresh_token'];
}

class UserService {
  static signIn(SocialType socialType, String socialId) async {
    try {
      final service = await dio();
      final res = await service.post('/api/v1/users/sign-in',
          data: {"social_type": socialType.name, "social_id": socialId});
      return SignInResponse.fromJson(res.data['result']);
    } catch (err) {
      throw Exception(err);
    }
  }

  static signUp(
    SocialType socialType,
    String socialId,
    String email,
    String nickname,
    String profileUrl,
    String content,
    List<String> category,
  ) async {
    try {
      final service = await dio();
      final res = await service.post('/api/v1/users/sign-up', data: {
        "social_type": socialType.name,
        "social_id": socialId,
        "email": email,
        "nickname": nickname,
        "profile_url": profileUrl,
        "content": content,
        "tag_list": category,
      });
      return SignUpResponse.fromJson(res.data['result']);
    } catch (err) {
      throw Exception(err);
    }
  }

  static user() async {
    try {
      final service = await dio();
      final res = await service.get('/api/v1/users/me');
      return res.data['result'];
    } catch (err) {
      return Future.error(err.toString());
    }
  }

  static updateFcmToken(String token) async {
    try {
      final service = await dio();
      await service.post('/api/v1/users/fcm-token', data: {'fcm_token': token});
    } catch (err) {
      return Exception(err);
    }
  }

  static uploadProfileImg(String profile) async {
    try {
      final service = await dio();
      final res =
          await service.post('/api/v1/users/profile', data: {profile: profile});
      return res.data['result'];
    } catch (err) {
      throw Exception(err);
    }
  }

  static checkNickName(String nickname) async {
    try {
      final service = await dio();
      await service.get('/api/v1/users/nickname/$nickname');
      return true;
    } catch (err) {
      return false;
    }
  }

  static removeUser() async {
    try {
      final service = await dio();
      await service.delete('/api/v1/users/me');
    } catch (err) {
      throw Exception(err);
    }
  }
}
