import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/providers/category_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_list/filter_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double CATEGORY_BAR_HEIGHT = 170;

class ListTabBar extends StatefulWidget implements PreferredSizeWidget {
  const ListTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(CATEGORY_BAR_HEIGHT);

  @override
  State<ListTabBar> createState() => _ListTabBarState();
}

class _ListTabBarState extends State<ListTabBar> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    List<Category> list =
        context.read<CategoryListBloc>().state.categoryListForFilter();
    tabController = TabController(length: list.length, vsync: this);
    Category currentCategory =
        context.read<ChallengeListFilterCubit>().state.category;
    tabController.index = list.indexOf(currentCategory);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories =
        context.read<CategoryListBloc>().state.categoryListForFilter();

    return BlocBuilder<ChallengeListFilterCubit, ChallengeListFilterState>(
        builder: (context, state) {
      return SizedBox(
        height: CATEGORY_BAR_HEIGHT,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              labelStyle: context.body2(fontWeight: FontWeight.bold),
              controller: tabController,
              tabs: categories
                  .map((category) => Tab(text: category.name))
                  .toList(),
              onTap: (index) {
                context
                    .read<ChallengeListFilterCubit>()
                    .updateCategory(category: categories[index]);
              },
            ),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Builder(
                  builder: (context) {
                    return Row(
                      children: [
                        for (final tag in state.category.tags)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 4,
                            ),
                            child:
                                TagButton(tag: tag, selected: tag == state.tag),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const FilterTopBar(),
          ],
        ),
      );
    });
  }
}

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.selected,
    required this.tag,
  });

  final bool selected;
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ChallengeListFilterCubit>().updateTag(tag: tag);
      },
      borderRadius: BorderRadius.circular(40),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.systemGrey1 : AppColors.systemWhite,
          border: Border.all(
            color: selected ? AppColors.systemGrey1 : AppColors.systemGrey3,
            width: 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(23),
          ),
        ),
        child: Text(
          tag.name,
          style: context.body4(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? AppColors.systemWhite : AppColors.systemGrey1,
          ),
        ),
      ),
    );
  }
}
