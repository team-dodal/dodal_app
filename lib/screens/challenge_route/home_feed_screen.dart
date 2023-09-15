import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/widgets/challenge_preview/feed_img_content.dart';
import 'package:dodal_app/widgets/challenge_room/current_certification_box.dart';
import 'package:dodal_app/widgets/challenge_room/notice_box.dart';
import 'package:dodal_app/widgets/common/cross_divider.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/room_info_box.dart';
import 'package:flutter/material.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

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
          const CrossDivider(),
          const SizedBox(height: 32),
          const CurrentCertificationBox(),
          const SizedBox(height: 32),
          const CrossDivider(),
          const SizedBox(height: 32),
          FeedImgContent(feedList: challenge.feedUrlList)
        ],
      ),
    );
  }
}
