import 'dart:io';
import 'package:dodal_app/providers/create_user_cubit.dart';
import 'package:dodal_app/screens/sign_up/agreement_screen.dart';
import 'package:dodal_app/screens/sign_up/input_form_screen.dart';
import 'package:dodal_app/screens/sign_up/tag_select_screen.dart';
import 'package:dodal_app/screens/welcome/main.dart';
import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/widgets/common/create_screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  int _currentIndex = 0;
  int steps = 3;
  File? image;

  _submit() async {
    final signUpData = BlocProvider.of<CreateUserCubit>(context).state;
    SignUpResponse? res = await UserService.signUp(
      signUpData.socialType,
      signUpData.socialId,
      signUpData.email,
      signUpData.nickname,
      signUpData.image,
      signUpData.content,
      signUpData.category.map((e) => e!.value as String).toList(),
    );
    if (res == null) return;
    if (res.accessToken != null && res.refreshToken != null) {
      secureStorage.write(key: 'accessToken', value: res.accessToken);
      secureStorage.write(key: 'refreshToken', value: res.refreshToken);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const WelcomeScreen()),
        (route) => false,
      );
    }
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
          nextStep: () {
            _submit();
          },
        ),
      ],
    );
  }
}
