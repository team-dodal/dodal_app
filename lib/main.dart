import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/theme/theme_data.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Fcm.setupNotifications();
  Kakao.KakaoSdk.init(
    nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
    javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_APP_KEY'),
  );
  await initializeDateFormatting();

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future<User?> getUser() async => await UserService.user();
  @override
  void initState() {
    super.initState();
    UserService.updateFcmToken(Fcm.token);
    FlutterNativeSplash.remove();
    FirebaseMessaging.onMessage.listen(Fcm.foregroundNotification);
    FirebaseMessaging.onBackgroundMessage(Fcm.backgroundNotification);
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
        home: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            User? user = snapshot.data;
            if (user != null) {
              context.read<UserCubit>().set(User(
                    id: user.id,
                    email: user.email,
                    nickname: user.nickname,
                    content: user.content,
                    profileUrl: user.profileUrl,
                    registerAt: user.registerAt,
                    socialType: user.socialType,
                    categoryList: user.categoryList,
                    tagList: user.tagList,
                  ));
              return const MainRoute();
            } else {
              return const SignInScreen();
            }
          },
        ),
      ),
    );
  }
}
