import 'package:dodal_app/src/common/model/challenge_rank_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/challenge/ranking/bloc/challenge_ranking_bloc.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/challenge/ranking/widget/rank_filter_bottom_sheet.dart';
import 'package:dodal_app/src/challenge/ranking/widget/rank_list_item.dart';
import 'package:dodal_app/src/challenge/ranking/widget/rank_profile.dart';
import 'package:dodal_app/src/common/widget/filter_button.dart';
import 'package:dodal_app/src/common/widget/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key, required this.challenge});

  final ChallengeDetail challenge;

  _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => RankFilterBottomSheet(
        onChange: (value) {
          context.read<ChallengeRankingBloc>().add(ChangeFilterEvent(value));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        BlocSelector<ChallengeRankingBloc, ChallengeRankingState,
            ChallengeRankFilterEnum>(
          selector: (state) => state.rankFilter,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilterButton(
                    onPressed: () {
                      _showSortBottomSheet(context);
                    },
                    text: state.displayName,
                  ),
                ],
              ),
            );
          },
        ),
        BlocBuilder<ChallengeRankingBloc, ChallengeRankingState>(
          builder: (context, state) {
            switch (state.status) {
              case CommonStatus.init:
              case CommonStatus.loading:
                return const Center(child: CupertinoActivityIndicator());
              case CommonStatus.error:
                return Center(child: Text(state.errorMessage!));
              case CommonStatus.loaded:
                if (state.topThreeList.isEmpty && state.otherList.isEmpty) {
                  return const Column(
                    children: [
                      SizedBox(height: 120),
                      Center(
                        child: NoListContext(
                          title: '아직 인증한 유저가 없습니다.',
                          subTitle: '먼저 인증을 시작해보세요!',
                        ),
                      )
                    ],
                  );
                }
                int itemCount = state.topThreeList.isNotEmpty
                    ? state.otherList.length + 1
                    : state.otherList.length;

                return Expanded(
                  child: ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      if (index == 0 && state.topThreeList.isNotEmpty) {
                        return TopThreeRank(topThreeList: state.topThreeList);
                      }
                      int i = state.topThreeList.isNotEmpty ? index - 1 : index;
                      int rank =
                          state.topThreeList.isNotEmpty ? index : index + 1;
                      return RankListItem(
                        rank: rank,
                        userId: state.otherList[i].userId,
                        profileUrl: state.otherList[i].profileUrl,
                        nickname: state.otherList[i].nickname,
                        certCnt: state.otherList[i].certCnt,
                      );
                    },
                  ),
                );
            }
          },
        )
      ],
    );
  }
}

class TopThreeRank extends StatelessWidget {
  const TopThreeRank({super.key, required this.topThreeList});

  final List<ChallengeRank?> topThreeList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final i in [1, 0, 2])
                Column(
                  children: [
                    if (i != 0) const SizedBox(height: 50),
                    RankProfile(
                      imageUrl: topThreeList[i]?.profileUrl,
                      name: topThreeList[i]?.nickname,
                      rank: i + 1,
                      certCnt: topThreeList[i]?.certCnt,
                    ),
                  ],
                ),
              const Divider(thickness: 8, color: AppColors.systemGrey4),
            ],
          ),
        ),
      ],
    );
  }
}
