import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/src/common/utils/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
String s3Url = dotenv.get('S3_URL');

class PresignedUrlRepository {
  static Future<String> create({required File file}) async {
    Dio service = dio();
    String fileName = uuid.v4();
    try {
      final res = await service.get('/api/v1/img/url/$fileName');
      await _upload(res.data['result'], file);
      return '$s3Url/$fileName';
    } catch (error) {
      throw Exception('Failed to get presigned url');
    }
  }

  static Future<String> _upload(String url, File file) async {
    Dio service = Dio();
    try {
      int len = await file.length();
      await service.put(
        url,
        data: file.openRead(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: len,
            'Content-Type': 'image/jpeg',
          },
        ),
      );
      return url;
    } catch (error) {
      throw Exception('Failed to upload image');
    }
  }
}
