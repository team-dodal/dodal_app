import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/services/category/service.dart';
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
    final list = _addAllValueTag([
      Category(
        name: '전체',
        subName: '',
        value: null,
        emoji: '',
        tags: const [],
      ),
      ...categoryList
    ]);
    tabController = TabController(length: list.length, vsync: this);
    if (mounted) {
      final state = BlocProvider.of<ChallengeListFilterCubit>(context).state;
      final selectedIdx =
          list.indexWhere((category) => category.value == state.category.value);
      tabController.index = selectedIdx;
      context
          .read<ChallengeListFilterCubit>()
          .updateTag(tag: list[selectedIdx].tags[0]);
      setState(() {
        _categories = list;
      });
    }
  }

  List<Category> _addAllValueTag(List<Category> list) {
    return list.map((category) {
      category.tags = [const Tag(name: '전체', value: null), ...category.tags];
      return category;
    }).toList();
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
              isScrollable: true,
              labelStyle: context.body2(fontWeight: FontWeight.bold),
              controller: tabController,
              tabs: _categories
                  .map((category) => Tab(text: category.name))
                  .toList(),
              onTap: (value) {
                context
                    .read<ChallengeListFilterCubit>()
                    .updateCategory(category: _categories[value]);
                context
                    .read<ChallengeListFilterCubit>()
                    .updateTag(tag: _categories[value].tags[0]);
              },
            ),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Builder(builder: (context) {
                  final tagList = _categories.firstWhere(
                      (category) => category.value == state.category.value);
                  return Row(
                    children: [
                      for (final tag in tagList.tags)
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
                }),
              ),
            )
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
