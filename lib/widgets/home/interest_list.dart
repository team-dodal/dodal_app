import 'package:animations/animations.dart';
import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/challenge_preview/main.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_list/challenge_box.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
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
                        onTap: () {},
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
              BlocBuilder<UserCubit, User?>(
                builder: (context, state) {
                  List<MyCategory> categoryList = state!.categoryList;
                  return ExpandablePageView.builder(
                    itemCount: categoryList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        InterestCategoryCard(category: categoryList[index]),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

class InterestCategoryCard extends StatefulWidget {
  const InterestCategoryCard({super.key, required this.category});

  final MyCategory category;

  @override
  State<InterestCategoryCard> createState() => _InterestCategoryCardState();
}

class _InterestCategoryCardState extends State<InterestCategoryCard> {
  List<Challenge> _challenges = [];

  _getChallenges() async {
    final res = await ChallengeService.getChallengesByCategory(
      categoryValue: widget.category.value,
      tagValue: '',
      conditionCode: 0,
      certCntList: [1, 2, 3, 4, 5, 6, 7],
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
              '${widget.category.subName} ${widget.category.name} ${widget.category.emoji}',
              style: context.body1(fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.category.hashTags[0]} ${widget.category.hashTags[1]}',
              style: context.body4(color: AppColors.systemGrey1),
            ),
            Column(
              children: [
                for (final challenge in _challenges)
                  OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedElevation: 0,
                    closedBuilder: (context, action) {
                      return Container(
                        padding: const EdgeInsets.only(top: 20),
                        constraints: const BoxConstraints(minHeight: 80),
                        child: ChallengeBox(
                          id: challenge.id,
                          title: challenge.title,
                          thumbnailImg: challenge.thumbnailImg,
                          tag: challenge.tag,
                          adminProfile: challenge.adminProfile,
                          adminNickname: challenge.adminNickname,
                          recruitCnt: challenge.recruitCnt,
                          userCnt: challenge.userCnt,
                          certCnt: challenge.certCnt,
                          isBookmarked: challenge.isBookmarked,
                        ),
                      );
                    },
                    openBuilder: (context, action) => challenge.isJoined
                        ? ChallengeRoute(id: challenge.id)
                        : ChallengePreviewScreen(id: challenge.id),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
