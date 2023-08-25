import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/challenge_notice/room_notice_list_screen.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

class NoticeBox extends StatelessWidget {
  const NoticeBox({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  _goNoticeScreen(BuildContext context, int? openIndex) {
    final user = BlocProvider.of<UserCubit>(context).state!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoomNoticeListScreen(
          id: challenge.id,
          isAdmin: challenge.hostId == user.id,
          openIndex: openIndex,
        ),
      ),
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
