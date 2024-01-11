import 'package:dio/dio.dart';
import 'package:dodal_app/services/common/refresh.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Dio dio([String url = '']) {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  print(dotenv.get('BASE_URL') + url);
  Dio dio = Dio(BaseOptions(
    baseUrl: dotenv.get('BASE_URL') + url,
  ));

  dio.interceptors.addAll([
    // DioCacheInterceptor(options: cacheOptions),
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
          final newAccessToken = await requestNewAccessToken();
          if (newAccessToken == null) return;
          await secureStorage.write(key: 'accessToken', value: newAccessToken);
          e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          dynamic requestData = createRequestData(e);
          final clonedRequest = await createCloneRequest(dio, e, requestData);
          return handler.resolve(clonedRequest);
        }
        return handler.next(e);
      },
    ),
  ]);

  return dio;
}

requestNewAccessToken() async {
  try {
    Dio service = await refreshDio();
    final res = await service.post('/api/v1/users/access-token');

    return res.data['result']['access_token'];
  } catch (err) {
    return null;
  }
}

createRequestData(DioException e) {
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

  return requestData;
}

createCloneRequest(Dio dio, DioException e, requestData) async {
  return await dio.request(
    e.requestOptions.path,
    options: Options(
      method: e.requestOptions.method,
      headers: e.requestOptions.headers,
    ),
    data: requestData,
    queryParameters: e.requestOptions.queryParameters,
  );
}
