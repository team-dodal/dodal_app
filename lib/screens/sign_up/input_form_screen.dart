import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/sign_up/profile_image_select.dart';
import 'package:dodal_app/widgets/sign_up/submit_button.dart';
import 'package:dodal_app/widgets/sign_up/text_input.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import '../../widgets/common/system_dialog.dart';

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
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool _nicknameChecked = false;
  File? _image;

  _checkingNickname() async {
    final res = await UserService.checkNickName(nicknameController.text);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => SystemDialog(
        title: res ? '사용할 수 있는 닉네임입니다.' : '사용할 수 없는 닉네임입니다.',
        children: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
    setState(() {
      _nicknameChecked = res;
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 설정')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${widget.step}',
                          style: Typo(context)
                              .body1()!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '/2',
                          style: Typo(context).body1()!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.systemGrey2,
                              ),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '자신을 소개해주세요!',
                      style: Typo(context)
                          .headline2()!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
                      borderRadius: BorderRadius.circular(8),
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
              if (_nicknameChecked)
                Row(
                  children: [
                    Text(
                      '중복 확인 완료되었습니다.',
                      style: Typo(context)
                          .caption()!
                          .copyWith(color: Colors.green),
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
      bottomSheet: SubmitButton(
        onPress: _nicknameChecked ? _handleNextStep : null,
      ),
    );
  }
}
