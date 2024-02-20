import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PresignedS3 {
  static getUrl({required String fileName}) async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/img/url/$fileName');
      return res.data['result'];
    } catch (error) {
      rethrow;
    }
  }

  static upload({
    required String uploadUrl,
    required File file,
    required String fileName,
  }) async {
    try {
      String s3Url = dotenv.get('S3_URL');
      final service = Dio();
      await service.put(
        uploadUrl,
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
      rethrow;
    }
  }

  static Future<String> imageUpload({
    required int userId,
    required File file,
  }) async {
    final service = dio();
    String fileName = 'user_${userId}_date_${DateTime.now()}';
    String s3Url = dotenv.get('S3_URL');
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
