import 'package:animations/animations.dart';
import 'package:dodal_app/screens/sign_up/Input_form_screen.dart';
import 'package:dodal_app/screens/sign_up/tag_select_screen.dart';
import 'package:dodal_app/utilities/social_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../services/user_service.dart';
import '../main_route/main.dart';

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
  String nickname = '';
  String content = '';
  String image = '';
  List<String> category = [];

  Future<bool> _handlePopState() async {
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
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const MainRoute()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원 가입')),
      body: WillPopScope(
        onWillPop: _handlePopState,
        child: PageTransitionSwitcher(
          child: [
            InputFormScreen(
              step: _currentIndex + 1,
              nextStep: (data) {
                nickname = data['nickname'];
                image = data['image'];
                content = data['content'];
                setState(() {
                  _currentIndex += 1;
                });
              },
            ),
            TagSelectScreen(
              step: _currentIndex + 1,
              nextStep: (data) {
                category = data['category'];
              },
            ),
          ][_currentIndex],
          transitionBuilder: (child, animation, secondaryAnimation) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
