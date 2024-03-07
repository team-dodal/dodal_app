import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

const int ONE_MB = 1000000;

Future<File> imageCompress(File file) async {
  if (await file.length() < ONE_MB) return file;
  XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    '${file.path}_compress.jpeg',
    quality: 50,
    format: CompressFormat.jpeg,
  );
  if (result == null) {
    throw '이미지 압축에 실패했습니다. 다른 이미지를 선택해주세요.';
  }
  if (await result.length() > ONE_MB) {
    throw '이미지 용량이 너무 큽니다. 다른 이미지를 선택해주세요.';
  }
  return File(result.path);
}
