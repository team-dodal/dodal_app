import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<dynamic> user = UserService.user();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(color: AppColors.basicColor1),
            ),
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
              '님, 환영해요',
              style: Typo(context).headline2()!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.systemBlack,
                  ),
            ),
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
          onPressed: () {},
          child: Text(
            '도전하러 가기',
            style: Typo(context).body1()!.copyWith(
                  color: AppColors.systemGrey5,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
