import 'package:dodal_app/providers/modify_user_cubit.dart';
import 'package:dodal_app/providers/nickname_check_bloc.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/modify_user/main.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key, required this.user, required this.refresh});

  final UserResponse user;
  final Function() refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
                      user.nickname!,
                      style: context.body2(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                      builder: (ctx) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => ModifyUserCubit(
                              nickname: context
                                  .read<UserBloc>()
                                  .state
                                  .result!
                                  .nickname,
                              content: context
                                  .read<UserBloc>()
                                  .state
                                  .result!
                                  .content,
                              image: context
                                  .read<UserBloc>()
                                  .state
                                  .result!
                                  .profileUrl,
                              category: context
                                  .read<UserBloc>()
                                  .state
                                  .result!
                                  .tagList,
                            ),
                          ),
                          BlocProvider(
                            create: (context) => NicknameBloc(
                              nickname: context
                                  .read<UserBloc>()
                                  .state
                                  .result!
                                  .nickname,
                            ),
                          ),
                        ],
                        child: const ModifyUserScreen(),
                      ),
                    ))
                        .then(
                      (value) {
                        refresh();
                      },
                    );
                  },
                  icon: SvgPicture.asset('assets/icons/pencil_icon.svg'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(user.content!, style: context.body4()),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final tag in user.tagList!)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SmallTag(
                        text: tag.name,
                        backgroundColor: AppColors.orange,
                        foregroundColor: AppColors.systemWhite,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(height: 16),
            ContentCntBox(user: user),
            const SizedBox(height: 8),
            SvgPicture.asset('assets/icons/my_page_banner.svg'),
          ],
        ),
      ),
    );
  }
}

class ContentCntBox extends StatelessWidget {
  const ContentCntBox({super.key, required this.user});

  final UserResponse user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 78,
      decoration: const BoxDecoration(
          color: AppColors.systemWhite,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: AppColors.systemGrey3,
              offset: Offset(0, 0),
              blurRadius: 2,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '총 달성 수',
                  style: context.caption(),
                ),
                Text(
                  '${user.totalCertCnt}일',
                  style: context.body2(fontWeight: FontWeight.bold),
                ),
              ],
            )),
            Container(
              height: double.infinity,
              width: 1,
              decoration: const BoxDecoration(color: AppColors.systemGrey3),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '현재 연속 달성',
                    style: context.caption(color: AppColors.systemGrey1),
                  ),
                  Text(
                    '${user.maxContinueCertCnt}일',
                    style: context.body2(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
