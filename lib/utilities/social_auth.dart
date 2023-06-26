import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SocialType { KAKAO, GOOGLE, APPLE }

class AppleAuthService {
  static Future<String?> signIn() async {
    try {
      final idCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log('${idCredential.identityToken}');
      return idCredential.userIdentifier;
    } catch (error) {
      log('애플 로그인 실패 $error');
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

  static Future<String?> signIn() async {
    try {
      final res = await GoogleSignIn().signIn();
      return res!.id;
    } catch (err) {
      log('$err');
      return null;
    }
  }
}

class KakaoAuthService {
  static signIn() async {
    KakaoSdk.init(
      nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
      javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_APP_KEY'),
    );
    if (await isKakaoTalkInstalled()) {
      return await KakaoAuthService.signInWithApp();
    } else {
      return await KakaoAuthService.signInWithWeb();
    }
  }

  static Future<String?> signInWithApp() async {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      final user = await UserApi.instance.me();
      return user.id.toString();
    } catch (error) {
      log('카카오계정으로 로그인 실패 $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        return null;
      }
      return await KakaoAuthService.signInWithWeb();
    }
  }

  static Future<String?> signInWithWeb() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      final user = await UserApi.instance.me();
      return user.id.toString();
    } catch (error) {
      log('카카오계정으로 로그인 실패 $error');
      return null;
    }
  }
}
