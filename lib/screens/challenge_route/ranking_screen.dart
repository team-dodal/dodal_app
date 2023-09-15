import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/challenge_room/rank_filter_bottom_sheet.dart';
import 'package:dodal_app/widgets/challenge_room/rank_list_item.dart';
import 'package:dodal_app/widgets/challenge_room/rank_profile.dart';
import 'package:dodal_app/widgets/common/cross_divider.dart';
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
  List<ChallengeRankResponse?>? _topThreeList;
  List<ChallengeRankResponse?> _list = [];

  _getRankList() async {
    final rankList = await ChallengeService.getRanks(
      id: widget.challenge.id,
      code: _code.index,
    );
    if (rankList == null) return;
    setState(() {
      _list = rankList;
      if (rankList.length > 3) {
        _topThreeList = rankList.sublist(0, 3);
      }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterButton(
                      onPressed: _showSortBottomSheet,
                      text: _code.displayName,
                    ),
                  ),
                ],
              ),
              if (_topThreeList != null)
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
                                imageUrl: _topThreeList![1]?.profileUrl,
                                name: _topThreeList![1]?.nickname,
                                rank: 2,
                                certCnt: _topThreeList![1]?.certCnt,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              RankProfile(
                                imageUrl: _topThreeList![0]?.profileUrl,
                                name: _topThreeList![0]?.nickname,
                                rank: 1,
                                certCnt: _topThreeList![0]?.certCnt,
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 50),
                              RankProfile(
                                imageUrl: _topThreeList![2]?.profileUrl,
                                name: _topThreeList![2]?.nickname,
                                rank: 3,
                                certCnt: _topThreeList![2]?.certCnt,
                              ),
                            ],
                          ),
                          const CrossDivider(),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (_list.isNotEmpty)
          SliverList.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return RankListItem(
                rank: index + 1,
                userId: _list[index]!.userId,
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
