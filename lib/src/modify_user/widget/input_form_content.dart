import 'package:dodal_app/src/modify_user/bloc/modify_user_cubit.dart';
import 'package:dodal_app/src/common/widget/input/nickname_input.dart';
import 'package:dodal_app/src/common/widget/input/text_input.dart';
import 'package:dodal_app/src/common/widget/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputFormContent extends StatelessWidget {
  const InputFormContent({
    super.key,
    required this.nicknameController,
    required this.contentController,
  });

  final TextEditingController nicknameController;
  final TextEditingController contentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          AvatarImage(
            width: 100,
            height: 100,
            onChanged: context.read<ModifyUserCubit>().updateImage,
            image: context.read<ModifyUserCubit>().state.image,
          ),
          const SizedBox(height: 35),
          NicknameInput(
            nicknameController: nicknameController,
            onApproveNickname: context.read<ModifyUserCubit>().updateNickname,
          ),
          const SizedBox(height: 40),
          TextInput(
            controller: contentController,
            title: '한 줄 소개',
            placeholder: '소개하고 싶은 문구를 입력해주세요.',
            wordLength: '${contentController.text.length}/50',
            maxLength: 50,
            multiLine: true,
            onChanged: context.read<ModifyUserCubit>().updateContent,
          ),
        ],
      ),
    );
  }
}
