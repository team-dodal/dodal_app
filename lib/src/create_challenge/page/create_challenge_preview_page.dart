import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/create_challenge/bloc/create_challenge_cubit.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:dodal_app/src/common/widget/input/input_title.dart';
import 'package:dodal_app/src/common/widget/room_info_box.dart';
import 'package:dodal_app/src/common/widget/submit_button.dart';
import 'package:dodal_app/src/create_challenge/widget/certificate_image_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengePreviewPage extends StatelessWidget {
  const CreateChallengePreviewPage({
    super.key,
    required this.step,
    required this.steps,
    required this.nextStep,
  });

  final int step, steps;
  final void Function() nextStep;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateChallengeBloc, CreateChallengeState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              ImageWidget(
                image: state.thumbnailImg,
                width: double.infinity,
                height: 200,
              ),
              RoomInfoBox(
                title: state.title,
                tagName: state.tagValue!.name,
                adminProfile: context.read<UserBloc>().state.result!.profileUrl,
                adminNickname: context.read<UserBloc>().state.result!.nickname,
                certCnt: state.certCnt,
                curMember: 1,
                maxMember: state.recruitCnt,
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
                    Text(state.content, style: context.body2()),
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
                    Text(
                      '이렇게 인증해요',
                      style: context.body1(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.certContent,
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
                          child: state.certCorrectImg != null
                              ? CertificateImageInput(
                                  image: state.certCorrectImg,
                                  certOption: CertOption.correct,
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: state.certWrongImg != null
                              ? CertificateImageInput(
                                  image: state.certWrongImg,
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
        bottomSheet: SubmitButton(
          onPress: state.status == CommonStatus.loading ? null : nextStep,
          title: state.isUpdate ? '도전 수정하기' : '도전 생성하기',
        ),
      );
    });
  }
}
