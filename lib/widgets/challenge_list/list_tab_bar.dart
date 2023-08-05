import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/services/category_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double CATEGORY_BAR_HEIGHT = 120;

class ListTabBar extends StatefulWidget implements PreferredSizeWidget {
  const ListTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(CATEGORY_BAR_HEIGHT);

  @override
  State<ListTabBar> createState() => _ListTabBarState();
}

class _ListTabBarState extends State<ListTabBar> with TickerProviderStateMixin {
  late TabController tabController;
  List<Category> _categories = [];

  _initCategory() async {
    final categoryList = await CategoryService.getAllCategories();
    if (categoryList == null) return;
    tabController = TabController(length: categoryList.length, vsync: this);
    if (mounted) {
      final state = BlocProvider.of<ChallengeListFilterCubit>(context).state;
      final selectedIdx = categoryList
          .indexWhere((category) => category.value == state.category.value);
      tabController.index = selectedIdx;
      setState(() {
        _categories = categoryList;
      });
    }
  }

  @override
  void initState() {
    _initCategory();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_categories.isEmpty) return const SizedBox();

    return BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
        builder: (context, state) {
      return SizedBox(
        height: CATEGORY_BAR_HEIGHT,
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              tabs: _categories
                  .map((category) => Tab(text: category.name))
                  .toList(),
              onTap: (value) {
                context.read<ChallengeListFilterCubit>().updateData(
                      category: _categories[value],
                      tag: _categories[value].tags[0],
                    );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final tag in state.category.tags)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 4,
                        ),
                        child: InkWell(
                          onTap: () {
                            context
                                .read<ChallengeListFilterCubit>()
                                .updateData(tag: tag);
                          },
                          borderRadius: BorderRadius.circular(40),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: tag == state.tag
                                  ? AppColors.systemGrey1
                                  : AppColors.systemWhite,
                              border: Border.all(
                                color: tag == state.tag
                                    ? AppColors.systemGrey1
                                    : AppColors.systemGrey3,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(23),
                              ),
                            ),
                            child: Text(
                              tag.name,
                              style: Typo(context).body4()!.copyWith(
                                    color: tag == state.tag
                                        ? AppColors.systemWhite
                                        : AppColors.systemGrey1,
                                  ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
