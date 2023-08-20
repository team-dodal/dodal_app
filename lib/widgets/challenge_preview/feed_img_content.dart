import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class FeedImgContent extends StatelessWidget {
  const FeedImgContent({
    super.key,
    required this.feedList,
  });

  final List<dynamic> feedList;

  @override
  Widget build(BuildContext context) {
    if (feedList.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 128,
        child: Center(
          child: Text(
            '아직 인증 게시물이 없습니다.',
            style:
                Typo(context).body2()!.copyWith(color: AppColors.systemGrey1),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.red,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.blue,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.red,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.blue,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(width: 3),
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
