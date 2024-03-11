import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Dio> refreshDio() async {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Dio dio = Dio(BaseOptions(baseUrl: dotenv.get('BASE_URL')));

  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // 엑세스 토큰 대신 리프레시 토큰 넣어 요청
      final refreshToken = await secureStorage.read(key: 'refreshToken');
      options.headers['Authorization'] = 'Bearer $refreshToken';
      return handler.next(options);
    },
    onResponse: (Response response, ResponseInterceptorHandler handler) {
      return handler.next(response);
    },
    onError: (e, handler) async {
      // 리프레쉬 토큰도 만료되었을 때
      if (e.response!.statusCode == 401) {
        secureStorage.deleteAll();
      }
      return handler.next(e);
    },
  ));

  return dio;
}
