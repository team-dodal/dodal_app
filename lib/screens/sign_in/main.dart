import 'dart:io';
import 'package:dodal_app/model/my_info_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/user_service.dart';
import '../../utilities/social_auth.dart';
import '../sign_up/main.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  final secureStorage = const FlutterSecureStorage();

  _socialSignIn(BuildContext context, SocialType type) async {
    final String? id;
    final String? email;
    switch (type) {
      case SocialType.GOOGLE:
        final res = await GoogleAuthService.signIn();
        if (res == null) return;
        id = res['id'];
        email = res['email'];
      case SocialType.KAKAO:
        final res = await KakaoAuthService.signIn();
        if (res == null) return;
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

    if (res.isSigned) {
      final user = await UserService.user();
      if (!context.mounted) return;
      context.read<MyInfoCubit>().set(User.formJson(user));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => const MainRoute()),
          (route) => false);
    } else {
      if (!context.mounted) return;
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: AppColors.basicColor1),
              ),
              Column(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/kakao_icon.svg',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 7),
                        const Text('카카오로 시작하기'),
                      ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/google_icon.svg',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 7),
                        const Text('구글로 시작하기'),
                      ],
                    ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/apple_icon.svg',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 7),
                          const Text('Apple로 시작하기'),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
