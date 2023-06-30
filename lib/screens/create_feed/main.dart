import 'package:dodal_app/widgets/create_feed/image_input.dart';
import 'package:flutter/material.dart';

class CreateFeedScreen extends StatelessWidget {
  const CreateFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인증글 게시'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ImageInput(),
          ],
        ),
      ),
    );
  }
}
