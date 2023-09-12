import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/challenge_room/rank_filter_bottom_sheet.dart';
import 'package:dodal_app/widgets/challenge_room/rank_list_item.dart';
import 'package:dodal_app/widgets/challenge_room/rank_profile.dart';
import 'package:dodal_app/widgets/common/filter_button.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  ChallengeRankFilterEnum _code = ChallengeRankFilterEnum.all;
  List<ChallengeRankResponse?> _topThreeList = [null, null, null];
  List<ChallengeRankResponse?> _list = [];

  _getRankList() async {
    final rankResult = await ChallengeService.getRanks(
      id: widget.challenge.id,
      code: _code.index,
    );
    if (rankResult == null) return;
    _setRankList(rankResult);
  }

  void _setRankList(List<ChallengeRankResponse?> list) {
    List<ChallengeRankResponse?> topList;
    List<ChallengeRankResponse?> restList;

    if (list.length < 3) {
      topList = List.from(list)..addAll(List.filled(3 - list.length, null));
      restList = [];
    } else {
      topList = list.sublist(0, 3);
      restList = list.sublist(3);
    }
    setState(() {
      _topThreeList = topList;
      _list = restList;
    });
  }

  _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => RankFilterBottomSheet(
        onChange: (value) {
          setState(() {
            _code = value;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    _getRankList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilterButton(
                      onPressed: _showSortBottomSheet,
                      text: challengeRankFilterEnumText(_code),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            RankProfile(
                              imageUrl: _topThreeList[1]?.profileUrl,
                              name: _topThreeList[1]?.nickname,
                              rank: 2,
                              certCnt: _topThreeList[1]?.certCnt,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            RankProfile(
                              imageUrl: _topThreeList[0]?.profileUrl,
                              name: _topThreeList[0]?.nickname,
                              rank: 1,
                              certCnt: _topThreeList[0]?.certCnt,
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            RankProfile(
                              imageUrl: _topThreeList[2]?.profileUrl,
                              name: _topThreeList[2]?.nickname,
                              rank: 3,
                              certCnt: _topThreeList[2]?.certCnt,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration:
                        const BoxDecoration(color: AppColors.systemGrey4),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (_list.isEmpty)
          SliverList.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return RankListItem(
                rank: index + 4,
                profileUrl: _list[index]!.profileUrl,
                nickname: _list[index]!.nickname,
                certCnt: _list[index]!.certCnt,
              );
            },
          )
      ],
    );
  }
}
