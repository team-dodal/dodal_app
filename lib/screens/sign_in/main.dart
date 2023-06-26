import 'dart:io';
import 'package:dodal_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../utilities/social_auth.dart';
import '../main_route/main.dart';
import '../sign_up/main.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  final secureStorage = const FlutterSecureStorage();

  _socialSignIn(BuildContext context, SocialType type) async {
    final String? id;
    switch (type) {
      case SocialType.GOOGLE:
        id = await GoogleAuthService.signIn();
      case SocialType.KAKAO:
        id = await KakaoAuthService.signIn();
      case SocialType.APPLE:
        id = await AppleAuthService.signIn();
      default:
        return;
    }
    if (id == null) return;

    SignInResponse res = await UserService.signIn(type, id);

    if (res.accessToken != null && res.refreshToken != null) {
      secureStorage.write(key: 'accessToken', value: res.accessToken);
      secureStorage.write(key: 'refreshToken', value: res.refreshToken);
    }

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) =>
                res.isSigned ? const MainRoute() : const SignUpScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도달'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _socialSignIn(context, SocialType.KAKAO);
              },
              child: const Text('Kakao SignIn'),
            ),
            ElevatedButton(
              onPressed: () {
                _socialSignIn(context, SocialType.GOOGLE);
              },
              child: const Text('Google SignIn'),
            ),
            if (Platform.isIOS)
              ElevatedButton(
                onPressed: () {
                  _socialSignIn(context, SocialType.APPLE);
                },
                child: const Text('Apple SignIn'),
              ),
          ],
        ),
      ),
    );
  }
}
