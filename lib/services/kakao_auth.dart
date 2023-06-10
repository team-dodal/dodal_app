import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_config/flutter_config.dart';

class KakaoAuthService {
  static init() {
    KakaoSdk.init(
      nativeAppKey: FlutterConfig.get('KAKAO_NATIVE_APP_KEY'),
      javaScriptAppKey: FlutterConfig.get('KAKAO_JAVASCRIPT_APP_KEY'),
    );
  }

  static Future<void> logout() async {
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
        return await KakaoAuthService.loginWithApp();
      } else {
        return await KakaoAuthService.loginWithWeb();
      }
    }
  }

  static Future<User?> loginWithApp() async {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      return await UserApi.instance.me();
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        return null;
      }
      return await KakaoAuthService.loginWithWeb();
    }
  }

  static Future<User?> loginWithWeb() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      return await UserApi.instance.me();
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      return null;
    }
  }

  static Future<bool> checkLoginStatus() async {
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
