import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/challenge_preview/feed_img_content.dart';
import 'package:dodal_app/widgets/challenge_room/current_certification_box.dart';
import 'package:dodal_app/widgets/challenge_room/notice_box.dart';
import 'package:dodal_app/widgets/common/room_info_box.dart';
import 'package:dodal_app/widgets/common/room_thumbnail_image.dart';
import 'package:flutter/material.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          RoomThumbnailImage(image: challenge.thumbnailImgUrl),
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
          Container(
            width: double.infinity,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.systemGrey4),
          ),
          const SizedBox(height: 32),
          const CurrentCertificationBox(),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.systemGrey4),
          ),
          FeedImgContent(feedList: challenge.feedUrlList)
        ],
      ),
    );
  }
}
