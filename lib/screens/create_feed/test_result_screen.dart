import 'dart:io';

import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';

class TestResultScreen extends StatelessWidget {
  const TestResultScreen({super.key, required this.image});

  final File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AspectRatio(
        aspectRatio: 1,
        child: ImageWidget(
          image: image,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
