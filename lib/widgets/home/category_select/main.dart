import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/providers/category_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/screens/challenge_list/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class CategorySelect extends StatelessWidget {
  const CategorySelect({super.key});

  void _goListPage(BuildContext context, Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (ctx) => ChallengeListFilterCubit(category: category),
          child: BlocProvider(
            create: (context) => ChallengeListBloc(
              category: context.read<ChallengeListFilterCubit>().state.category,
              tag: context.read<ChallengeListFilterCubit>().state.tag,
              condition:
                  context.read<ChallengeListFilterCubit>().state.condition,
              certCntList:
                  context.read<ChallengeListFilterCubit>().state.certCntList,
            ),
            child: const ChallengeListScreen(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryListBloc, CategoryListState>(
      builder: (context, state) {
        return SizedBox(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '카테고리',
                      style: context.body1(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        Category allCategory = state.categoryListForFilter()[0];
                        _goListPage(context, allCategory);
                      },
                      style: IconButton.styleFrom(
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      icon: Row(
                        children: [
                          Text('전체보기', style: context.body4()),
                          Transform.rotate(
                            angle: math.pi / 2,
                            child: SvgPicture.asset(
                              'assets/icons/arrow_icon.svg',
                              width: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (Category category in state.result)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: CategoryButton(
                          iconPath: category.iconPath,
                          name: category.name,
                          onTap: () {
                            List<Category> list = state.categoryListForFilter();
                            Category filterCategory = list.firstWhere(
                              (element) => element.value == category.value,
                            );
                            _goListPage(context, filterCategory);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.onTap,
    required this.iconPath,
    required this.name,
  });

  final String iconPath;
  final void Function() onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                color: AppColors.lightYellow,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 12,
                height: 12,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(height: 4),
            Text(name)
          ],
        ),
      ),
    );
  }
}
