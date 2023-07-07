import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBottomSheet extends StatelessWidget {
  const ImageBottomSheet({super.key, required this.setImage});

  final Function setImage;

  void _pickImage(ImageSource type, BuildContext context) async {
    final imagePicker = ImagePicker();
    late XFile? pickedImage;

    try {
      pickedImage = await imagePicker.pickImage(source: type);
      if (pickedImage == null) return;
      setImage(File(pickedImage.path));
    } catch (err) {
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Text('이 이미지는 사용할 수 없습니다'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('직접 촬영'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera, context);
            },
          ),
          ListTile(
            title: const Text('엘범에서 사진 선택'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery, context);
            },
          ),
        ],
      ),
    );
  }
}
