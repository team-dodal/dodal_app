import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/challenge/widget/feed_img_content.dart';
import 'package:dodal_app/src/challenge/main/widget/current_certification_box.dart';
import 'package:dodal_app/src/challenge/notice/widget/notice_box.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:dodal_app/src/common/widget/room_info_box.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChallengeHomePage extends StatelessWidget {
  const ChallengeHomePage({super.key, required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          ImageWidget(
            image: challenge.thumbnailImgUrl,
            width: double.infinity,
            height: 200,
          ),
          RoomInfoBox(
            title: challenge.title,
            tagName: challenge.tag.name,
            adminProfile: challenge.hostProfileUrl,
            certCnt: challenge.certCnt,
            adminNickname: challenge.hostNickname,
            maxMember: challenge.recruitCnt,
            curMember: challenge.userCnt,
          ),
          NoticeBox(challenge: challenge),
          const SizedBox(height: 32),
          const Divider(thickness: 8, color: AppColors.systemGrey4),
          const SizedBox(height: 32),
          CurrentCertificationBox(
            userWeekList: challenge.userCertPerWeekList,
            continueCertCnt: challenge.continueCertCnt!,
          ),
          const SizedBox(height: 32),
          const Divider(thickness: 8, color: AppColors.systemGrey4),
          const SizedBox(height: 32),
          FeedImgContent(feedList: challenge.feedUrlList),
          const SizedBox(height: 16),
          if (challenge.feedUrlList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {
                  context.push(
                      '/challenge/${challenge.id}/feed/${challenge.title}');
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    side: BorderSide(color: AppColors.systemGrey3),
                  ),
                ),
                child: Text(
                  '더보기',
                  style: context.body2(
                    color: AppColors.systemGrey1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
