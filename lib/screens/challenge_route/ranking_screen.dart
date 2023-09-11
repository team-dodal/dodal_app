import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/challenge_room/rank_list_item.dart';
import 'package:dodal_app/widgets/challenge_room/rank_profile.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final int _code = 0;
  final List<ChallengeRankResponse?> _topThreeList = [null, null, null];
  List<ChallengeRankResponse> _list = [];

  _test() async {
    final rankResult = await ChallengeService.getRanks(
      id: widget.challenge.id,
      code: _code,
    );
    if (rankResult == null) return;
    setState(() {
      _topThreeList[0] = rankResult[0];
      _topThreeList[1] = rankResult[1];
      _topThreeList[2] = rankResult[2];
      _list = rankResult.sublist(3);
    });
  }

  @override
  void initState() {
    _test();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Column(
          children: [
            SizedBox(
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RankProfile(
                      imageUrl: _topThreeList[1]?.profileUrl,
                      name: _topThreeList[1]?.nickname,
                      rank: 2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: RankProfile(
                      imageUrl: _topThreeList[0]?.profileUrl,
                      name: _topThreeList[0]?.nickname,
                      rank: 1,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RankProfile(
                      imageUrl: _topThreeList[2]?.profileUrl,
                      name: _topThreeList[2]?.nickname,
                      rank: 3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 8,
              decoration: const BoxDecoration(color: AppColors.systemGrey4),
            ),
          ],
        )),
        SliverList.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return RankListItem(
              rank: index + 4,
              profileUrl: _list[index].profileUrl,
              nickname: _list[index].nickname,
              certCnt: _list[index].certCnt,
            );
          },
        )
      ],
    );
  }
}
