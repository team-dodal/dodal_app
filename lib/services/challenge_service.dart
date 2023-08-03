import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'common/main.dart';

class Challenge {
  final int id;
  final int adminId;
  final String adminNickname;
  final String? adminProfile;
  final String title;
  final int certCnt;
  final String? thumbnailImg;
  final int recruitCnt;
  final int userCnt;
  final int bookmarkCnt;
  final bool bookmarkStatus;
  final DateTime? registeredAt;
  final String categoryName;
  final String categoryValue;
  final Tag tag;

  Challenge.fromJson(Map<String, dynamic> data)
      : id = data['challenge_room_id'],
        adminId = data['user_id'],
        adminNickname = data['nickname'],
        adminProfile = data['profile_url'],
        title = data['title'],
        certCnt = data['cert_cnt'],
        thumbnailImg = data['thumbnail_img_url'],
        recruitCnt = data['recruit_cnt'],
        userCnt = data['user_cnt'],
        bookmarkCnt = data['bookmark_cnt'],
        bookmarkStatus = data['bookmark_yn'] == 'Y' ? true : false,
        registeredAt = data['registered_at'] != null
            ? DateTime.parse(data['registered_at'])
            : null,
        categoryName = data['category_name'],
        categoryValue = data['category_value'],
        tag = Tag(name: data['tag_name'], value: data['tag_value']);
}

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
  }) async {
    try {
      final service = dio();
      String requestUrl = '/api/v1/challenge/rooms/category?';
      requestUrl +=
          'category_value=$categoryValue&tag_value=$tagValue&condition_code=$conditionCode&';
      for (final certCnt in certCntList) {
        requestUrl += 'cert_cnt_list=$certCnt&';
      }
      requestUrl += 'page=$page&page_size=20';
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
