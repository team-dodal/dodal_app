import 'dart:io';

import 'package:dodal_app/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: 1,
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          decoration: const BoxDecoration(color: AppColors.systemGrey4),
          child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: FileImage(image),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
