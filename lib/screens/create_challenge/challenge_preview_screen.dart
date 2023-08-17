import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/input_title.dart';
import 'package:dodal_app/widgets/common/room_info_box.dart';
import 'package:dodal_app/widgets/common/room_thumbnail_image.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/create_challenge/certificate_image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengePreviewScreen extends StatelessWidget {
  const ChallengePreviewScreen({
    super.key,
    required this.step,
    required this.steps,
    required this.nextStep,
  });

  final int step, steps;
  final void Function() nextStep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CreateChallengeCubit, CreateChallenge>(
          builder: (context, challenge) {
        return BlocBuilder<UserCubit, User?>(
          builder: (context, user) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  RoomThumbnailImage(image: challenge.thumbnailImg),
                  RoomInfoBox(
                    title: challenge.title!,
                    tagName: challenge.tagValue!.name,
                    adminProfile: user!.profileUrl,
                    adminNickname: user.nickname,
                    curMember: 1,
                    maxMember: challenge.recruitCnt!,
                  ),
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration:
                        const BoxDecoration(color: AppColors.systemGrey4),
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
                        Text('저희의 도전을 소개해요',
                            style: Typo(context)
                                .body1()!
                                .copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (challenge.content != null)
                          Text(challenge.content!,
                              style: Typo(context).body2()!),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration:
                        const BoxDecoration(color: AppColors.systemGrey4),
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
                        if (challenge.content != null)
                          Text(
                            challenge.certContent!,
                            style: Typo(context).body2()!,
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InputTitle(
                          title: '인증 예시',
                          subTitle: '사진을 통해 인증 성공과 실패 예시를 추가해주세요.',
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: challenge.certCorrectImg != null
                                  ? CertificateImageInput(
                                      image: challenge.certCorrectImg,
                                      certOption: CertOption.correct,
                                    )
                                  : const SizedBox(),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: challenge.certWrongImg != null
                                  ? CertificateImageInput(
                                      image: challenge.certWrongImg,
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
          },
        );
      }),
      bottomSheet: SubmitButton(onPress: nextStep, title: '도전 생성하기'),
    );
  }
}
