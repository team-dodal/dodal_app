import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

String compressedImagePath = '/compressed_image.jpg';

Future<File> imageCompress(File file) async {
  if (await file.length() < 1000000) return file;
  XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    '${file.path}_compress.jpeg',
    quality: 80,
    format: CompressFormat.jpeg,
  );

  int fileSize = await result!.length();
  if (fileSize > 1 * 1024 * 1024) {
    return imageCompress(File(result.path));
  } else {
    return File(result.path);
  }
}
