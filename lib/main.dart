import 'dart:ui';

import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/providers/category_list_bloc.dart';
import 'package:dodal_app/providers/custom_feed_list_bloc.dart';
import 'package:dodal_app/providers/feed_list_bloc.dart';
import 'package:dodal_app/providers/my_challenge_list_bloc.dart';
import 'package:dodal_app/providers/sign_in_bloc.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/providers/user_room_feed_info_bloc.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/theme/theme_data.dart';
import 'package:dodal_app/utilities/fcm_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'package:intl/date_symbol_data_local.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  String fcmToken = await fcmSetting();
  Kakao.KakaoSdk.init(
    nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
    javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_APP_KEY'),
  );
  await initializeDateFormatting();

  runApp(App(fcmToken: fcmToken));
}

class App extends StatefulWidget {
  const App({super.key, required this.fcmToken});

  final String fcmToken;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  _goSignInPage() {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => BlocProvider(
          create: (context) => SignInBloc(const FlutterSecureStorage()),
          child: const SignInScreen(),
        ),
      ),
      (route) => false,
    );
  }

  _goMainPage() {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CustomFeedListBloc(
                context.read<UserBloc>().state.result!.categoryList,
              ),
            ),
            BlocProvider(create: (context) => FeedListBloc()),
            BlocProvider(create: (context) => MyChallengeListBloc()),
            BlocProvider(create: (context) => UserRoomFeedInfoBloc()),
          ],
          child: const MainRoute(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc(
            widget.fcmToken,
            const FlutterSecureStorage(),
          ),
        ),
        BlocProvider(create: (context) => CategoryListBloc()),
      ],
      child: MaterialApp(
        title: '도달',
        theme: lightTheme,
        navigatorKey: navigatorKey,
        scrollBehavior: CustomScrollBehavior(),
        home: BlocListener<UserBloc, UserBlocState>(
          listener: (context, state) {
            if (state.status == CommonStatus.error) {
              _goSignInPage();
            }
            if (state.status == CommonStatus.loaded) {
              if (state.result == null) {
                _goSignInPage();
              } else {
                _goMainPage();
              }
            }
          },
          child: const Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          ),
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
