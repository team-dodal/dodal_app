import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dodal_app/src/common/model/challenge_model.dart';
import 'package:dodal_app/src/common/model/challenge_notice_model.dart';
import 'package:dodal_app/src/common/model/challenge_rank_model.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/repositories/common/error_dialog.dart';
import 'package:dodal_app/src/common/repositories/common/main.dart';
import 'package:dodal_app/src/common/repositories/presigned_url_repository.dart';

class ChallengeRepository {
  static final service = dio('/api/v1/challenge');

  static Future<void> createChallenge({
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
    final data = {
      'title': title,
      'content': content,
      'tag_value': tagValue,
      'recruit_cnt': recruitCnt,
      'cert_cnt': certCnt,
      'cert_content': certContent,
    };

    if (thumbnailImg != null) {
      data['thumbnail_img_url'] =
          await PresignedUrlRepository.create(file: thumbnailImg);
    }
    if (certCorrectImg != null) {
      data['cert_correct_img_url'] =
          await PresignedUrlRepository.create(file: certCorrectImg);
    }
    if (certWrongImg != null) {
      data['cert_wrong_img_url'] =
          await PresignedUrlRepository.create(file: certWrongImg);
    }

    await service.post('/room', data: data);
  }

  static Future<void> updateChallenge({
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
        data[key] = await PresignedUrlRepository.create(file: data[key]);
      }
    }
    service.patch('/room/$id', data: data);
  }

  static Future<List<Challenge>> getChallenges({
    required int conditionCode,
    required int page,
    required int pageSize,
  }) async {
    Map<String, dynamic> queries = {
      'condition': conditionCode,
      'page': page,
      'page_size': pageSize,
    };
    final res = await service.get('/rooms', queryParameters: queries);
    List<dynamic> contents = res.data['result']['content'];
    List<Challenge> result =
        contents.map((item) => Challenge.fromJson(item)).toList();
    return result;
  }

  static Future<List<Challenge>> getChallengesByCategory({
    String? categoryValue,
    String? tagValue,
    required int conditionCode,
    required List<int> certCntList,
    required int page,
    required int pageSize,
  }) async {
    String url = '/rooms/category?';
    if (categoryValue != null) url += 'category_value=$categoryValue&';
    if (tagValue != null) url += 'tag_value=$tagValue&';
    url += 'condition_code=$conditionCode&page=$page&page_size=$pageSize';
    for (final certCnt in certCntList) {
      url += '&cert_cnt_list=$certCnt';
    }
    final res = await service.get(url);
    List<dynamic> contents = res.data['result']['content'];
    List<Challenge> result =
        contents.map((item) => Challenge.fromJson(item)).toList();
    return result;
  }

  static Future<ChallengeDetail> getChallengeOne(
      {required int challengeId}) async {
    final res = await service.get('/rooms/$challengeId');
    return ChallengeDetail.fromJson(res.data['result']);
  }

  static Future<List<Challenge>> getBookmarkList() async {
    final res = await service.get('/room/bookmarks');
    List<Challenge> result = (res.data['result'] as List)
        .map((item) => Challenge.fromJson(item))
        .toList();
    return result;
  }

  static Future<bool> bookmark(
      {required int roomId, required bool value}) async {
    if (value) {
      await service.post('/room/$roomId/bookmark');
      return true;
    } else {
      await service.delete('/room/$roomId/bookmark');
      return false;
    }
  }

  static Future<void> join({required int challengeId}) async {
    await service.post('/rooms/$challengeId/join');
  }

  static Future<void> out({required int challengeId}) async {
    await service.delete('/rooms/$challengeId/join');
  }

  static Future<void> createNotice({
    required int roomId,
    required String title,
    required String content,
  }) async {
    await service.post(
      '/room/$roomId/noti',
      data: {"title": title, "content": content},
    );
  }

  static Future<List<ChallengeNotice>?> getNoticeList(
      {required int roomId}) async {
    final res = await service.get('/room/$roomId/noti');
    final List<dynamic> result = res.data['result'];
    return result.map((notice) => ChallengeNotice.fromJson(notice)).toList();
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

  static Future<void> createFeed({
    required int challengeId,
    required String content,
    required File image,
  }) async {
    final data = {
      "content": content,
      'certification_img_url': await PresignedUrlRepository.create(file: image)
    };
    await service.post('/room/$challengeId/certification', data: data);
  }

  static Future<List<ChallengeRank>> getRanks({
    required int id,
    required int code,
  }) async {
    final res = await service.get('/room/$id/rank?code=$code');
    List<dynamic> result = res.data['result'];
    return result.map((e) => ChallengeRank.fromJson(e)).toList();
  }

  static Future<List<Challenge>> getChallengesByKeyword({
    required String word,
    required int conditionCode,
    required List<int> certCntList,
    required int page,
    required int pageSize,
  }) async {
    String url = '/room/search?';
    url +=
        'word=$word&condition_code=$conditionCode&page=$page&page_size=$pageSize';

    for (final certCnt in certCntList) {
      url += '&cert_cnt_list=$certCnt';
    }
    final res = await service.get(url);

    List<dynamic> contents = res.data['result']['content'];
    List<Challenge> result =
        contents.map((item) => Challenge.fromJson(item)).toList();
    return result;
  }
}
