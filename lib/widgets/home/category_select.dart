import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/screens/challenge_list/main.dart';
import 'package:dodal_app/services/category_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class CategorySelect extends StatelessWidget {
  CategorySelect({super.key});
  final Future<List<Category>?> _categories =
      CategoryService.getAllCategories();

  _goListPage(context, Category category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (ctx) => ChallengeListFilterCubit(category: category),
          child: const ChallengeListScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  style: Typo(context)
                      .body1()!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                // OutlinedButton(onPressed: () {}, child: const Text('전체보기'))
                IconButton(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  icon: Row(
                    children: [
                      Text('전체보기', style: Typo(context).body4()),
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
          FutureBuilder(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              final List<Category> categories = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (Category category in categories)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              _goListPage(context, category);
                            },
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
                                    category.iconPath,
                                    width: 12,
                                    height: 12,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(category.name)
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
