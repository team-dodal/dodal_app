import 'package:dodal_app/src/common/model/user_model.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/sign_up/page/sign_up_agreement_page.dart';
import 'package:dodal_app/src/sign_up/page/sign_up_input_form_page.dart';
import 'package:dodal_app/src/sign_up/page/sign_up_tag_select_page.dart';
import 'package:dodal_app/src/common/layout/create_screen_layout.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpRoute extends StatefulWidget {
  const SignUpRoute({super.key});

  @override
  State<SignUpRoute> createState() => _SignUpRouteState();
}

class _SignUpRouteState extends State<SignUpRoute> {
  int _currentIndex = 0;
  int steps = 3;

  createUserSuccess(User user) {
    context.read<AuthBloc>().add(UpdateUserBlocEvent(user));
    context.go('/sign-up-complete');
  }

  createUserError(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(
        title: '에러가 발생하였습니다',
        subTitle: errorMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CreateScreenLayout(
      currentIndex: _currentIndex,
      children: [
        SignUpAgreementPage(
          steps: steps,
          step: _currentIndex + 1,
          previousStep: () {
            context.read<AuthBloc>().add(ClearUserBlocEvent());
          },
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        SignUpInputFormPage(
          steps: steps,
          step: _currentIndex + 1,
          previousStep: () {
            setState(() {
              _currentIndex -= 1;
            });
          },
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        SignUpTagSelectPage(
          steps: steps,
          step: _currentIndex + 1,
          previousStep: () {
            setState(() {
              _currentIndex -= 1;
            });
          },
          success: createUserSuccess,
          error: createUserError,
        ),
      ],
    );
  }
}
