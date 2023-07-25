import 'dart:io';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/common/number_input.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/common/text_input.dart';
import 'package:dodal_app/widgets/create_challenge/thumbnail_image_input.dart';
import 'package:flutter/material.dart';

class ChallengeTitleScreen extends StatefulWidget {
  const ChallengeTitleScreen({
    super.key,
    required this.steps,
    required this.step,
    required this.nextStep,
    required this.title,
    required this.content,
    required this.thumbnailImg,
    required this.recruitCnt,
  });

  final int steps, step;
  final void Function({
    String title,
    String content,
    int recruitCnt,
    File? thumbnailImg,
  }) nextStep;
  final String title, content;
  final File? thumbnailImg;
  final int? recruitCnt;

  @override
  State<ChallengeTitleScreen> createState() => _ChallengeTitleScreenState();
}

class _ChallengeTitleScreenState extends State<ChallengeTitleScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController headCountController = TextEditingController();
  File? _thumbnail;

  _isSubmitAble() {
    if (titleController.text.isEmpty) return false;
    if (contentController.text.isEmpty) return false;
    if (headCountController.text.isEmpty ||
        int.parse(headCountController.text) == 0) return false;
    return true;
  }

  _submit() {
    widget.nextStep(
      title: titleController.text,
      content: contentController.text,
      thumbnailImg: _thumbnail,
      recruitCnt: int.parse(headCountController.text),
    );
  }

  @override
  void initState() {
    setState(() {
      titleController.text = widget.title;
      contentController.text = widget.content;
      headCountController.text = (widget.recruitCnt ?? '').toString();
      _thumbnail = widget.thumbnailImg;
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    titleController.dispose();
    contentController.dispose();
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
              CreateFormTitle(
                title: '어떤 도전을 만들고 싶나요?',
                steps: widget.steps,
                currentStep: widget.step,
              ),
              const SizedBox(height: 40),
              TextInput(
                controller: titleController,
                title: '도전 제목',
                required: true,
                maxLength: 30,
                wordLength: '${titleController.text.length}/30',
                placeholder: '도전 제목을 입력해주세요.',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 32),
              ThumbnailImageInput(
                image: _thumbnail,
                onChange: (image) {
                  setState(() {
                    _thumbnail = image;
                  });
                },
              ),
              const SizedBox(height: 32),
              TextInput(
                controller: contentController,
                title: '도전 소개',
                required: true,
                maxLength: 500,
                wordLength: '${contentController.text.length}/500',
                multiLine: true,
                placeholder: '참여자들의 이해를 위해 설명할 내용이나\n참여 방법 등을 세부적으로 알려주세요.',
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 32),
              NumberInput(
                controller: headCountController,
                maxNumber: 20,
                title: '모집 인원',
                required: true,
                placeholder: '모집 인원을 설정해주세요.',
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
