import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/services/category_service.dart';
import 'package:dodal_app/widgets/common/category_content.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeTagScreen extends StatefulWidget {
  const ChallengeTagScreen({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
  });

  final int steps, step;
  final void Function() nextStep;

  @override
  State<ChallengeTagScreen> createState() => _ChallengeTagScreenState();
}

class _ChallengeTagScreenState extends State<ChallengeTagScreen> {
  ScrollController scrollController = ScrollController();
  final Future<List<Category>?> _categories =
      CategoryService.getAllCategories();

  _handleSelect(value) {
    context.read<CreateChallengeCubit>().updateData(tagValue: value);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateChallengeCubit, CreateChallenge>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('도전 만들기')),
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
                FutureBuilder(
                  future: _categories,
                  builder: (context, snapshot) {
                    Widget? child;
                    if (snapshot.connectionState == ConnectionState.done) {
                      final List<Category> categories = snapshot.data!;
                      child = Column(
                        children: [
                          for (Category category in categories)
                            CategoryContent(
                              category: category,
                              handleSelect: _handleSelect,
                              itemList: [state.tagValue],
                            )
                        ],
                      );
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: child,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: SubmitButton(
          onPress: state.tagValue != null ? widget.nextStep : null,
          title: '다음',
        ),
      );
    });
  }
}