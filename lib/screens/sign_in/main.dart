import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/user_service.dart';
import '../../utilities/social_auth.dart';
import '../main_route/main.dart';
import '../sign_up/main.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  final secureStorage = const FlutterSecureStorage();

  _socialSignIn(BuildContext context, SocialType type) async {
    final String? id;
    final String? email;
    switch (type) {
      case SocialType.GOOGLE:
        final res = await GoogleAuthService.signIn();
        id = res!['id'];
        email = res['email'];
      case SocialType.KAKAO:
        final res = await KakaoAuthService.signIn();
        id = res!['id'];
        email = res['email'];
      case SocialType.APPLE:
        final res = await AppleAuthService.signIn();
        if (res == null) return;
        id = res['id'];
        email = res['email'];
      default:
        return;
    }
    if (id == null && email == null) return;

    SignInResponse res = await UserService.signIn(type, id as String);

    if (res.accessToken != null && res.refreshToken != null) {
      secureStorage.write(key: 'accessToken', value: res.accessToken);
      secureStorage.write(key: 'refreshToken', value: res.refreshToken);
    }

    if (!context.mounted) return;

    if (res.isSigned) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const MainRoute()),
          (route) => false);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) =>
              SignUpScreen(socialType: type, socialId: id!, email: email!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도달')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFFE659),
                  minimumSize: const Size(double.infinity, 64),
                  foregroundColor: AppColors.systemBlack,
                  textStyle: Typo(context)
                      .body2()!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _socialSignIn(context, SocialType.KAKAO);
                },
                child: const Row(
                  children: [Text('Kakao SignIn')],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgColor2,
                  minimumSize: const Size(double.infinity, 64),
                  foregroundColor: AppColors.systemBlack,
                  textStyle: Typo(context)
                      .body2()!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _socialSignIn(context, SocialType.GOOGLE);
                },
                child: const Text('Google SignIn'),
              ),
              const SizedBox(height: 8),
              if (Platform.isIOS)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff000000),
                    minimumSize: const Size(double.infinity, 64),
                    foregroundColor: AppColors.bgColor1,
                    textStyle: Typo(context)
                        .body2()!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _socialSignIn(context, SocialType.APPLE);
                  },
                  child: const Text('Apple SignIn'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
