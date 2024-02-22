import 'package:animations/animations.dart';
import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/providers/category_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/providers/custom_feed_list_bloc.dart';
import 'package:dodal_app/screens/challenge_list/main.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/challenge_box/recent_challenge_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentList extends StatelessWidget {
  const RecentList({super.key});

  Widget _success(List<Challenge> list) {
    return Column(
      children: [
        for (final challenge in list)
          OpenContainer(
            transitionType: ContainerTransitionType.fadeThrough,
            closedElevation: 0,
            closedBuilder: (context, action) {
              return Container(
                padding: const EdgeInsets.only(top: 20),
                constraints: const BoxConstraints(minHeight: 80),
                child: RecentChallengeBox(challenge: challenge),
              );
            },
            openBuilder: (context, action) => ChallengeRoute(id: challenge.id),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '최근에 만들어진\n도전이에요 ✨',
              style: context.headline4(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<CustomFeedListBloc, CustomFeedListState>(
            builder: (context, state) {
              switch (state.status) {
                case CustomFeedListStatus.init:
                case CustomFeedListStatus.loading:
                  return const Center(child: CupertinoActivityIndicator());
                case CustomFeedListStatus.error:
                  return Center(child: Text(state.errorMessage!));
                case CustomFeedListStatus.success:
                  return _success(state.recentList);
              }
            },
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                List<Category> list = context
                    .read<CategoryListBloc>()
                    .state
                    .categoryListForFilter();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (ctx) => ChallengeListFilterCubit(
                        category: list[0],
                        condition: ConditionEnum.newest,
                      ),
                      child: BlocProvider(
                        create: (context) => ChallengeListBloc(
                          category: context
                              .read<ChallengeListFilterCubit>()
                              .state
                              .category,
                          tag: context
                              .read<ChallengeListFilterCubit>()
                              .state
                              .tag,
                          condition: context
                              .read<ChallengeListFilterCubit>()
                              .state
                              .condition,
                          certCntList: context
                              .read<ChallengeListFilterCubit>()
                              .state
                              .certCntList,
                        ),
                        child: const ChallengeListScreen(),
                      ),
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 0),
                padding: const EdgeInsets.all(16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                side: const BorderSide(color: AppColors.systemGrey3),
              ),
              child: Text(
                '최신 도전 더보기',
                style: context.body3(
                  color: AppColors.systemGrey1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
