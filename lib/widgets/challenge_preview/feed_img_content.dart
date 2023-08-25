import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
            style: context.body2(color: AppColors.systemGrey1),
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
        for (final feed in feedList)
          Container(
            color: AppColors.systemGrey4,
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(feed),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          )
      ],
    );
  }
}
