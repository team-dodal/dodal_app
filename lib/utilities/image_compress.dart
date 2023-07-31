import 'package:flutter_image_compress/flutter_image_compress.dart';

String compressedImagePath = '/compressed_image.jpg';

Future<XFile> testCompressAndGetFile(XFile file) async {
  if (await file.length() < 1000000) return file;
  var result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    '${file.path}_compress.jpeg',
    quality: 80,
    format: CompressFormat.jpeg,
  );

  int fileSize = await result!.length();
  if (fileSize > 1 * 1024 * 1024) {
    return testCompressAndGetFile(XFile(result.path));
  } else {
    return XFile(result.path);
  }
}
