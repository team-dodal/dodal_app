import 'dart:io';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/user_model.dart';
import 'package:dodal_app/src/main/home/bloc/custom_challenge_list_bloc.dart';
import 'package:dodal_app/src/main/feed_list/bloc/feed_list_bloc.dart';
import 'package:dodal_app/src/main/my_challenge/bloc/my_challenge_list_bloc.dart';
import 'package:dodal_app/src/sign_up/bloc/sign_up_cubit.dart';
import 'package:dodal_app/src/sign_in/bloc/sign_in_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/main/my_info/bloc/user_room_feed_info_bloc.dart';
import 'package:dodal_app/src/main/root/page/main_route.dart';
import 'package:dodal_app/src/sign_up/page/sign_up_route.dart';
import 'package:dodal_app/src/common/bloc/nickname_check_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/utils/social_auth.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transparent_image/transparent_image.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  _goMainPage(BuildContext context, User user) {
    context.read<UserBloc>().add(UpdateUserBlocEvent(user));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CustomChallengeListBloc(
                context.read<UserBloc>().state.result!.categoryList,
              ),
            ),
            BlocProvider(create: (context) => FeedListBloc()),
            BlocProvider(create: (context) => MyChallengeListBloc()),
            BlocProvider(create: (context) => UserRoomFeedInfoBloc()),
          ],
          child: const MainRoute(),
        ),
      ),
      (route) => false,
    );
  }

  _goSignUpPage(
    BuildContext context,
    String id,
    String email,
    SocialType type,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SignUpCubit(
                secureStorage: const FlutterSecureStorage(),
                socialId: id,
                email: email,
                socialType: type,
              ),
            ),
            BlocProvider(
              create: (context) => NicknameBloc(),
            )
          ],
          child: const SignUpRoute(),
        ),
      ),
    );
  }

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
          if (state.user != null) {
            _goMainPage(context, state.user!);
          } else {
            _goSignUpPage(context, state.id, state.email, state.type!);
          }
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
              FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: const AssetImage('assets/images/login_image.png'),
              ),
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
