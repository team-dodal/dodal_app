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
            User res = snapshot.data!;
            User user = User(
              id: res.id,
              email: res.email,
              nickname: res.nickname,
              content: res.content,
              profileUrl: res.profileUrl,
              registerAt: res.registerAt,
              socialType: res.socialType,
              categoryList: res.categoryList,
              tagList: res.tagList,
            );
            context.read<UserBloc>().add(UpdateUserBlocEvent(user));
            final String nickname = snapshot.data!.nickname;
            child = Column(
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
                  '$nickname님, 환영해요',
                  style: context.headline2(
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
