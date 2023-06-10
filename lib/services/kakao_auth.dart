import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class KakaoAuthService {
  static init() {
    KakaoSdk.init(
      nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
      javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_APP_KEY'),
    );
  }

  static Future<void> signOut() async {
    try {
      await UserApi.instance.logout();
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  static signIn() async {
    if (await KakaoAuthService.checkSignInStatus()) {
      return await UserApi.instance.me();
    } else {
      if (await isKakaoTalkInstalled()) {
        return await KakaoAuthService.signInWithApp();
      } else {
        return await KakaoAuthService.signInWithWeb();
      }
    }
  }

  static Future<User?> signInWithApp() async {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      return await UserApi.instance.me();
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        return null;
      }
      return await KakaoAuthService.signInWithWeb();
    }
  }

  static Future<User?> signInWithWeb() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      return await UserApi.instance.me();
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      return null;
    }
  }

  static Future<bool> checkSignInStatus() async {
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
