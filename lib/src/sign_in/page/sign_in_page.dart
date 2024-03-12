import 'dart:io';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/sign_in/bloc/sign_in_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/utils/social_auth.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  _errorModal(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (_) => SystemDialog(subTitle: errorMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.status == CommonStatus.loaded) {
          context
              .read<AuthBloc>()
              .add(SignInUserBlocEvent(state.user, state.socialInfoData!));
        }
        if (state.status == CommonStatus.error) {
          _errorModal(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/images/login_image.png'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFE659),
                        minimumSize: const Size(double.infinity, 64),
                        foregroundColor: AppColors.systemBlack,
                        textStyle: context.body2(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        context
                            .read<SignInBloc>()
                            .add(SocialSignInEvent(SocialType.KAKAO));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/social/kakao_icon.svg',
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
                        backgroundColor: AppColors.bgColor3,
                        minimumSize: const Size(double.infinity, 64),
                        foregroundColor: AppColors.systemBlack,
                        textStyle: context.body2(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        context
                            .read<SignInBloc>()
                            .add(SocialSignInEvent(SocialType.GOOGLE));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/social/google_icon.svg',
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
                          textStyle: context.body2(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          context
                              .read<SignInBloc>()
                              .add(SocialSignInEvent(SocialType.APPLE));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/social/apple_icon.svg',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
