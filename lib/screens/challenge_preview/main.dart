import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/input_title.dart';
import 'package:dodal_app/widgets/common/room_info_box.dart';
import 'package:dodal_app/widgets/common/room_thumbnail_image.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/create_challenge/certificate_image_input.dart';
import 'package:flutter/material.dart';

class ChallengePreviewScreen extends StatefulWidget {
  const ChallengePreviewScreen({super.key, required this.id});

  final int id;

  @override
  State<ChallengePreviewScreen> createState() => _ChallengePreviewScreenState();
}

class _ChallengePreviewScreenState extends State<ChallengePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ChallengeService.getChallengeOne(challengeId: widget.id),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(appBar: AppBar());
        }
        final OneChallengeResponse challenge = snapshot.data!;
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                RoomThumbnailImage(image: challenge.thumbnailImgUrl),
                RoomInfoBox(
                  title: challenge.title,
                  tagName: challenge.tag.name,
                  adminProfile: challenge.hostProfileUrl,
                  adminNickname: challenge.hostNickname,
                  maxMember: challenge.userCnt,
                  curMember: challenge.recruitCnt,
                ),
                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.systemGrey4),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('인증 방법',
                          style: Typo(context)
                              .body1()!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        challenge.certContent,
                        style: Typo(context).body2(),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputTitle(
                        title: '이렇게 인증해요',
                        subTitle: challenge.certContent,
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
          ),
          bottomSheet: SubmitButton(onPress: () {}, title: '도전 참여하기'),
        );
      },
    );
  }
}
