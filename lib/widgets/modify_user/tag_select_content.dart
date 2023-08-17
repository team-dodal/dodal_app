import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/category/service.dart';
import 'package:dodal_app/widgets/common/category_content.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:flutter/material.dart';

class TagSelectContent extends StatefulWidget {
  const TagSelectContent({
    super.key,
    required this.itemList,
    required this.setItemList,
  });

  final List<Tag> itemList;
  final void Function(List<Tag>) setItemList;

  @override
  State<TagSelectContent> createState() => _TagSelectContentState();
}

class _TagSelectContentState extends State<TagSelectContent> {
  final Future<dynamic> _categories = CategoryService.getAllCategories();

  _handleSelect(Tag value) {
    bool isSelected = widget.itemList.contains(value);
    if (isSelected) {
      final copy = widget.itemList;
      copy.remove(value);
      widget.setItemList(copy);
    } else {
      widget.setItemList([...widget.itemList, value]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          const CreateFormTitle(
            title: '무엇에 관심 있나요?',
            subTitle: '1개 이상 선택하시면 딱 맞는 도전들을 추천드려요!',
          ),
          const SizedBox(height: 34),
          FutureBuilder(
            future: _categories,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              final List<Category> categories = snapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (Category category in categories)
                    CategoryContent(
                      category: category,
                      handleSelect: _handleSelect,
                      itemList: widget.itemList,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
