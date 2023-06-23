import 'package:dodal_app/screens/main.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:flutter/material.dart';
import 'package:dodal_app/theme/theme_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Fcm.init();
  print(Fcm.token);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '도달',
      theme: lightTheme,
      home: const InitRoute(),
    );
  }
}
