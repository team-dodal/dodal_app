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
      print(error);
      return null;
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
            Headers.contentTypeHeader: 'image/jpg'
          },
        ),
      );
      return '$s3Url/$fileName';
    } catch (error) {
      print(error);
      return null;
    }
  }
}
