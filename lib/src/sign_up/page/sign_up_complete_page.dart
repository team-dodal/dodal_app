import 'package:dodal_app/src/main/home/bloc/custom_challenge_list_bloc.dart';
import 'package:dodal_app/src/main/feed_list/bloc/feed_list_bloc.dart';
import 'package:dodal_app/src/main/my_challenge/bloc/my_challenge_list_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/main/my_info/bloc/user_room_feed_info_bloc.dart';
import 'package:dodal_app/src/main/root/page/main_route.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCompletePage extends StatelessWidget {
  const SignUpCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Column(
                children: [
                  Image.asset('assets/images/character/welcome.png'),
                  const SizedBox(height: 16),
                  Text(
                    '가입 완료!',
                    style: context.body1(
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${context.read<UserBloc>().state.result!.nickname}님, 환영해요',
                    style: context.headline2(
                      fontWeight: FontWeight.bold,
                      color: AppColors.systemBlack,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: AppColors.orange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed: () {
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
          },
          child: Text(
            '도전하러 가기',
            style: context.body1(
              color: AppColors.systemWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
