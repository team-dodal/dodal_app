import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';

import '../../theme/typo.dart';

class CategoryContent extends StatelessWidget {
  const CategoryContent({
    super.key,
    required this.category,
    required this.handleSelect,
    required this.itemList,
  });

  final Category category;
  final void Function(String) handleSelect;
  final List<String?> itemList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              category.name,
              style:
                  Typo(context).body1()!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 2),
            Text(category.emoji, style: Typo(context).body1()),
          ],
        ),
        const SizedBox(height: 5),
        Wrap(
          children: [
            for (Tag tag in category.tags)
              Builder(builder: (ctx) {
                final isSelected = itemList.contains(tag.value);
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
                        side: isSelected
                            ? BorderSide.none
                            : const BorderSide(color: AppColors.systemGrey3),
                        backgroundColor: isSelected
                            ? AppColors.lightOrange
                            : AppColors.bgColor1),
                    onPressed: () {
                      handleSelect(tag.value);
                    },
                    child: Text(
                      '${tag.name}',
                      style: isSelected
                          ? Typo(context).body4()!.copyWith(
                                color: AppColors.orange,
                                fontWeight: FontWeight.bold,
                              )
                          : Typo(context)
                              .body4()!
                              .copyWith(color: AppColors.systemGrey1),
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
