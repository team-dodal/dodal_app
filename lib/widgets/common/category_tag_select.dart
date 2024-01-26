import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/providers/category_list_bloc.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryTagSelect extends StatelessWidget {
  const CategoryTagSelect({
    super.key,
    required this.selectedList,
    required this.onChange,
  });

  final List<Tag> selectedList;
  final void Function(Tag value) onChange;

  @override
  Widget build(BuildContext context) {
    Color buttonBorderColor(tag) => selectedList.contains(tag)
        ? AppColors.lightOrange
        : AppColors.systemGrey3;
    Color buttonBackgroundColor(tag) =>
        selectedList.contains(tag) ? AppColors.lightOrange : AppColors.bgColor1;
    TextStyle buttonTextStyle(tag) => selectedList.contains(tag)
        ? context.body4(color: AppColors.orange, fontWeight: FontWeight.bold)!
        : context.body4(
            color: AppColors.systemGrey1, fontWeight: FontWeight.w500)!;

    return BlocBuilder<CategoryListBloc, CategoryListState>(
      builder: (context, state) {
        if (state.status == CategoryListStatus.error) {
          return Center(child: Text(state.errorMessage!));
        }
        if (state.status == CategoryListStatus.loaded) {
          return Column(
            children: [
              for (Category category in state.result)
                Column(
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
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                  ),
                                  side:
                                      BorderSide(color: buttonBorderColor(tag)),
                                  backgroundColor: buttonBackgroundColor(tag)),
                              onPressed: () {
                                // List<Tag> clone = [...selectedList];
                                // clone.contains(tag)
                                //     ? clone.remove(tag)
                                //     : clone.add(tag);
                                onChange(tag);
                              },
                              child: Text(
                                '${tag.name}',
                                style: buttonTextStyle(tag),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 25)
                  ],
                ),
            ],
          );
        }
        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }
}
