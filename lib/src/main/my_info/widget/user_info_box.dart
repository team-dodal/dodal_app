import 'package:dodal_app/src/main/home/bloc/custom_challenge_list_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/main/my_info/bloc/user_room_feed_info_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/avatar_image.dart';
import 'package:dodal_app/src/common/widget/small_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, UserBlocState>(
      builder: (context, state) {
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
                          image: state.user?.profileUrl,
                          width: 48,
                          height: 48,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          state.user?.nickname ?? '',
                          style: context.body2(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context.push('/modify-user').then(
                          (isNeedRefresh) {
                            if (isNeedRefresh == true) {
                              context
                                  .read<CustomChallengeListBloc>()
                                  .add(LoadInterestListEvent());
                            }
                          },
                        );
                      },
                      icon: SvgPicture.asset('assets/icons/pencil_icon.svg'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(state.user?.content ?? '', style: context.body4()),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final tag in state.user?.tagList ?? [])
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
                const ContentCntBox(),
                const SizedBox(height: 8),
                SvgPicture.asset('assets/icons/my_page_banner.svg'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContentCntBox extends StatelessWidget {
  const ContentCntBox({super.key});

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
                  BlocSelector<UserRoomFeedInfoBloc, UserRoomFeedInfoState,
                      int>(
                    selector: (state) => state.totalCertCnt,
                    builder: (context, state) => Text(
                      '$state일',
                      style: context.body2(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
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
                  BlocSelector<UserRoomFeedInfoBloc, UserRoomFeedInfoState,
                      int>(
                    selector: (state) => state.maxContinueCertCnt,
                    builder: (context, state) => Text(
                      '$state일',
                      style: context.body2(fontWeight: FontWeight.bold),
                    ),
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
