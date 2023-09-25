import 'package:dodal_app/model/challenge_code_enum.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/challenge_box/grid_challenge_box.dart';
import 'package:flutter/material.dart';

class PopularList extends StatefulWidget {
  const PopularList({super.key});

  @override
  State<PopularList> createState() => _PopularListState();
}

class _PopularListState extends State<PopularList> {
  List<Challenge> _challenges = [];

  _getChallenges() async {
    final res = await ChallengeService.getChallengesByCategory(
      tagValue: '',
      conditionCode: ChallengeCodeEnum.popular.index,
      certCntList: [1, 2, 3, 4, 5, 6, 7],
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
                  GridChallengeBox(challenge: challenge)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
