import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SocialType { KAKAO, GOOGLE, APPLE }

class AppleAuthService {
  static Future<AuthorizationCredentialAppleID?> signIn() async {
    try {
      return await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } catch (error) {
      print('애플 로그인 실패 $error');
      return null;
    }
  }
}

class GoogleAuthService {
  static GoogleSignIn instance = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static Future<GoogleSignInAccount?> signIn() async {
    if (instance.currentUser != null) {
      print(instance.currentUser);
      return null;
    } else {
      try {
        return await GoogleSignIn().signIn();
      } catch (err) {
        print(err);
        return null;
      }
    }
  }
}

class KakaoAuthService {
  static init() {
    KakaoSdk.init(
      nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
      javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_APP_KEY'),
    );
  }

  static Future<User?> signIn() async {
    if (await isKakaoTalkInstalled()) {
      return await KakaoAuthService.signInWithApp();
    } else {
      return await KakaoAuthService.signInWithWeb();
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
}
