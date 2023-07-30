import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class CompleteCreateChallenge extends StatelessWidget {
  const CompleteCreateChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        Widget? child;
        child = Column(
          children: [
            Image.asset('assets/images/welcome_image.png'),
            const SizedBox(height: 16),
            Text(
              '도전 생성 완료',
              style: Typo(context).body1()!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.orange,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '멤버들과 함께\n도전을 달성해보세요!',
              textAlign: TextAlign.center,
              style: Typo(context).headline2()!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.systemBlack,
                  ),
            )
          ],
        );
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                child: child,
              )
            ],
          ),
        );
      }),
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
            '내가 만든 도전 둘러보기',
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
