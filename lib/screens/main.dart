import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:flutter/material.dart';

class InitRoute extends StatelessWidget {
  const InitRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(builder: (ctx, snapshot) {
      return const SignInScreen();
    });
  }
}
