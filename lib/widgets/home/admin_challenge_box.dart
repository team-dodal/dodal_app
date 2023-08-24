import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_list/challenge_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class AdminChallengeBox extends StatelessWidget {
  const AdminChallengeBox({
    super.key,
    required this.title,
    required this.thumbnailImg,
    required this.tag,
    required this.adminProfile,
    required this.adminNickname,
    required this.recruitCnt,
    required this.userCnt,
    required this.certCnt,
    required this.certRequestCnt,
    required this.id,
  });

  final int id;
  final String title;
  final String? thumbnailImg;
  final Tag tag;
  final String? adminProfile;
  final String adminNickname;
  final int recruitCnt;
  final int userCnt;
  final int certCnt;
  final int certRequestCnt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: AppColors.systemWhite,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: AppColors.systemGrey4,
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ]),
      child: Column(
        children: [
          ChallengeBox(
            id: id,
            title: title,
            thumbnailImg: thumbnailImg,
            tag: tag,
            adminProfile: adminProfile,
            adminNickname: adminNickname,
            recruitCnt: recruitCnt,
            userCnt: userCnt,
            certCnt: certCnt,
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: AppColors.basicColor2,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '$certRequestCnt장',
                    style: Typo(context)
                        .body4()!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Text('의 인증이 업로드 되었어요!!'),
                ],
              ),
              Row(
                children: [
                  const Text('관리하기'),
                  const SizedBox(width: 4),
                  Transform.rotate(
                    angle: math.pi / 2,
                    child: SvgPicture.asset('assets/icons/arrow_icon.svg'),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
