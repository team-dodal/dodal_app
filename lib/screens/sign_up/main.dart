import 'package:dodal_app/screens/sign_up/agreement_screen.dart';
import 'package:dodal_app/screens/sign_up/input_form_screen.dart';
import 'package:dodal_app/screens/sign_up/tag_select_screen.dart';
import 'package:dodal_app/layout/create_screen_layout.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentIndex = 0;
  int steps = 3;

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
        ),
      ],
    );
  }
}
