import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/common/error_dialog.dart';
import 'package:dodal_app/services/common/main.dart';
import 'package:dodal_app/services/common/presigned_s3.dart';

class ChallengeService {
  static final service = dio('/api/v1/challenge');

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
      final data = {
        'title': title,
        'content': content,
        'tag_value': tagValue,
        'recruit_cnt': recruitCnt,
        'cert_cnt': certCnt,
        'cert_content': certContent,
      };

      if (thumbnailImg != null) {
        String key = 'thumbnail_img_url';
        String fileName = 'roomId_${key}_date_${DateTime.now()}';
        String s3Url = await PresignedS3.upload(
          uploadUrl: await PresignedS3.getUrl(fileName: fileName),
          file: thumbnailImg,
          fileName: fileName,
        );
        data[key] = s3Url;
      }
      if (certCorrectImg != null) {
        String key = 'cert_correct_img_url';
        String fileName = 'roomId_${key}_date_${DateTime.now()}';
        String s3Url = await PresignedS3.upload(
          uploadUrl: await PresignedS3.getUrl(fileName: fileName),
          file: certCorrectImg,
          fileName: fileName,
        );
        data[key] = s3Url;
      }
      if (certWrongImg != null) {
        String key = 'cert_wrong_img_url';
        String fileName = 'roomId_${key}_date_${DateTime.now()}';
        String s3Url = await PresignedS3.upload(
          uploadUrl: await PresignedS3.getUrl(fileName: fileName),
          file: certWrongImg,
          fileName: fileName,
        );
        data[key] = s3Url;
      }

      final res = await service.post('/room', data: data);
      return res.data['result'];
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static updateChallenge({
    required int id,
    required String title,
    required String content,
    required String tagValue,
    required int recruitCnt,
    required int certCnt,
    required String certContent,
    dynamic thumbnailImg,
    dynamic certCorrectImg,
    dynamic certWrongImg,
  }) async {
    try {
      final data = {
        "tag_value": tagValue,
        "title": title,
        "content": content,
        "recruit_cnt": recruitCnt,
        "cert_cnt": certCnt,
        "cert_content": certContent,
        'thumbnail_img_url': thumbnailImg,
        'cert_correct_img_url': certCorrectImg,
        'cert_wrong_img_url': certWrongImg,
      };
      for (var key in [
        'thumbnail_img_url',
        'cert_correct_img_url',
        'cert_wrong_img_url'
      ]) {
        if (data[key].runtimeType.toString() == '_File') {
          String fileName = 'roomId_${id}_${key}_date_${DateTime.now()}';
          String s3Url = await PresignedS3.upload(
            uploadUrl: await PresignedS3.getUrl(fileName: fileName),
            file: thumbnailImg,
            fileName: fileName,
          );
          data[key] = s3Url;
        }
      }

      service.patch('/room/$id', data: data);
      return true;
    } on DioException catch (err) {
      ResponseErrorDialog(err);
      return null;
    }
  }

  static Future<List<Challenge>?> getChallenges({
    required int conditionCode,
    required int page,
    required int pageSize,
  }) async {
    try {
      String requestUrl = '/rooms?';
      requestUrl += 'condition=$conditionCode&';
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

  static Future<List<Challenge>?> getChallengesByCategory({
    String? categoryValue,
    String? tagValue,
    required int conditionCode,
    required List<int> certCntList,
    required int page,
    required int pageSize,
  }) async {
    try {
      String requestUrl = '/rooms/category?';
      if (categoryValue != null) {
        requestUrl += 'category_value=$categoryValue&';
      }
      if (tagValue != null) {
        requestUrl += 'tag_value=$tagValue&';
      }
      requestUrl += 'condition_code=$conditionCode&';
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
      final res = await service.get('/rooms/$challengeId');
      return OneChallengeResponse.fromJson(res.data['result']);
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<List<Challenge>?> getBookmarkList() async {
    try {
      final res = await service.get('/room/bookmarks');

      List<Challenge> result = (res.data['result'] as List)
          .map((item) => Challenge.fromJson(item))
          .toList();
      return result;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static bookmark({required int roomId, required bool value}) async {
    try {
      if (value) {
        await service.post('/room/$roomId/bookmark');
        return true;
      } else {
        await service.delete('/room/$roomId/bookmark');
        return false;
      }
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static join({required int challengeId}) async {
    try {
      await service.post('/rooms/$challengeId/join');
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }

  static out({required int challengeId}) async {
    try {
      await service.delete('/rooms/$challengeId/join');
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
      await service.post(
        '/room/$roomId/noti',
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
      final res = await service.get('/room/$roomId/noti');
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
      await service.patch(
        '/rooms/$roomId/noti/$notiId',
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
      await service.delete('/rooms/$roomId/noti/$notiId');
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
      final data = {"content": content};

      String fileName =
          'challengeId_${challengeId}_feedImage_date_${DateTime.now()}';
      String s3Url = await PresignedS3.upload(
        uploadUrl: await PresignedS3.getUrl(fileName: fileName),
        file: image,
        fileName: fileName,
      );
      data['certification_img_url'] = s3Url;

      await service.post(
        '/room/$challengeId/certification',
        data: data,
      );
      return true;
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return false;
    }
  }

  static Future<List<ChallengeRankResponse>?> getRanks({
    required int id,
    required int code,
  }) async {
    try {
      final res = await service.get('/room/$id/rank?code=$code');
      List<dynamic> result = res.data['result'];

      return result.map((e) => ChallengeRankResponse.fromJson(e)).toList();
    } on DioException catch (error) {
      ResponseErrorDialog(error);
      return null;
    }
  }

  static Future<List<Challenge>?> getChallengesByKeyword({
    required String word,
    required int conditionCode,
    required List<int> certCntList,
    required int page,
    required int pageSize,
  }) async {
    try {
      String requestUrl = '/room/search?';
      requestUrl += 'word=$word&';
      requestUrl += 'condition_code=$conditionCode&';
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
