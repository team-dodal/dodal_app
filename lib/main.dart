import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/theme/theme_data.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Fcm.init();
  await initializeDateFormatting();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '도달',
      theme: lightTheme,
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        future: UserService.user(),
        builder: (ctx, snapshot) {
          print(snapshot);
          final isLoading = snapshot.connectionState == ConnectionState.waiting;
          if (isLoading) return const Placeholder();
          return const Placeholder();
          // FlutterNativeSplash.remove();
          // if (snapshot.data!) {
          //   return const MainRoute();
          // } else {
          //   return const SignInScreen();
          // }
        },
      ),
    );
  }
}
