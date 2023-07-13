import 'dart:io';
import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/sign_up/profile_image_select.dart';
import 'package:dodal_app/widgets/sign_up/submit_button.dart';
import 'package:dodal_app/widgets/common/text_input.dart';
import 'package:flutter/material.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({
    super.key,
    required this.nextStep,
    required this.step,
    required this.nickname,
    required this.content,
    this.image,
  });

  final Function nextStep;
  final int step;
  final String nickname;
  final String content;
  final File? image;

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool _nicknameChecked = false;
  String? _nicknameError;
  File? _image;

  _checkingNickname() async {
    if (nicknameController.text.isEmpty) {
      setState(() {
        _nicknameError = '닉네임을 입력해주세요!';
      });
      return;
    }
    final res = await UserService.checkNickName(nicknameController.text);
    if (!mounted) return;
    if (res) {
      setState(() {
        _nicknameError = null;
        _nicknameChecked = res;
      });
    } else {
      setState(() {
        _nicknameError = '사용할 수 없는 닉네임입니다!';
      });
    }
  }

  _handleNextStep() async {
    widget.nextStep({
      'nickname': nicknameController.text,
      'content': contentController.text,
      'image': _image,
    });
  }

  @override
  void initState() {
    nicknameController.text = widget.nickname;
    contentController.text = widget.content;
    setState(() {
      if (widget.nickname.isNotEmpty) {
        _nicknameChecked = true;
      }
      _image = widget.image;
    });
    super.initState();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    contentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 설정')),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            children: [
              CreateFormTitle(
                title: '도달러들에게\n자신을 소개해주세요.',
                currentStep: widget.step,
                steps: 2,
              ),
              const SizedBox(height: 60),
              ProfileImageSelect(
                onChanged: (image) {
                  setState(() {
                    _image = image;
                  });
                },
                image: widget.image ?? _image,
              ),
              const SizedBox(height: 35),
              TextInput(
                controller: nicknameController,
                title: '닉네임',
                placeholder: '사용하실 닉네임을 입력해주세요.',
                required: true,
                wordLength: '${nicknameController.text.length}/16',
                maxLength: 16,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    _nicknameChecked = false;
                  });
                },
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: _nicknameChecked
                      ? null
                      : () {
                          _checkingNickname();
                        },
                  child: const Text('중복 확인'),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (_nicknameChecked)
                    Text(
                      '중복 확인 완료되었습니다.',
                      style: Typo(context)
                          .caption()!
                          .copyWith(color: AppColors.success),
                    ),
                  if (_nicknameError != null)
                    Text(
                      _nicknameError!,
                      style: Typo(context)
                          .caption()!
                          .copyWith(color: AppColors.danger),
                    ),
                ],
              ),
              const SizedBox(height: 40),
              TextInput(
                controller: contentController,
                title: '한 줄 소개',
                placeholder: '소개하고 싶은 문구를 입력해주세요.',
                wordLength: '${contentController.text.length}/50',
                maxLength: 50,
                multiLine: true,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: MediaQuery.of(context).viewInsets.bottom != 0
          ? null
          : SubmitButton(
              title: '다음',
              onPress: _nicknameChecked ? _handleNextStep : null,
            ),
    );
  }
}
