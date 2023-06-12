import 'dart:io';

import 'package:dodal_app/services/google_auth.dart';
import 'package:dodal_app/services/kakao_auth.dart';
import 'package:flutter/material.dart';

import '../services/apple_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _userInfo;

  _kakaoSignIn() async {
    final info = await KakaoAuthService.signIn();
    setState(() {
      _userInfo = info;
    });
  }

  _googleSignIn() async {
    final info = await GoogleAuthService.signIn();
    setState(() {
      _userInfo = info;
    });
  }

  _appleSignIn() async {
    final info = await AppleAuthService.signIn();
    setState(() {
      _userInfo = info;
    });
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
            if (_userInfo != null) Container(child: Text('$_userInfo')),
            ElevatedButton(
              onPressed: _kakaoSignIn,
              child: const Text('Kakao SignIn'),
            ),
            ElevatedButton(
              onPressed: _googleSignIn,
              child: const Text('Google SignIn'),
            ),
            if (Platform.isIOS)
              ElevatedButton(
                onPressed: _appleSignIn,
                child: const Text('Apple SignIn'),
              ),
          ],
        ),
      ),
    );
  }
}
