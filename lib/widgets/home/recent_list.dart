import 'package:animations/animations.dart';
import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/challenge_code_enum.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/screens/challenge_list/main.dart';
import 'package:dodal_app/screens/challenge_preview/main.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/challenge_box/recent_challenge_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecentList extends StatefulWidget {
  const RecentList({super.key});

  @override
  State<RecentList> createState() => _RecentListState();
}

class _RecentListState extends State<RecentList> {
  List<Challenge> _challenges = [];

  _getChallenges() async {
    final res = await ChallengeService.getChallenges(
      conditionCode: ChallengeCodeEnum.recent.index,
      page: 0,
      pageSize: 3,
    );
    setState(() {
      _challenges = res!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getChallenges();
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
          for (final challenge in _challenges)
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
              openBuilder: (context, action) => challenge.isJoined
                  ? ChallengeRoute(id: challenge.id)
                  : ChallengePreviewScreen(id: challenge.id),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (ctx) => ChallengeListFilterCubit(
                        category: Category(
                          name: '전체',
                          subName: '',
                          value: null,
                          emoji: '',
                          tags: [const Tag(name: '전체', value: null)],
                        ),
                        condition: ConditionEnum.newest,
                      ),
                      child: const ChallengeListScreen(),
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
