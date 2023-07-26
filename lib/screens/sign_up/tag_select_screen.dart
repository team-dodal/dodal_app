import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/providers/sign_up_form_cubit.dart';
import 'package:dodal_app/services/category_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/common/category_content.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagSelectScreen extends StatefulWidget {
  const TagSelectScreen({
    super.key,
    required this.step,
    required this.nextStep,
    required this.steps,
  });

  final int step;
  final int steps;
  final void Function() nextStep;

  @override
  State<TagSelectScreen> createState() => _TagSelectScreenState();
}

class _TagSelectScreenState extends State<TagSelectScreen> {
  final Future<dynamic> _categories = CategoryService.getAllCategories();

  handleSelect(String value) {
    List<String?> categoryList =
        BlocProvider.of<CreateUserCubit>(context).state.category;
    final copy = categoryList;
    bool isSelected = categoryList.contains(value);
    if (isSelected) {
      copy.remove(value);
    } else {
      copy.add(value);
    }
    setState(() {
      context.read<CreateUserCubit>().updateData(category: copy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateUserCubit, CreateUser>(builder: (context, state) {
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
                        steps: widget.steps,
                      ),
                      const SizedBox(height: 40),
                      for (Category category in categories)
                        CategoryContent(
                          category: category,
                          handleSelect: handleSelect,
                          itemList: state.category,
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
          onPress: state.category.isEmpty ? null : widget.nextStep,
        ),
      );
    });
  }
}
