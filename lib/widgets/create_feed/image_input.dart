import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => ImageInputState();
}

class ImageInputState extends State<ImageInput> {
  File? _image;

  void _pickImage(ImageSource type) async {
    final imagePicker = ImagePicker();
    late XFile? pickedImage;

    try {
      pickedImage = await imagePicker.pickImage(source: type);
      if (pickedImage == null) return;
      log('$pickedImage');
      setState(() {
        _image = File(pickedImage!.path);
      });
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

  _showBottomSheet() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('직접 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                title: const Text('엘범에서 사진 선택'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBottomSheet,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: const BoxDecoration(color: Colors.grey),
            child: Builder(
              builder: (context) {
                if (_image != null) {
                  return Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }
                return const Icon(
                  Icons.add,
                  size: 100,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
