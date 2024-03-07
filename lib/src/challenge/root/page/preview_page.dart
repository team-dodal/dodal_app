import 'package:dodal_app/src/common/helper/slide_page_route.dart';
import 'package:dodal_app/src/common/bloc/bookmark_bloc.dart';
import 'package:dodal_app/src/challenge/home/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/challenge_settings_menu/page/challenge_menu_page.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/challenge/widget/feed_img_content.dart';
import 'package:dodal_app/src/challenge/widget/challenge_bottom_sheet.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:dodal_app/src/common/widget/room_info_box.dart';
import 'package:dodal_app/src/create_challenge/widget/certificate_image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengePreviewPage extends StatelessWidget {
  const ChallengePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.read<ChallengeInfoBloc>().state.result!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                SlidePageRoute(
                  screen: ChallengeMenuPage(challenge: challenge),
                ),
              );
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: const PreviewScreen(),
      bottomSheet: BlocProvider(
        create: (context) => BookmarkBloc(
          roomId: challenge.id,
          isBookmarked: challenge.isBookmarked,
        ),
        child: ChallengeBottomSheet(
          buttonText: '도전 참여하기',
          onPress: () {
            context.read<ChallengeInfoBloc>().add(JoinChallengeEvent());
          },
        ),
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final challenge = context.read<ChallengeInfoBloc>().state.result!;
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
          const Divider(thickness: 8, color: AppColors.systemGrey4),
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
          FeedImgContent(feedList: challenge.feedUrlList, isPreview: true),
          const SizedBox(height: 32),
          const Divider(thickness: 8, color: AppColors.systemGrey4),
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
