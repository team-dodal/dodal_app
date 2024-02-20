import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();
String s3Url = dotenv.get('S3_URL');

class PresignedS3 {
  static Dio service = Dio();

  static Future<String> imageUpload({required File file}) async {
    String fileName = uuid.v4();
    String presignedUrl;
    try {
      final res = await service.get('/api/v1/img/url/$fileName');
      presignedUrl = res.data['result'];
    } catch (error) {
      throw Exception('Failed to get presigned url');
    }

    try {
      await service.put(
        presignedUrl,
        data: await file.readAsBytes(),
        options: Options(
          headers: {
            Headers.contentLengthHeader: file.length(),
            Headers.contentTypeHeader: 'image/jpeg',
          },
        ),
      );
      return '$s3Url/$fileName';
    } catch (error) {
      throw Exception('Failed to upload image');
    }
  }
}
