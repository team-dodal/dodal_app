import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/common/model/category_model.dart';
import 'package:dodal_app/src/common/model/challenge_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/common/bloc/category_list_bloc.dart';
import 'package:dodal_app/src/main/home/bloc/custom_challenge_list_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/challenge_box/grid_challenge_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PopularList extends StatelessWidget {
  const PopularList({super.key});

  Widget _success(BuildContext context, List<Challenge> list) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 20,
      shrinkWrap: true,
      childAspectRatio: 0.8,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final challenge in list)
          GestureDetector(
            onTap: () {
              context.push('/challenge/${challenge.id}');
            },
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              constraints: const BoxConstraints(minHeight: 80),
              child: BlocProvider(
                create: (context) => BookmarkBloc(
                  roomId: challenge.id,
                  isBookmarked: challenge.isBookmarked,
                ),
                child: GridChallengeBox(challenge: challenge),
              ),
            ),
          )
      ],
    );
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
            BlocBuilder<CustomChallengeListBloc, CustomFeedListState>(
              builder: (context, state) {
                switch (state.status) {
                  case CommonStatus.init:
                  case CommonStatus.loading:
                    return const Center(child: CupertinoActivityIndicator());
                  case CommonStatus.error:
                    return Text(state.errorMessage!);
                  case CommonStatus.loaded:
                    return _success(context, state.popularList);
                }
              },
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                List<Category> list = context
                    .read<CategoryListBloc>()
                    .state
                    .categoryListForFilter();
                context.push('/challenge-list', extra: {
                  'category': list[0],
                  'condition': ConditionEnum.newest,
                  'tag': list[0].tags![0],
                  'certCntList': List.generate(7, (index) => index + 1),
                });
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
