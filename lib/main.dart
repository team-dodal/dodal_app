import 'package:dodal_app/screens/home_screen.dart';
import 'package:dodal_app/services/kakao_auth.dart';
import 'package:flutter/material.dart';
import 'package:dodal_app/theme/theme_data.dart';

void main() {
  KakaoAuthService.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const HomeScreen(),
    );
  }
}
