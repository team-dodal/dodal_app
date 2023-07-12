import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/sign_up/category_content.dart';
import 'package:dodal_app/widgets/sign_up/submit_button.dart';
import 'package:flutter/material.dart';
import '../../model/category_model.dart';
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

  List<String> itemList = [];

  _handleNextStep() async {
    widget.nextStep({"category": itemList});
  }

  handleSelect(String value) {
    bool isSelected = itemList.contains(value);
    if (isSelected) {
      final copy = itemList;
      copy.remove(value);
      setState(() {
        itemList = copy;
      });
    } else {
      setState(() {
        itemList = [...itemList, value];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 설정')),
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
                    CreateFormTitle(
                      title: '무엇에 관심 있나요?',
                      subTitle: '1개 이상 선택하시면 딱 맞는 도전들을 추천드려요!',
                      currentStep: widget.step,
                      steps: 2,
                    ),
                    const SizedBox(height: 40),
                    for (Category category in categories)
                      CategoryContent(
                        category: category,
                        handleSelect: handleSelect,
                        itemList: itemList,
                      ),
                    const Center(
                      child: Text(
                        '관심사는 나중에 다시 수정할 수 있어요!',
                        style: TextStyle(color: AppColors.systemGrey2),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomSheet: SubmitButton(
        title: '완료',
        onPress: itemList.isEmpty ? null : _handleNextStep,
      ),
    );
  }
}
