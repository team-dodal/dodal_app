import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/input_title.dart';
import 'package:dodal_app/widgets/common/submit_button.dart';
import 'package:dodal_app/widgets/create_challenge/certificate_image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

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
        // print(challenge.tagValue!);
        return BlocBuilder<UserCubit, User?>(builder: (context, user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(color: AppColors.systemGrey4),
                  child: Builder(
                    builder: (context) {
                      if (challenge.thumbnailImg != null) {
                        return FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: FileImage(challenge.thumbnailImg!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 6,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.lightOrange,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Text(
                            challenge.tagValue!.name,
                            style: Typo(context).caption()!.copyWith(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 6,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.systemGrey4,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Text(
                            '인증횟수',
                            style: Typo(context).caption()!.copyWith(
                                  color: AppColors.systemGrey1,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Text(
                        challenge.title!,
                        style: Typo(context)
                            .headline2()!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        AvatarImage(
                          image: user!.profileUrl,
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${user.nickname} · ',
                          style: Typo(context)
                              .body4()!
                              .copyWith(color: AppColors.systemGrey2),
                        ),
                        const Icon(
                          Icons.person,
                          color: AppColors.systemGrey2,
                          size: 20,
                        ),
                        Text(
                          '멤버 1',
                          style: Typo(context)
                              .body4()!
                              .copyWith(color: AppColors.systemBlack),
                        ),
                        Text(
                          '/${challenge.recruitCnt}',
                          style: Typo(context)
                              .body4()!
                              .copyWith(color: AppColors.systemGrey2),
                        ),
                      ]),
                    ],
                  ),
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
                      Text('저희의 도전을 소개해요',
                          style: Typo(context)
                              .body1()!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (challenge.content != null)
                        Text(challenge.content!, style: Typo(context).body2()!),
                    ],
                  ),
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
                        required: true,
                        subTitle: '사진을 통해 인증 성공과 실패 예시를 추가해주세요.',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CertificateImageInput(
                              image: challenge.certCorrectImg,
                              certOption: CertOption.correct,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CertificateImageInput(
                              image: challenge.certWrongImg,
                              certOption: CertOption.wrong,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      }),
      bottomSheet: SubmitButton(onPress: nextStep, title: '도전 생성하기'),
    );
  }
}
