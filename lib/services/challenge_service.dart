import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'common/main.dart';

class ChallengeService {
  static createChallenge({
    required String title,
    required String content,
    required String tagValue,
    required int recruitCnt,
    required int certCnt,
    required String certContent,
    File? thumbnailImg,
    required File? certCorrectImg,
    required File? certWrongImg,
  }) async {
    try {
      final service = dio();
      service.options.contentType = 'multipart/form-data';
      FormData formData = FormData.fromMap({
        'title': title,
        'content': content,
        'tag_value': tagValue,
        'recruit_cnt': recruitCnt,
        'cert_cnt': certCnt,
        'cert_content': certContent,
        'cert_correct_img': await MultipartFile.fromFile(certCorrectImg!.path),
        'cert_wrong_img': await MultipartFile.fromFile(certWrongImg!.path)
      });

      if (thumbnailImg != null) {
        formData.files.add(MapEntry(
          'thumbnail_img',
          await MultipartFile.fromFile(thumbnailImg.path),
        ));
      }

      final res = await service.post('/api/v1/challenge/room', data: formData);
      return res.data['result'];
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static Future<List<Challenge>?> getChallengesByCategory({
    required String categoryValue,
    required String tagValue,
    required int conditionCode,
    required List<int> certCntList,
    required int page,
    required int pageSize,
  }) async {
    try {
      final service = dio();
      String requestUrl = '/api/v1/challenge/rooms/category?';
      requestUrl +=
          'category_value=$categoryValue&tag_value=$tagValue&condition_code=$conditionCode&';
      for (final certCnt in certCntList) {
        requestUrl += 'cert_cnt_list=$certCnt&';
      }
      requestUrl += 'page=$page&page_size=$pageSize';
      final res = await service.get(requestUrl);
      List<dynamic> contents = res.data['result']['content'];
      List<Challenge> result =
          contents.map((item) => Challenge.fromJson(item)).toList();
      return result;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }
}
