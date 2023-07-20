import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<UserResponse> user = UserService.user();
    return Scaffold(
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          return Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: AppColors.basicColor1),
              ),
              Text(
                '가입 완료!',
                style: Typo(context).body1()!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.orange,
                    ),
              ),
              Text(
                '${snapshot.data!.nickname}님, 환영해요',
                style: Typo(context).headline2()!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.systemBlack,
                    ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text('도전하러 가기'),
      ),
    );
  }
}
