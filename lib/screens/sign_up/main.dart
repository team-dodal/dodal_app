import 'dart:io';

import 'package:dodal_app/screens/sign_up/agreement_screen.dart';
import 'package:dodal_app/screens/sign_up/input_form_screen.dart';
import 'package:dodal_app/screens/sign_up/tag_select_screen.dart';
import 'package:dodal_app/screens/welcome/main.dart';
import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:dodal_app/widgets/common/create_screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.socialType,
    required this.socialId,
    required this.email,
  });

  final SocialType socialType;
  final String socialId;
  final String email;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  int _currentIndex = 0;
  int steps = 3;
  String nickname = '';
  String content = '';
  File? image;
  List<String> category = [];

  _submit() async {
    SignUpResponse? res = await UserService.signUp(
      widget.socialType,
      widget.socialId,
      widget.email,
      nickname,
      image,
      content,
      category,
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
          nextStep: (data) {
            nickname = data['nickname'];
            content = data['content'];
            image = data['image'];
            setState(() {
              _currentIndex += 1;
            });
          },
          nickname: nickname,
          content: content,
          image: image,
        ),
        TagSelectScreen(
          steps: steps,
          step: _currentIndex + 1,
          nextStep: (data) {
            category = data['category'];
            _submit();
          },
        ),
      ],
    );
  }
}
