import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/modify_user/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, User?>(builder: (context, user) {
      user!;
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AvatarImage(
                        image: user.profileUrl,
                        width: 48,
                        height: 48,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.nickname,
                        style: Typo(context)
                            .body2()!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => const ModifyUserScreen()));
                      },
                      icon: SvgPicture.asset('assets/icons/pencil_icon.svg')),
                ],
              ),
              const SizedBox(height: 10),
              Text(user.content, style: Typo(context).body4()),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final tag in user.tagList)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          decoration: const BoxDecoration(
                              color: AppColors.lightOrange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                          child: Text(
                            tag.name,
                            style: Typo(context)
                                .caption()!
                                .copyWith(color: AppColors.orange),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 78,
                decoration: const BoxDecoration(
                  color: AppColors.bgColor2,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '최장 인증 연속 달성',
                            style: Typo(context)
                                .caption()!
                                .copyWith(color: AppColors.systemGrey1),
                          ),
                          Text(
                            '0일',
                            style: Typo(context).body2()!.copyWith(
                                  color: AppColors.systemGrey1,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      )),
                      Container(
                        height: double.infinity,
                        width: 1,
                        decoration: const BoxDecoration(
                          color: AppColors.orange,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '현재 연속 달성',
                            style: Typo(context)
                                .caption()!
                                .copyWith(color: AppColors.systemGrey1),
                          ),
                          Text(
                            '0일',
                            style: Typo(context).body2()!.copyWith(
                                  color: AppColors.systemGrey1,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ))
                      // 최장 인증 연속 달성
                      // 선
                      // 현재 연속 달성
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
