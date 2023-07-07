import 'dart:io';

import 'package:flutter/material.dart';

import '../common/image_bottom_sheet.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => ImageInputState();
}

class ImageInputState extends State<ImageInput> {
  File? _image;

  _showBottomSheet() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return ImageBottomSheet(
          setImage: (image) {
            setState(() {
              _image = image;
            });
          },
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
