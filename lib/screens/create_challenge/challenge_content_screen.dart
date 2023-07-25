import 'dart:io';
import 'package:dodal_app/widgets/common/input_title.dart';
import 'package:dodal_app/widgets/common/select_input.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/common/text_input.dart';
import 'package:dodal_app/widgets/create_challenge/certificate_image_input.dart';
import 'package:flutter/material.dart';

class ChallengeContentScreen extends StatefulWidget {
  const ChallengeContentScreen({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
    required this.certCnt,
    required this.correctImg,
    required this.wrongImg,
    required this.certContent,
    required this.warnContent,
  });

  final int steps, step;
  final void Function({
    required int certCnt,
    required String certContent,
    required String warnContent,
    required File? correctImg,
    required File? wrongImg,
  }) nextStep;
  final int certCnt;
  final File? correctImg, wrongImg;
  final String certContent, warnContent;

  @override
  State<ChallengeContentScreen> createState() => _ChallengeContentScreenState();
}

class _ChallengeContentScreenState extends State<ChallengeContentScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController certContentController = TextEditingController();
  TextEditingController warnContentController = TextEditingController();
  Select? _certCount;
  File? _correctImg;
  File? _wrongImg;

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
    if (_certCount == null) return false;
    if (certContentController.text.isEmpty) return false;
    if (warnContentController.text.isEmpty) return false;
    return true;
  }

  _submit() {
    widget.nextStep(
      certCnt: _certCount!.value,
      certContent: certContentController.text,
      warnContent: warnContentController.text,
      correctImg: null,
      wrongImg: null,
    );
  }

  @override
  void initState() {
    setState(() {
      certContentController.text = widget.certContent;
      warnContentController.text = widget.warnContent;
      _certCount =
          _selectList.firstWhere((item) => item.value == widget.certCnt);
      _correctImg = widget.correctImg;
      _wrongImg = widget.wrongImg;
    });
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
                value: _certCount,
                onChanged: (value) {
                  setState(() {
                    _certCount = value;
                  });
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
                  setState(() {});
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
                        image: _correctImg,
                        onChange: (value) {
                          _correctImg = value;
                        },
                        certOption: CertOption.correct),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CertificateImageInput(
                      image: _wrongImg,
                      onChange: (value) {
                        _wrongImg = value;
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
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: SubmitButton(
        onPress: _isSubmitAble() ? _submit : null,
        title: '다음',
      ),
    );
  }
}
