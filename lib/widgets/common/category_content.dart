import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class CategoryContent extends StatelessWidget {
  const CategoryContent({
    super.key,
    required this.category,
    required this.handleSelect,
    required this.itemList,
  });

  final Category category;
  final void Function(Tag) handleSelect;
  final List<Tag?> itemList;

  bool isSelected(Tag tag) {
    if (itemList.isEmpty) return false;
    return itemList.map((e) => e!.value).toList().contains(tag.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              category.name,
              style: context.body1(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 2),
            Text(category.emoji, style: context.body1()),
          ],
        ),
        const SizedBox(height: 5),
        Wrap(
          children: [
            for (Tag tag in category.tags)
              Builder(builder: (ctx) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      side: isSelected(tag)
                          ? const BorderSide(color: AppColors.lightOrange)
                          : const BorderSide(color: AppColors.systemGrey3),
                      backgroundColor: isSelected(tag)
                          ? AppColors.lightOrange
                          : AppColors.bgColor1,
                    ),
                    onPressed: () {
                      handleSelect(tag);
                    },
                    child: Text(
                      '${tag.name}',
                      style: isSelected(tag)
                          ? context.body4(
                              color: AppColors.orange,
                              fontWeight: FontWeight.bold,
                            )
                          : context.body4(color: AppColors.systemGrey1),
                    ),
                  ),
                );
              })
          ],
        ),
        const SizedBox(height: 25)
      ],
    );
  }
}
