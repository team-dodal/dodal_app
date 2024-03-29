import 'package:dodal_app/src/create_challenge/bloc/create_challenge_cubit.dart';
import 'package:dodal_app/src/common/widget/category_tag_select.dart';
import 'package:dodal_app/src/common/widget/create_form_title.dart';
import 'package:dodal_app/src/common/widget/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengeTagPage extends StatefulWidget {
  const CreateChallengeTagPage({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
  });

  final int steps, step;
  final void Function() nextStep;

  @override
  State<CreateChallengeTagPage> createState() => _CreateChallengeTagPageState();
}

class _CreateChallengeTagPageState extends State<CreateChallengeTagPage> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateChallengeBloc, CreateChallengeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(state.isUpdate ? '도전 수정하기' : '도전 만들기')),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              child: Column(
                children: [
                  CreateFormTitle(
                    title: '도전 주제를 선택해 주세요!',
                    steps: widget.steps,
                    currentStep: widget.step,
                  ),
                  const SizedBox(height: 40),
                  CategoryTagSelect(
                      selectedList:
                          state.tagValue != null ? [state.tagValue!] : [],
                      onChange: (value) {
                        context
                            .read<CreateChallengeBloc>()
                            .add(ChangeTagEvent(value));
                      }),
                ],
              ),
            ),
          ),
          bottomSheet: SubmitButton(
            onPress: state.tagValue != null ? widget.nextStep : null,
            title: '다음',
          ),
        );
      },
    );
  }
}
