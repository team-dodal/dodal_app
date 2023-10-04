import 'dart:developer';

import 'package:dodal_app/main.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SocialType { KAKAO, GOOGLE, APPLE }

class AppleAuthService {
  static Future<Map<String, String>?> signIn() async {
    try {
      final idCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log('${idCredential.identityToken}');
      return {
        'id': idCredential.userIdentifier.toString(),
        'email': idCredential.email ?? ''
      };
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

  static Future<Map<String, String>?> signIn() async {
    try {
      final res = await GoogleSignIn().signIn();
      return {'id': res!.id, 'email': res.email};
    } catch (err) {
      log('$err');
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => SystemDialog(subTitle: '구글 로그인 실패 $err'),
      );
      return null;
    }
  }
}

class KakaoAuthService {
  static signIn() async {
    if (await isKakaoTalkInstalled()) {
      return await KakaoAuthService.signInWithApp();
    } else {
      return await KakaoAuthService.signInWithWeb();
    }
  }

  static Future<Map<String, String>?> signInWithApp() async {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      final user = await UserApi.instance.me();
      return {
        'id': user.id.toString(),
        'email': user.kakaoAccount!.email.toString()
      };
    } on PlatformException catch (error) {
      if (error.code == 'CANCELED') return null;
    } catch (error) {
      log('카카오계정으로 로그인 실패 $error');
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => SystemDialog(subTitle: '카카오계정으로 로그인 실패 $error'),
      );
      return await KakaoAuthService.signInWithWeb();
    }
    return null;
  }

  static Future<Map<String, String>?> signInWithWeb() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      final user = await UserApi.instance.me();
      return {
        'id': user.id.toString(),
        'email': user.kakaoAccount!.email.toString()
      };
    } catch (error) {
      log('카카오계정으로 로그인 실패 $error');
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => SystemDialog(subTitle: '카카오계정으로 로그인 실패 $error'),
      );
      return null;
    }
  }
}
