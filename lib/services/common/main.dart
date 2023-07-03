import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Dio> dio() async {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Dio dio = Dio(BaseOptions(
    baseUrl: dotenv.get('BASE_URL'),
  ));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        final accessToken = await secureStorage.read(key: 'accessToken');
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          Dio refreshDio = Dio(BaseOptions(
            baseUrl: dotenv.get('BASE_URL'),
          ));
          refreshDio.interceptors.clear();
          refreshDio.interceptors.add(InterceptorsWrapper(
            onRequest: (options, handler) async {
              final refreshToken =
                  await secureStorage.read(key: 'refreshToken');
              options.headers['Authorization'] = 'Bearer $refreshToken';
              return handler.next(options);
            },
            onError: (e, handler) async {
              if (e.response!.statusCode == 401) {
                secureStorage.deleteAll();
                handler.reject(e);
              }
            },
          ));

          try {
            final res = await refreshDio.post('/api/v1/users/access-token');
            final newAccessToken = res.data['result'];
            await secureStorage.write(
                key: 'accessToken', value: newAccessToken);
            e.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';

            final clonedRequest = await dio.request(
              e.requestOptions.path,
              options: Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers,
              ),
              data: e.requestOptions.data,
              queryParameters: e.requestOptions.queryParameters,
            );
            return handler.resolve(clonedRequest);
          } catch (err) {}
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}
