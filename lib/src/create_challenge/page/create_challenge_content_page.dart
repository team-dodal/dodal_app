import 'package:dodal_app/src/create_challenge/bloc/create_challenge_cubit.dart';
import 'package:dodal_app/src/common/widget/create_form_title.dart';
import 'package:dodal_app/src/common/widget/input/input_title.dart';
import 'package:dodal_app/src/common/widget/input/select_input.dart';
import 'package:dodal_app/src/common/widget/submit_button.dart';
import 'package:dodal_app/src/common/widget/input/text_input.dart';
import 'package:dodal_app/src/create_challenge/widget/certificate_image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengeContentPage extends StatefulWidget {
  const CreateChallengeContentPage({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
  });

  final int steps, step;
  final void Function() nextStep;

  @override
  State<CreateChallengeContentPage> createState() =>
      _CreateChallengeContentPageState();
}

class _CreateChallengeContentPageState
    extends State<CreateChallengeContentPage> {
  ScrollController scrollController = ScrollController();
  TextEditingController certContentController = TextEditingController();

  final List<Select> _selectList = List.generate(
    7,
    (index) => Select(label: '주 ${index + 1}회', value: index + 1),
  );

  @override
  void initState() {
    final state = BlocProvider.of<CreateChallengeBloc>(context).state;
    certContentController.text = state.certContent;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    certContentController.dispose();
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
                    title: '인증 방법을 설정해주세요!',
                    steps: widget.steps,
                    currentStep: widget.step,
                  ),
                  const SizedBox(height: 40),
                  SelectInput(
                    title: '인증 빈도수',
                    required: true,
                    placeholder: '빈도수를 선택해주세요.',
                    value: _selectList.firstWhere(
                        (element) => element.value == state.certCnt),
                    onChanged: (value) {
                      context
                          .read<CreateChallengeBloc>()
                          .add(ChangeCertCntEvent(value.value));
                    },
                    list: _selectList,
                  ),
                  const SizedBox(height: 32),
                  TextInput(
                    controller: certContentController,
                    title: '인증 방법',
                    required: true,
                    maxLength: 500,
                    wordLength: '${certContentController.text.length}/500',
                    multiLine: true,
                    placeholder: '참여 인증 방법에 대해 세부적으로 알려주세요.',
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      context
                          .read<CreateChallengeBloc>()
                          .add(ChangeCertContentEvent(value));
                    },
                  ),
                  const SizedBox(height: 32),
                  const InputTitle(
                    title: '인증 예시',
                    subTitle: '사진을 통해 인증 성공과 실패 예시를 추가해주세요.',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CertificateImageInput(
                            image: state.certCorrectImg,
                            onChange: (value) {
                              context
                                  .read<CreateChallengeBloc>()
                                  .add(ChangeCertCorrectImgEvent(value));
                            },
                            certOption: CertOption.correct),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CertificateImageInput(
                          image: state.certWrongImg,
                          onChange: (value) {
                            context
                                .read<CreateChallengeBloc>()
                                .add(ChangeCertWrongImgEvent(value));
                          },
                          certOption: CertOption.wrong,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: SubmitButton(
            onPress: state.certContent.isNotEmpty ? widget.nextStep : null,
            title: '다음',
          ),
        );
      },
    );
  }
}
