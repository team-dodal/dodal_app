import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> captureCreateImage(GlobalKey frameKey) async {
  try {
    Uint8List? uint8List = await getUint8List(frameKey);
    Directory directory = await getTemporaryDirectory();
    File file = File('${directory.path}/${DateTime.now()}.png');
    await file.writeAsBytes(uint8List!);
    return file;
  } catch (e) {
    print('Error capturing and saving image: $e');
    return null;
  }
}

Future<Uint8List?> getUint8List(GlobalKey frameKey) async {
  RenderRepaintBoundary boundary =
      frameKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 5.0);
  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
  Uint8List uint8List = byteData!.buffer.asUint8List();

  return uint8List;
}
