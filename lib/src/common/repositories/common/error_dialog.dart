import 'package:dio/dio.dart';
import 'package:dodal_app/main.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';

class ResponseErrorDialog {
  late String message;
  ResponseErrorDialog(DioException error, [String? message]) {
    if (message != null) {
      this.message = message;
    } else {
      this.message = '에러가 발생하였습니다.';
    }

    if (error.response!.statusCode == 401) {
      this.message = '다시 로그인해주세요.';
    }

    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return SystemDialog(subTitle: this.message);
      },
    );
  }
}
