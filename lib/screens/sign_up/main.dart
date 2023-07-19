import 'dart:io';

import 'package:animations/animations.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/sign_up/agreement_screen.dart';
import 'package:dodal_app/screens/sign_up/input_form_screen.dart';
import 'package:dodal_app/screens/sign_up/tag_select_screen.dart';
import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/utilities/social_auth.dart';
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
  bool _pageDirectionReverse = false;

  Future<bool> _handlePopState() async {
    _pageDirectionReverse = true;
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex -= 1;
      });
      return false;
    }
    return true;
  }

  _submit() async {
    SignUpResponse res = await UserService.signUp(
      widget.socialType,
      widget.socialId,
      widget.email,
      nickname,
      image,
      content,
      category,
    );

    if (res.accessToken != null && res.refreshToken != null) {
      secureStorage.write(key: 'accessToken', value: res.accessToken);
      secureStorage.write(key: 'refreshToken', value: res.refreshToken);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => const MainRoute()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handlePopState,
      child: PageTransitionSwitcher(
        reverse: _pageDirectionReverse,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: [
          AgreementScreen(steps: steps, step: _currentIndex + 1),
          InputFormScreen(
            steps: steps,
            step: _currentIndex + 1,
            nextStep: (data) {
              nickname = data['nickname'];
              content = data['content'];
              image = data['image'];
              setState(() {
                _pageDirectionReverse = false;
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
              _pageDirectionReverse = false;
              category = data['category'];
              _submit();
            },
          ),
        ][_currentIndex],
      ),
    );
  }
}
