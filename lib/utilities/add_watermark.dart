import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';
import 'dart:io';

addWatermark(File imgFile, {required String text}) async {
  var tempDir = await getTemporaryDirectory();
  DateTime now = DateTime.now();

  // draw image
  Image? image = decodeImage(imgFile.readAsBytesSync());
  // draw text
  drawString(image!, text, font: arial48);
  // create temporary image
  File('${tempDir.path}/$now.png').writeAsBytesSync(encodePng(image));
  // get temporary image
  final watermarkedImg = File('${tempDir.path}/$now.png');
  return watermarkedImg;
}
