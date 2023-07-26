import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/widgets/common/input_title.dart';
import 'package:dodal_app/widgets/common/select_input.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/common/text_input.dart';
import 'package:dodal_app/widgets/create_challenge/certificate_image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeContentScreen extends StatefulWidget {
  const ChallengeContentScreen({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
  });

  final int steps, step;
  final void Function() nextStep;

  @override
  State<ChallengeContentScreen> createState() => _ChallengeContentScreenState();
}

class _ChallengeContentScreenState extends State<ChallengeContentScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController certContentController = TextEditingController();
  TextEditingController warnContentController = TextEditingController();

  final List<Select> _selectList = [
    Select(label: '주 1회', value: 1),
    Select(label: '주 2회', value: 2),
    Select(label: '주 3회', value: 3),
    Select(label: '주 4회', value: 4),
    Select(label: '주 5회', value: 5),
    Select(label: '주 6회', value: 6),
    Select(label: '주 7회', value: 7),
  ];

  _isSubmitAble() {
    final state = BlocProvider.of<CreateChallengeCubit>(context).state;
    if (state.certCnt == null) return false;
    if (state.certContent == null || state.certContent == '') return false;
    if (state.warnContent == null || state.warnContent == '') return false;
    return true;
  }

  @override
  void initState() {
    final state = BlocProvider.of<CreateChallengeCubit>(context).state;
    certContentController.text = state.certContent ?? '';
    warnContentController.text = state.warnContent ?? '';
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    certContentController.dispose();
    warnContentController.dispose();
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
                SelectInput(
                  title: '인증 빈도수',
                  required: true,
                  placeholder: '빈도수를 선택해주세요.',
                  value: _selectList
                      .firstWhere((element) => element.value == state.certCnt),
                  onChanged: (value) {
                    context
                        .read<CreateChallengeCubit>()
                        .updateData(certCnt: value.value);
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
                        .read<CreateChallengeCubit>()
                        .updateData(certContent: value);
                  },
                ),
                const SizedBox(height: 32),
                const InputTitle(
                  title: '인증 예시',
                  subTitle: '사진을 통해 인증 성공과 실패 예시를 추가해주세요.',
                  required: true,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CertificateImageInput(
                          image: state.certCorrectImg,
                          onChange: (value) {
                            context
                                .read<CreateChallengeCubit>()
                                .updateData(certCorrectImg: value);
                          },
                          certOption: CertOption.correct),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CertificateImageInput(
                        image: state.certWrongImg,
                        onChange: (value) {
                          context
                              .read<CreateChallengeCubit>()
                              .updateData(certWrongImg: value);
                        },
                        certOption: CertOption.wrong,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                TextInput(
                  controller: warnContentController,
                  title: '주의사항',
                  required: true,
                  maxLength: 500,
                  wordLength: '${warnContentController.text.length}/500',
                  multiLine: true,
                  placeholder:
                      '참여자에게 도전 참가 주의사항에 대해 알려주세요.\nex) 10번 이상 인증 실패시 강퇴 처리 됩니다.',
                  onChanged: (value) {
                    context
                        .read<CreateChallengeCubit>()
                        .updateData(warnContent: value);
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: SubmitButton(
          onPress: _isSubmitAble() ? widget.nextStep : null,
          title: '다음',
        ),
      );
    });
  }
}
