import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoAuthService {
  static init() {
    KakaoSdk.init(
      nativeAppKey: '23b4901366941958edb9bdde0a4721c0',
      javaScriptAppKey: '1b3fb5c581ec97b0612d3b0db5bd7a45',
    );
  }

  static getUserInfo() async {
    try {
      final info = await UserApi.instance.me();
      print(info);
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  static logout() async {
    try {
      await UserApi.instance.logout();
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  static login() async {
    if (await KakaoAuthService.checkLoginStatus()) {
      return await UserApi.instance.me();
    } else {
      if (await isKakaoTalkInstalled()) {
        return KakaoAuthService.loginWithApp();
      } else {
        return KakaoAuthService.loginWithWeb();
      }
    }
  }

  static Future<User?> loginWithApp() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      return await UserApi.instance.me();
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        return null;
      }
      KakaoAuthService.loginWithWeb();
    }
    return null;
  }

  static Future<User?> loginWithWeb() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      return await UserApi.instance.me();
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
    return null;
  }

  static checkLoginStatus() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        await UserApi.instance.accessTokenInfo();
        return true;
      } catch (error) {
        return false;
      }
    } else {
      return false;
    }
  }
}
