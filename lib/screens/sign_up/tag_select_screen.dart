import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/sign_up/submit_button.dart';
import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../../model/tag_model.dart';
import '../../services/category_service.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({
    super.key,
    required this.step,
    required this.nextStep,
  });

  final int step;
  final Function nextStep;

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  final Future<dynamic> _categories = CategoryService.getAllCategories();

  List<String> _itemList = [];

  _handleNextStep() async {
    widget.nextStep({
      "category": ["001001", "002003", "004001"]
    });
  }

  _handleSelect(String value) {
    bool isSelected = _itemList.contains(value);
    final cp = _itemList;
    if (isSelected) {
      setState(() {
        cp.remove(value);
        _itemList = cp;
      });
    } else {
      setState(() {
        _itemList = [..._itemList, value];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _categories,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            final List<Category> categories = snapshot.data;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${widget.step}',
                                style: Typo(context)
                                    .body1()!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '/2',
                                style: Typo(context).body1()!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.systemGrey2,
                                    ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '자신을 소개해주세요!',
                            style: Typo(context)
                                .headline2()!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '1개 이상 선택하시면 딱 맞는 도전들을 추천드려요!',
                            style: Typo(context)
                                .body4()!
                                .copyWith(color: AppColors.systemGrey1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    for (Category category in categories)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: Typo(context)
                                .body1()!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Wrap(
                            children: [
                              for (Tag tag in category.tags)
                                Builder(builder: (ctx) {
                                  final isSelected =
                                      _itemList.contains(tag.value);
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
                                              : const BorderSide(
                                                  color: AppColors.systemGrey3),
                                          backgroundColor: isSelected
                                              ? AppColors.lightOrange
                                              : AppColors.bgColor1),
                                      onPressed: () {
                                        _handleSelect(tag.value);
                                      },
                                      child: Text(
                                        '${tag.name}',
                                        style: isSelected
                                            ? Typo(context).body4()!.copyWith(
                                                  color: AppColors.orange,
                                                  fontWeight: FontWeight.bold,
                                                )
                                            : Typo(context).body4()!.copyWith(
                                                color: AppColors.systemGrey1),
                                      ),
                                    ),
                                  );
                                })
                            ],
                          ),
                          const SizedBox(height: 25)
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet:
          SubmitButton(onPress: _itemList.isEmpty ? null : _handleNextStep),
    );
  }
}
