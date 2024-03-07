import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/sign_up/bloc/sign_up_cubit.dart';
import 'package:dodal_app/src/common/bloc/nickname_check_bloc.dart';
import 'package:dodal_app/src/common/widget/create_form_title.dart';
import 'package:dodal_app/src/common/widget/avatar_image.dart';
import 'package:dodal_app/src/common/widget/input/nickname_input.dart';
import 'package:dodal_app/src/common/widget/submit_button.dart';
import 'package:dodal_app/src/common/widget/input/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpInputFormPage extends StatefulWidget {
  const SignUpInputFormPage({
    super.key,
    required this.nextStep,
    required this.step,
    required this.steps,
  });

  final void Function() nextStep;
  final int step;
  final int steps;

  @override
  State<SignUpInputFormPage> createState() => _SignUpInputFormPageState();
}

class _SignUpInputFormPageState extends State<SignUpInputFormPage> {
  ScrollController scrollController = ScrollController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    SignUpState signUpData = BlocProvider.of<SignUpCubit>(context).state;
    nicknameController.text = signUpData.nickname;
    contentController.text = signUpData.content;
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
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
                    steps: widget.steps,
                  ),
                  const SizedBox(height: 60),
                  AvatarImage(
                    width: 100,
                    height: 100,
                    onChanged: (image) {
                      context.read<SignUpCubit>().updateImage(image);
                    },
                    image: state.image,
                  ),
                  const SizedBox(height: 35),
                  NicknameInput(
                    nicknameController: nicknameController,
                    onApproveNickname: (nickname) {
                      context.read<SignUpCubit>().updateNickname(nickname);
                    },
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
                      context.read<SignUpCubit>().updateContent(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: BlocBuilder<NicknameBloc, NicknameState>(
              builder: (context, state) {
            return SubmitButton(
              title: '다음',
              onPress:
                  state.status == CommonStatus.loaded ? widget.nextStep : null,
            );
          }),
        );
      },
    );
  }
}
