import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:dodal_app/widgets/common/input/input_title.dart';
import 'package:dodal_app/widgets/common/room_info_box.dart';
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
    required this.isUpdate,
  });

  final bool isUpdate;
  final int step, steps;
  final void Function() nextStep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<CreateChallengeCubit, CreateChallenge>(
          builder: (context, challenge) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              ImageWidget(
                image: challenge.thumbnailImg,
                width: double.infinity,
                height: 200,
              ),
              RoomInfoBox(
                title: challenge.title!,
                tagName: challenge.tagValue!.name,
                adminProfile: context.read<UserBloc>().state.result!.profileUrl,
                adminNickname: context.read<UserBloc>().state.result!.nickname,
                certCnt: challenge.certCnt!,
                curMember: 1,
                maxMember: challenge.recruitCnt!,
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
                    Text('저희의 도전을 소개해요',
                        style: context.body1(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (challenge.content != null)
                      Text(challenge.content!, style: context.body2()),
                  ],
                ),
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
                    Text('이렇게 인증해요',
                        style: context.body1(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (challenge.content != null)
                      Text(
                        challenge.certContent!,
                        style: context.body2(),
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
      }),
      bottomSheet: SubmitButton(
        onPress: nextStep,
        title: isUpdate ? '도전 수정하기' : '도전 생성하기',
      ),
    );
  }
}
