import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_preview/feed_img_content.dart';
import 'package:dodal_app/widgets/challenge_room/challenge_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/cross_divider.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/room_info_box.dart';
import 'package:dodal_app/widgets/create_challenge/certificate_image_input.dart';
import 'package:flutter/material.dart';

class ChallengePreviewScreen extends StatefulWidget {
  const ChallengePreviewScreen({super.key, required this.id});

  final int id;

  @override
  State<ChallengePreviewScreen> createState() => _ChallengePreviewScreenState();
}

class _ChallengePreviewScreenState extends State<ChallengePreviewScreen> {
  OneChallengeResponse? _challenge;

  _join() async {
    final res = await ChallengeService.join(challengeId: widget.id);
    if (res) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ChallengeRoute(id: widget.id)),
        (route) => route.isFirst,
      );
    }
  }

  _getChallenge() async {
    final res = await ChallengeService.getChallengeOne(challengeId: widget.id);
    setState(() {
      _challenge = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _getChallenge();
  }

  @override
  Widget build(BuildContext context) {
    if (_challenge == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: PreviewScreen(challenge: _challenge!),
      bottomSheet: ChallengeBottomSheet(
        roomId: _challenge!.id,
        buttonText: '도전 참여하기',
        bookmarked: _challenge!.isBookmarked,
        onPress: _join,
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({
    super.key,
    required this.challenge,
  });

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
          const CrossDivider(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '저희의 도전을 소개해요',
                  style: context.body1(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  challenge.content,
                  style: context.body2(color: AppColors.systemGrey1),
                ),
                const SizedBox(height: 32),
                Text(
                  '저희의 도전을 모아봐요',
                  style: context.body1(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          FeedImgContent(feedList: challenge.feedUrlList),
          const SizedBox(height: 32),
          const CrossDivider(),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이렇게 인증해요',
                  style: context.body1(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  challenge.certContent,
                  style: context.body2(color: AppColors.systemGrey1),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: challenge.certCorrectImgUrl != null
                          ? CertificateImageInput(
                              image: challenge.certCorrectImgUrl,
                              certOption: CertOption.correct,
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: challenge.certWrongImgUrl != null
                          ? CertificateImageInput(
                              image: challenge.certWrongImgUrl,
                              certOption: CertOption.wrong,
                            )
                          : const SizedBox(),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
