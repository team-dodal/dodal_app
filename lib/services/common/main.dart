import 'package:dio/dio.dart';
import 'package:dodal_app/main.dart';
import 'package:dodal_app/screens/sign_in/main.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';
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
          Dio refreshDio = Dio(BaseOptions(baseUrl: dotenv.get('BASE_URL')));
          refreshDio.interceptors.clear();
          refreshDio.interceptors.add(InterceptorsWrapper(
            onRequest: (options, handler) async {
              final refreshToken =
                  await secureStorage.read(key: 'refreshToken');
              options.headers['Authorization'] = 'Bearer $refreshToken';
              return handler.next(options);
            },
            onError: (e, handler) async {
              final refreshToken =
                  await secureStorage.read(key: 'refreshToken');

              if (e.response!.statusCode == 401) {
                navigatorKey.currentState!.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => const SignInScreen()),
                  (route) => false,
                );

                if (refreshToken != null) {
                  showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) {
                      return SystemDialog(
                        title: '알림',
                        subTitle: '다시 로그인 해주세요.',
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          )
                        ],
                      );
                    },
                  );
                }
                secureStorage.deleteAll();
                return handler.next(e);
              }
            },
          ));

          try {
            final res = await refreshDio.post('/api/v1/users/access-token');
            final newAccessToken = res.data['result'];
            await secureStorage.write(
              key: 'accessToken',
              value: newAccessToken,
            );
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
