import 'package:dio/dio.dart';
import 'package:dodal_app/services/common/refresh.dart';
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
        // 엑세스 토큰이 만료되었을때
        if (e.response?.statusCode == 401) {
          try {
            var service = await refreshDio();
            final res = await service.post('/api/v1/users/access-token');
            final newAccessToken = res.data['result']['access_token'];
            await secureStorage.write(
              key: 'accessToken',
              value: newAccessToken,
            );
            e.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            late dynamic requestData;
            if (e.requestOptions.data is FormData) {
              FormData requestData = FormData();
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
            final clonedRequest = await dio.request(
              e.requestOptions.path,
              options: Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers,
              ),
              data: requestData,
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
