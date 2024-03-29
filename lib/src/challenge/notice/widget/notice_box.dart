import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class NoticeBox extends StatelessWidget {
  const NoticeBox({super.key, required this.challenge});

  final ChallengeDetail challenge;

  _goNoticeScreen(BuildContext context, int? openIndex) {
    context.push(
      '/challenge/${challenge.id}/notice-list/$openIndex',
      extra: challenge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '공지사항',
                style: context.body1(fontWeight: FontWeight.bold),
              ),
              Material(
                child: InkWell(
                  onTap: () {
                    _goNoticeScreen(context, null);
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2),
                        child: Text('전체보기'),
                      ),
                      const SizedBox(width: 4),
                      Transform.rotate(
                        angle: math.pi / 2,
                        child: SvgPicture.asset('assets/icons/arrow_icon.svg'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              if (challenge.noticeTitle != null) {
                _goNoticeScreen(context, 0);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
              decoration: const BoxDecoration(
                  color: AppColors.bgColor2,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: challenge.noticeTitle != null
                  ? Row(
                      children: [
                        SvgPicture.asset('assets/icons/speaker_icon.svg'),
                        const SizedBox(width: 10),
                        Text(
                          challenge.noticeTitle!,
                          style: context.body2(color: AppColors.systemGrey1),
                        )
                      ],
                    )
                  : Text(
                      '공지사항이 없습니다.',
                      style: context.body2(color: AppColors.systemGrey1),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
