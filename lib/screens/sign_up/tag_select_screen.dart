import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/sign_up_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/category_tag_select.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagSelectScreen extends StatelessWidget {
  const TagSelectScreen({
    super.key,
    required this.step,
    required this.steps,
    required this.success,
    required this.error,
  });

  final int step;
  final int steps;
  final void Function(User user) success;
  final void Function(String errorMessage) error;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          success(state.result!);
        }
        if (state.status == SignUpStatus.error) {
          error(state.errorMessage!);
        }
      },
      builder: (context, createUser) {
        return Scaffold(
          appBar: AppBar(title: const Text('프로필 설정')),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CreateFormTitle(
                    title: '무엇에 관심 있나요?',
                    subTitle: '1개 이상 선택하시면 딱 맞는 도전들을 추천드려요!',
                    currentStep: step,
                    steps: steps,
                  ),
                  const SizedBox(height: 40),
                  CategoryTagSelect(
                    selectedList: createUser.category,
                    onChange: context.read<SignUpCubit>().handleTag,
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
          ),
          bottomSheet: SubmitButton(
            title: '완료',
            onPress: createUser.category.isEmpty
                ? null
                : () {
                    context.read<SignUpCubit>().signUp();
                  },
          ),
        );
      },
    );
  }
}
