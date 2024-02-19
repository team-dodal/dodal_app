import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/sign_in_bloc.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/screens/sign_up/agreement_screen.dart';
import 'package:dodal_app/screens/sign_up/complete_screen.dart';
import 'package:dodal_app/screens/sign_up/input_form_screen.dart';
import 'package:dodal_app/screens/sign_up/tag_select_screen.dart';
import 'package:dodal_app/layout/create_screen_layout.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentIndex = 0;
  int steps = 3;

  createUserSuccess(User user) {
    context.read<UserBloc>().add(UpdateUserBlocEvent(user));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const CompleteSignUpScreen()),
      (route) => false,
    );
  }

  createUserError(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
        title: '에러가 발생하였습니다',
        subTitle: errorMessage,
        children: [
          SystemDialogButton(
            text: '확인',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (ctx) => BlocProvider(
                    create: (context) =>
                        SignInBloc(const FlutterSecureStorage()),
                    child: const SignInScreen(),
                  ),
                ),
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreateScreenLayout(
      currentIndex: _currentIndex,
      popStep: () {
        setState(() {
          _currentIndex -= 1;
        });
      },
      children: [
        AgreementScreen(
          steps: steps,
          step: _currentIndex + 1,
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        InputFormScreen(
          steps: steps,
          step: _currentIndex + 1,
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        TagSelectScreen(
          steps: steps,
          step: _currentIndex + 1,
          success: createUserSuccess,
          error: createUserError,
        ),
      ],
    );
  }
}
