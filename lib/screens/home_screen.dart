import 'dart:io';
import 'package:flutter/material.dart';
import '../utilities/social_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  _socialSignIn(BuildContext context, SocialType type) async {
    final Object? data;
    switch (type) {
      case SocialType.GOOGLE:
        data = await GoogleAuthService.signIn();
      case SocialType.KAKAO:
        data = await KakaoAuthService.signIn();
      case SocialType.APPLE:
        data = await AppleAuthService.signIn();
      default:
        return;
    }
    if (data == null) return;

    if (context.mounted) {
      _showDialog(context, '$data');
    }
  }

  _showDialog(BuildContext context, String data) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(data),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도달'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _socialSignIn(context, SocialType.KAKAO);
              },
              child: const Text('Kakao SignIn'),
            ),
            ElevatedButton(
              onPressed: () {
                _socialSignIn(context, SocialType.GOOGLE);
              },
              child: const Text('Google SignIn'),
            ),
            if (Platform.isIOS)
              ElevatedButton(
                onPressed: () {
                  _socialSignIn(context, SocialType.APPLE);
                },
                child: const Text('Apple SignIn'),
              ),
          ],
        ),
      ),
    );
  }
}
