import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteSignUpScreen extends StatelessWidget {
  const CompleteSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<User?> user = UserService.user();
    return Scaffold(
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          Widget? child;
          if (snapshot.connectionState == ConnectionState.done) {
            var user = snapshot.data!;
            context.read<UserCubit>().set(User(
                  id: user.id,
                  email: user.email,
                  nickname: user.nickname,
                  content: user.content,
                  profileUrl: user.profileUrl,
                  registerAt: user.registerAt,
                  socialType: user.socialType,
                  tagList: user.tagList,
                ));
            final String nickname = snapshot.data!.nickname;
            child = Column(
              children: [
                Image.asset('assets/images/welcome_image.png'),
                const SizedBox(height: 16),
                Text(
                  '가입 완료!',
                  style: Typo(context).body1()!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$nickname님, 환영해요',
                  style: Typo(context).headline2()!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.systemBlack,
                      ),
                )
              ],
            );
          }
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: child,
              )
            ]),
          );
        },
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
              MaterialPageRoute(builder: (ctx) => const MainRoute()),
              (route) => false,
            );
          },
          child: Text(
            '도전하러 가기',
            style: Typo(context).body1()!.copyWith(
                  color: AppColors.systemWhite,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
