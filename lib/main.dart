import 'package:dodal_app/model/my_info_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/services/user_service.dart';
import 'package:dodal_app/theme/theme_data.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Fcm.init();
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
      final user = await UserService.user();
      if (!mounted) return;
      context.read<MyInfoCubit>().set(User.formJson(user));
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
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MyInfoCubit()),
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
