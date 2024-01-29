import 'package:dodal_app/providers/category_list_bloc.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/theme/theme_data.dart';
import 'package:dodal_app/utilities/fcm_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(widget.fcmToken)),
        BlocProvider(create: (context) => CategoryListBloc()),
      ],
      child: MaterialApp(
        title: '도달',
        theme: lightTheme,
        navigatorKey: navigatorKey,
        home: BlocBuilder<UserBloc, UserBlocState>(
          builder: (context, state) {
            switch (state.status) {
              case UserBlocStatus.init:
              case UserBlocStatus.loading:
                return const Scaffold(
                  body: Center(child: CupertinoActivityIndicator()),
                );
              case UserBlocStatus.error:
                return const SignInScreen();
              case UserBlocStatus.loaded:
                return const MainRoute();
            }
          },
        ),
      ),
    );
  }
}
