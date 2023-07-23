import 'package:dio/dio.dart';
import 'package:dodal_app/main.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';

class ResponseErrorDialog {
  String message = '에러가 발생하였습니다.';
  ResponseErrorDialog(DioException error) {
    if (error.response!.statusCode == 401) {
      message = '다시 로그인해주세요.';
    }

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return SystemDialog(subTitle: message);
      },
    );
  }
}
