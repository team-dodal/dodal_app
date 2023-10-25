import 'package:dodal_app/widgets/common/cross_divider.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';

class MyFeedBox extends StatelessWidget {
  const MyFeedBox({super.key, required this.feedId});

  final int feedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('내가 쓴 글'),
        ),
        body: const Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ImageWidget(
                image: null,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('텍스트'),
                ),
              ],
            ),
            CrossDivider()
          ],
        ));
  }
}
