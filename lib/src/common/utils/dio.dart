import 'package:dio/dio.dart';
import 'package:dodal_app/src/app.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

Dio dio([String url = '']) {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Dio dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get('BASE_URL') + url,
      receiveTimeout: const Duration(seconds: 3),
      sendTimeout: const Duration(seconds: 3),
      connectTimeout: const Duration(seconds: 3),
    ),
  );

  dio.interceptors.addAll([
    // DioCacheInterceptor(options: cacheOptions),
    InterceptorsWrapper(
      onRequest: (
        RequestOptions options,
        RequestInterceptorHandler handler,
      ) async {
        final accessToken = await secureStorage.read(key: 'accessToken');
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        return handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        // 엑세스 토큰이 만료되었을때
        if (e.response?.statusCode == 401) {
          try {
            final newAccessToken = await requestNewAccessToken();
            await secureStorage.write(
              key: 'accessToken',
              value: newAccessToken,
            );
            e.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            FormData requestData = createRequestData(e);
            final clonedRequest = await createCloneRequest(dio, e, requestData);
            return handler.resolve(clonedRequest);
          } catch (error) {
            return handler.reject(e);
          }
        }
        return handler.next(e);
      },
    ),
  ]);

  return dio;
}

Future<String> requestNewAccessToken() async {
  Dio service = await refreshDio();
  final res = await service.post('/api/v1/users/access-token');
  return res.data['result']['access_token'];
}

FormData createRequestData(DioException e) {
  FormData requestData = FormData();
  if (e.requestOptions.data is FormData) {
    requestData.fields.addAll(e.requestOptions.data.fields);

    for (final entry in e.requestOptions.data.files) {
      requestData.files.add(MapEntry(
        entry.key,
        MultipartFile.fromBytes(entry.value, filename: entry.key),
      ));
    }
  } else {
    requestData = e.requestOptions.data;
  }

  return requestData;
}

Future<Response> createCloneRequest(
  Dio dio,
  DioException e,
  dynamic requestData,
) async {
  RequestOptions options = e.requestOptions;
  return await dio.request(
    options.path,
    options: Options(method: options.method, headers: options.headers),
    data: requestData,
    queryParameters: options.queryParameters,
  );
}

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
        await showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) => const SystemDialog(
            subTitle: '세션이 만료되었습니다. 다시 로그인 해주세요.',
          ),
        );
        navigatorKey.currentContext!.go('/sign-in');
        await secureStorage.deleteAll();
      }
      return handler.next(e);
    },
  ));

  return dio;
}
