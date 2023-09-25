import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class ContinueCertBox extends StatelessWidget {
  const ContinueCertBox({super.key, required this.feedContent});

  final FeedContentResponse feedContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: const BoxDecoration(
        color: AppColors.systemWhite,
        borderRadius: BorderRadius.all(Radius.circular(35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.systemGrey3,
            offset: Offset(0, 0),
            blurRadius: 8,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Text(
        '🔥 ${feedContent.continueCertCnt}회째 실천 중!',
        style: context.caption(
          fontWeight: FontWeight.bold,
          color: AppColors.systemGrey1,
        ),
      ),
    );
  }
}
