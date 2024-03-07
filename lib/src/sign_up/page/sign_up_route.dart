import 'package:dodal_app/src/common/model/user_model.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/sign_up/bloc/sign_up_cubit.dart';
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
    context.read<UserBloc>().add(UpdateUserBlocEvent(user));
    final id = context.read<SignUpCubit>().socialId;
    final email = context.read<SignUpCubit>().email;
    final type = context.read<SignUpCubit>().socialType;
    context.go('/sign-up/$id/$email/$type/complete');
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
              context.go('/sign-in');
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
        SignUpAgreementPage(
          steps: steps,
          step: _currentIndex + 1,
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        SignUpInputFormPage(
          steps: steps,
          step: _currentIndex + 1,
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        SignUpTagSelectPage(
          steps: steps,
          step: _currentIndex + 1,
          success: createUserSuccess,
          error: createUserError,
        ),
      ],
    );
  }
}
