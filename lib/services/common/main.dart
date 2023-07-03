import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Dio> dio() async {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final accessToken = await secureStorage.read(key: 'accessToken');
  final refreshToken = await secureStorage.read(key: 'refreshToken');

  Dio dio = Dio(BaseOptions(
    baseUrl: dotenv.get('BASE_URL'),
  ));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        final accessToken = secureStorage.read(key: 'accessToken');
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        if (e.response?.statusCode == 401) {
          print(accessToken);
          print(refreshToken);
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}
