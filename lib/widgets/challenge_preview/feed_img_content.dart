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

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 3,
      mainAxisSpacing: 3,
      childAspectRatio: 1,
      shrinkWrap: true,
      children: [
        for (final i in [1, 2, 3, 4, 5, 6]) Container(color: Colors.blue)
      ],
    );
  }
}
