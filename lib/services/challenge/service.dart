import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';

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
      });

      if (certCorrectImg != null) {
        formData.files.add(MapEntry(
          'cert_correct_img',
          await MultipartFile.fromFile(certCorrectImg.path),
        ));
      }
      if (certWrongImg != null) {
        formData.files.add(MapEntry(
          'cert_wrong_img',
          await MultipartFile.fromFile(certWrongImg.path),
        ));
      }

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

  static Future<OneChallengeResponse?> getChallengeOne(
      {required int challengeId}) async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/challenge/rooms/$challengeId');
      return OneChallengeResponse.fromJson(res.data['result']);
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static bookmark({required int roomId, required bool value}) async {
    try {
      final service = dio();
      if (value) {
        await service.post('/api/v1/challenge/room/$roomId/bookmark');
        return true;
      } else {
        await service.delete('/api/v1/challenge/room/$roomId/bookmark');
        return false;
      }
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static join({required int challengeId}) async {
    try {
      final service = dio();
      await service.post('/api/v1/challenge/rooms/$challengeId/join');
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }

  static out({required int challengeId}) async {
    try {
      final service = dio();
      await service.delete('/api/v1/challenge/rooms/$challengeId/join');
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }

  static createNotice({
    required int roomId,
    required String title,
    required String content,
  }) async {
    try {
      final service = dio();
      await service.post(
        '/api/v1/challenge/room/$roomId/noti',
        data: {"title": title, "content": content},
      );
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }

  static Future<List<ChallengeRoomNoticeResponse>?> getNoticeList(
      {required int roomId}) async {
    try {
      final service = dio();
      final res = await service.get('/api/v1/challenge/room/$roomId/noti');
      final List<dynamic> result = res.data['result'];
      return result
          .map((notice) => ChallengeRoomNoticeResponse.fromJson(notice))
          .toList();
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static updateNotice({
    required int roomId,
    required int notiId,
    required String title,
    required String content,
  }) async {
    try {
      final service = dio();
      await service.patch(
        '/api/v1/challenge/rooms/$roomId/noti/$notiId',
        data: {title: title, content: content},
      );
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }

  static deleteNotice({required int roomId, required int notiId}) async {
    try {
      final service = dio();
      await service.delete('/api/v1/challenge/rooms/$roomId/noti/$notiId');
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }

  static Future<bool> createFeed({
    required int challengeId,
    required String content,
    required File image,
  }) async {
    try {
      final service = dio();
      service.options.contentType = 'multipart/form-data';
      FormData formData = FormData.fromMap({'content': content});
      formData.files.add(MapEntry(
        'certification_img',
        await MultipartFile.fromFile(image.path),
      ));

      await service.post(
        '/api/v1/challenge/room/$challengeId/certification',
        data: formData,
      );
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }
}
