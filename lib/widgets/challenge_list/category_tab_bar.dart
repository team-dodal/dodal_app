import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

const double CATEGORY_BAR_HEIGHT = 120;

class CategoryTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoryTabBar({
    super.key,
    required this.tabController,
    required this.categories,
    required this.onCategoryTab,
    required this.categoryIndex,
    required this.tagIndex,
    required this.onTagTab,
  });

  final TabController tabController;
  final List<Category> categories;
  final void Function(int) onCategoryTab;
  final int categoryIndex;
  final int tagIndex;
  final void Function(dynamic) onTagTab;

  @override
  Size get preferredSize => const Size.fromHeight(CATEGORY_BAR_HEIGHT);

  isCurrentTag(Tag tag) {
    return categories[categoryIndex].tags[tagIndex] == tag;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CATEGORY_BAR_HEIGHT,
      child: Column(
        children: [
          TabBar(
            controller: tabController,
            tabs:
                categories.map((category) => Tab(text: category.name)).toList(),
            onTap: (value) {
              onCategoryTab(value);
            },
          ),
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final tag in categories[categoryIndex].tags)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 4,
                      ),
                      child: InkWell(
                        onTap: () {
                          final idx = categories[categoryIndex]
                              .tags
                              .indexWhere((item) => item == tag);
                          onTagTab(idx);
                        },
                        borderRadius: BorderRadius.circular(40),
                        child: Ink(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: isCurrentTag(tag)
                                ? AppColors.systemGrey1
                                : AppColors.systemWhite,
                            border: Border.all(
                              color: isCurrentTag(tag)
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
                                  color: isCurrentTag(tag)
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
  }
}
