import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/sign_up/text_input.dart';
import 'package:flutter/material.dart';

import '../../helper/validator.dart';
import '../../services/user_service.dart';
import '../../widgets/common/image_bottom_sheet.dart';
import '../../widgets/common/system_dialog.dart';

const double SUBMIT_BUTTON_HEIGHT = 90;

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({
    super.key,
    required this.nextStep,
    required this.step,
  });

  final Function nextStep;
  final int step;

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _nicknameChecked = false;
  String _nickname = '';
  String _content = '';
  File? _image;

  _checkingNickname() async {
    final res = await UserService.checkNickName(_nickname);
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

  _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ImageBottomSheet(
        setImage: (image) {
          setState(() {
            _image = image;
          });
        },
      ),
    );
  }

  _handleNextStep() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.nextStep({
      'nickname': _nickname,
      'content': _content,
      'image': _image,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(20, 20, 20, 20 + SUBMIT_BUTTON_HEIGHT),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text('${widget.step} / 2'),
                Text(
                  '자신을 소개해주세요!',
                  style: Typo(context)
                      .headline2()!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: _showBottomSheet,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.systemGrey3,
                      shape: BoxShape.circle,
                    ),
                    child: Builder(
                      builder: (context) {
                        if (_image != null) {
                          return Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        }
                        return const Icon(Icons.add, size: 40);
                      },
                    ),
                  ),
                ),
                TextInput(
                  title: '닉네임',
                  required: true,
                  wordLength: '${_nickname.length} / 16',
                  maxLength: 16,
                  validator: (value) {
                    return Validator.signUpNickname(value, _nicknameChecked);
                  },
                  onChanged: (value) {
                    setState(() {
                      _nickname = value;
                    });
                  },
                  onPressed: _checkingNickname,
                  buttonText: _nicknameChecked ? '확인 완료' : '중복 확인',
                ),
                const SizedBox(height: 40),
                TextInput(
                  title: '한 줄 소개',
                  wordLength: '${_content.length} / 50',
                  maxLength: 50,
                  multiLine: true,
                  validator: Validator.signUpContent,
                  onChanged: (value) {
                    setState(() {
                      _content = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SafeArea(
        child: SizedBox(
          height: SUBMIT_BUTTON_HEIGHT,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: _handleNextStep,
            child: const Text('다음'),
          ),
        ),
      ),
    );
  }
}
