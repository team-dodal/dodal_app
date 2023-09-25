import 'package:dodal_app/providers/create_user_cubit.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/create_form_title.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/common/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({
    super.key,
    required this.nextStep,
    required this.step,
    required this.steps,
  });

  final void Function() nextStep;
  final int step;
  final int steps;

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  bool _nicknameChecked = false;
  String? _nicknameError;

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

  @override
  void initState() {
    CreateUser signUpData = BlocProvider.of<CreateUserCubit>(context).state;
    nicknameController.text = signUpData.nickname;
    contentController.text = signUpData.content;
    setState(() {
      if (signUpData.nickname.isNotEmpty) {
        _nicknameChecked = true;
      }
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
        child:
            BlocBuilder<CreateUserCubit, CreateUser>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Column(
              children: [
                CreateFormTitle(
                  title: '도달러들에게\n자신을 소개해주세요.',
                  currentStep: widget.step,
                  steps: widget.steps,
                ),
                const SizedBox(height: 60),
                AvatarImage(
                  width: 100,
                  height: 100,
                  onChanged: (image) {
                    setState(() {
                      context.read<CreateUserCubit>().updateData(image: image);
                    });
                  },
                  image: state.image,
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
                      context
                          .read<CreateUserCubit>()
                          .updateData(nickname: value);
                    });
                  },
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
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
                  controller: contentController,
                  title: '한 줄 소개',
                  placeholder: '소개하고 싶은 문구를 입력해주세요.',
                  wordLength: '${contentController.text.length}/50',
                  maxLength: 50,
                  multiLine: true,
                  onChanged: (value) {
                    context.read<CreateUserCubit>().updateData(content: value);
                  },
                ),
              ],
            ),
          );
        }),
      ),
      bottomSheet: SubmitButton(
        title: '다음',
        onPress: _nicknameChecked ? widget.nextStep : null,
      ),
    );
  }
}
