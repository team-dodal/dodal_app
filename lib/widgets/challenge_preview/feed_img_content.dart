import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
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
            style: context.body2(color: AppColors.systemGrey1),
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final feed
                in feedList.length < 9 ? feedList : feedList.sublist(0, 9))
              Stack(
                children: [
                  ImageWidget(
                    image: feed,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(onTap: () {}),
                    ),
                  )
                ],
              )
          ],
        ),
        if (feedList.length >= 9)
          Positioned(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.systemWhite.withOpacity(1),
                    AppColors.systemWhite.withOpacity(1),
                    AppColors.systemWhite.withOpacity(0.7),
                    AppColors.systemWhite.withOpacity(0.5),
                    AppColors.systemWhite.withOpacity(0.1),
                    AppColors.systemWhite.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: AppColors.systemGrey4,
                    ),
                    child: const Text('도전방에 가입하여 더 많은 달성을 확인해보세요!'),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
