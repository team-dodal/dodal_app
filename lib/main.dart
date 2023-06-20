import 'package:dodal_app/screens/main_route/main.dart';
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
  print(Fcm.fcmToken);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() async {
    await Fcm.foregroundHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const MainRoute(),
    );
  }
}
