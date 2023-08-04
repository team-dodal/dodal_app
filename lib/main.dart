import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/theme/theme_data.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Fcm.setupNotifications();
  await initializeDateFormatting();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isLogin = false;

  checkingLoginStatus() async {
    try {
      User? user = await UserService.user();
      if (user == null) return;
      if (!mounted) return;
      context.read<UserCubit>().set(User(
            id: user.id,
            email: user.email,
            nickname: user.nickname,
            content: user.content,
            profileUrl: user.profileUrl!,
            registerAt: user.registerAt,
            socialType: user.socialType,
            tagList: user.tagList,
          ));
      setState(() {
        _isLogin = true;
      });
    } catch (err) {
      setState(() {
        _isLogin = false;
      });
    }
  }

  @override
  void initState() {
    checkingLoginStatus();
    FirebaseMessaging.onMessage.listen(Fcm.foregroundNotification);
    FirebaseMessaging.onBackgroundMessage(Fcm.backgroundNotification);
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        title: '도달',
        theme: lightTheme,
        navigatorKey: navigatorKey,
        home: _isLogin ? const MainRoute() : const SignInScreen(),
      ),
    );
  }
}
