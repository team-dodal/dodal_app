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
import 'package:dodal_app/widgets/common/challenge_box/grid_challenge_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularList extends StatefulWidget {
  const PopularList({super.key});

  @override
  State<PopularList> createState() => _PopularListState();
}

class _PopularListState extends State<PopularList> {
  List<Challenge> _challenges = [];

  _getChallenges() async {
    final res = await ChallengeService.getChallenges(
      conditionCode: ChallengeCodeEnum.popular.index,
      page: 0,
      pageSize: 4,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '도달러들에게\n인기있는 도전이에요 🔥',
              style: context.headline4(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              childAspectRatio: 0.8,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final challenge in _challenges)
                  OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedElevation: 0,
                    closedBuilder: (context, action) {
                      return Container(
                          padding: const EdgeInsets.only(top: 20),
                          constraints: const BoxConstraints(minHeight: 80),
                          child: GridChallengeBox(challenge: challenge));
                    },
                    openBuilder: (context, action) => challenge.isJoined
                        ? ChallengeRoute(id: challenge.id)
                        : ChallengePreviewScreen(id: challenge.id),
                  )
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton(
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
                        condition: ConditionEnum.popularity,
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
                '인기 도전 더보기',
                style: context.body3(
                  color: AppColors.systemGrey1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
