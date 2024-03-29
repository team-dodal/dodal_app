import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/bloc/nickname_check_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NicknameInput extends StatelessWidget {
  const NicknameInput({
    super.key,
    required this.nicknameController,
    required this.onApproveNickname,
  });

  final TextEditingController nicknameController;
  final void Function(String nickname) onApproveNickname;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NicknameBloc, NicknameState>(
      listener: (context, state) {
        if (state.status == CommonStatus.loaded) {
          onApproveNickname(state.nickname);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextInput(
              controller: nicknameController,
              title: '닉네임',
              placeholder: '사용하실 닉네임을 입력해주세요.',
              required: true,
              wordLength: '${nicknameController.text.length}/16',
              maxLength: 16,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                context.read<NicknameBloc>().add(ChangeNicknameEvent(value));
              },
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                onPressed: state.status == CommonStatus.loaded
                    ? null
                    : () {
                        context.read<NicknameBloc>().add(CheckNicknameEvent());
                      },
                child: const Text('중복 확인'),
              ),
            ),
            const SizedBox(height: 6),
            if (state.status == CommonStatus.loaded)
              Text(
                '중복 확인 완료되었습니다.',
                style: context.caption(color: AppColors.success),
              ),
            if (state.status == CommonStatus.error)
              Text(
                state.errorMessage!,
                style: context.caption(color: AppColors.danger),
              ),
          ],
        );
      },
    );
  }
}
