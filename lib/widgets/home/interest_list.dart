import 'package:animations/animations.dart';
import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/providers/bookmark_bloc.dart';
import 'package:dodal_app/providers/challenge_info_bloc.dart';
import 'package:dodal_app/providers/custom_feed_list_bloc.dart';
import 'package:dodal_app/providers/modify_user_cubit.dart';
import 'package:dodal_app/providers/nickname_check_bloc.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/screens/modify_user/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/challenge_box/list_challenge_box.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestList extends StatelessWidget {
  const InterestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 202,
          decoration: const BoxDecoration(color: AppColors.lightYellow),
        ),
        SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '관심있는\n도전을 추천드려요 🧡',
                      style: context.headline4(fontWeight: FontWeight.bold),
                    ),
                    Material(
                      color: AppColors.lightYellow,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) {
                                      final state = context
                                          .read<UserBloc>()
                                          .state
                                          .result!;
                                      return ModifyUserCubit(
                                        nickname: state.nickname,
                                        content: state.content,
                                        image: state.profileUrl,
                                        category: state.tagList,
                                      );
                                    },
                                    child: const ModifyUserScreen(),
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
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Text('관심사 추가하기'),
                            Icon(Icons.add, size: 16),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              BlocBuilder<CustomFeedListBloc, CustomFeedListState>(
                builder: (context, state) {
                  switch (state.status) {
                    case CommonStatus.init:
                    case CommonStatus.loading:
                      return const Center(child: CupertinoActivityIndicator());
                    case CommonStatus.error:
                      return Center(child: Text(state.errorMessage!));
                    case CommonStatus.loaded:
                      List<MyCategory> categories =
                          context.read<UserBloc>().state.result!.categoryList;
                      return ExpandablePageView.builder(
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => InterestCategoryCard(
                          category: categories[index],
                          challenges: state.interestList[index],
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InterestCategoryCard extends StatelessWidget {
  const InterestCategoryCard({
    super.key,
    required this.category,
    required this.challenges,
  });

  final MyCategory category;
  final List<Challenge> challenges;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: const BoxDecoration(
          color: AppColors.systemWhite,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.systemGrey3,
              offset: Offset(0, 0),
              blurRadius: 4,
              blurStyle: BlurStyle.outer,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${category.subName} ${category.name} ${category.emoji}',
              style: context.body1(fontWeight: FontWeight.bold),
            ),
            Row(
              children: category.hashTags.map((tag) => Text('$tag ')).toList(),
            ),
            if (challenges.isEmpty)
              const Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: NoListContext(
                      title: '해당 카테고리에 도전이 없어요 😢',
                      subTitle: '다른 카테고리를 확인해보세요!',
                    ),
                  ),
                ],
              ),
            if (challenges.isNotEmpty)
              Column(
                children: [
                  for (final challenge in challenges)
                    OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedElevation: 0,
                      closedBuilder: (context, action) {
                        return Container(
                          padding: const EdgeInsets.only(top: 20),
                          constraints: const BoxConstraints(minHeight: 80),
                          child: BlocProvider(
                            create: (context) => BookmarkBloc(
                              roomId: challenge.id,
                              isBookmarked: challenge.isBookmarked,
                            ),
                            child: ListChallengeBox(
                              title: challenge.title,
                              thumbnailImg: challenge.thumbnailImg,
                              tag: challenge.tag,
                              adminProfile: challenge.adminProfile,
                              adminNickname: challenge.adminNickname,
                              recruitCnt: challenge.recruitCnt,
                              userCnt: challenge.userCnt,
                              certCnt: challenge.certCnt,
                            ),
                          ),
                        );
                      },
                      openBuilder: (context, action) => BlocProvider(
                        create: (context) => ChallengeInfoBloc(challenge.id),
                        child: const ChallengeRoute(),
                      ),
                    )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
