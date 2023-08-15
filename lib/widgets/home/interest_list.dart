import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
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
                      style: Typo(context)
                          .headline4()!
                          .copyWith(fontWeight: FontWeight.bold),
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
                  List<Tag> tagList = state!.tagList;
                  return ExpandablePageView.builder(
                    itemCount: tagList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        InterestCategoryCard(tagList: tagList),
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

class InterestCategoryCard extends StatelessWidget {
  const InterestCategoryCard({super.key, required this.tagList});

  final List<Tag> tagList;

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
              '불끈불끈 건강 💪',
              style:
                  Typo(context).body1()!.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '#체력 키우기 #살기 위해 한다',
              style:
                  Typo(context).body4()!.copyWith(color: AppColors.systemGrey1),
            ),
            Column(
              children: [
                for (final i in [1, 2, 3])
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: ChallengeBox(
                      title: '타이틀',
                      thumbnailImg: null,
                      tag: tagList[0],
                      adminProfile: '',
                      adminNickname: '어드민',
                      recruitCnt: 20,
                      userCnt: 4,
                      certCnt: 5,
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
