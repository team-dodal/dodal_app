import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoListContext extends StatelessWidget {
  const NoListContext({super.key, required this.title, required this.subTitle});

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/icons/flag_icon.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.systemGrey2,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: context.body1(fontWeight: FontWeight.bold),
        ),
        Text(
          subTitle,
          style: context.body4(color: AppColors.systemGrey2),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => BlocProvider(
                  create: (context) => CreateChallengeCubit(),
                  child: const CreateChallengeScreen(),
                ),
              ),
            );
          },
          style: TextButton.styleFrom(
            side: const BorderSide(color: AppColors.systemGrey3),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: AppColors.systemWhite,
          ),
          child: Text(
            '도전 생성하기',
            style: context.body4(color: AppColors.systemGrey1),
          ),
        ),
      ],
    );
  }
}
