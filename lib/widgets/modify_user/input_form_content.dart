import 'dart:io';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/text_input.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:flutter/material.dart';

class InputFormContent extends StatefulWidget {
  const InputFormContent({
    super.key,
    required this.nicknameController,
    required this.contentController,
    required this.nicknameChecked,
    required this.setNicknameChecked,
    required this.imageUrl,
    this.uploadImage,
    required this.setImage,
  });

  final TextEditingController nicknameController;
  final TextEditingController contentController;
  final String? imageUrl;
  final File? uploadImage;
  final void Function(File?) setImage;
  final bool nicknameChecked;
  final void Function(bool) setNicknameChecked;

  @override
  State<InputFormContent> createState() => _InputFormContentState();
}

class _InputFormContentState extends State<InputFormContent> {
  String? _nicknameError;

  _checkingNickname() async {
    if (widget.nicknameController.text.isEmpty) {
      setState(() {
        _nicknameError = '닉네임을 입력해주세요!';
      });
      return;
    }
    final res = await UserService.checkNickName(widget.nicknameController.text);
    if (!mounted) return;
    if (res) {
      setState(() {
        _nicknameError = null;
        widget.setNicknameChecked(res);
      });
    } else {
      setState(() {
        _nicknameError = '사용할 수 없는 닉네임입니다!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          AvatarImage(
            width: 100,
            height: 100,
            onChanged: widget.setImage,
            image: widget.uploadImage ?? widget.imageUrl,
          ),
          const SizedBox(height: 35),
          TextInput(
              controller: widget.nicknameController,
              title: '닉네임',
              placeholder: '사용하실 닉네임을 입력해주세요.',
              required: true,
              wordLength: '${widget.nicknameController.text.length}/16',
              maxLength: 16,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                setState(() {
                  widget.setNicknameChecked(false);
                });
              },
              child: ElevatedButton(
                onPressed: widget.nicknameChecked ? null : _checkingNickname,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
                child: const Text('중복 확인'),
              )),
          const SizedBox(height: 6),
          Row(
            children: [
              if (widget.nicknameChecked)
                Text(
                  '중복 확인 완료되었습니다.',
                  style: context.caption(color: AppColors.success),
                ),
              if (_nicknameError != null)
                Text(
                  _nicknameError!,
                  style: context.caption(color: AppColors.danger),
                ),
            ],
          ),
          const SizedBox(height: 40),
          TextInput(
            controller: widget.contentController,
            title: '한 줄 소개',
            placeholder: '소개하고 싶은 문구를 입력해주세요.',
            wordLength: '${widget.contentController.text.length}/50',
            maxLength: 50,
            multiLine: true,
          ),
        ],
      ),
    );
  }
}
