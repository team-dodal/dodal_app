import 'package:dodal_app/src/app.dart';
import 'package:dodal_app/src/common/bloc/category_list_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/common/utils/fcm_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  await dotenv.load(fileName: ".env");
  String fcmToken = await fcmSetting();
  Kakao.KakaoSdk.init(
    nativeAppKey: dotenv.get('KAKAO_NATIVE_APP_KEY'),
    javaScriptAppKey: dotenv.get('KAKAO_JAVASCRIPT_APP_KEY'),
  );
  await initializeDateFormatting();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(Main(fcmToken: fcmToken));
}

class Main extends StatelessWidget {
  const Main({super.key, required this.fcmToken});

  final String fcmToken;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            fcmToken,
            const FlutterSecureStorage(),
          ),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => CategoryListBloc(),
          lazy: false,
        ),
      ],
      child: const App(),
    );
  }
}
