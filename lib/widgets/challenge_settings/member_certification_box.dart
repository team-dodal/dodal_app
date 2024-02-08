import 'package:dodal_app/model/certification_code_enum.dart';
import 'package:dodal_app/model/day_enum.dart';
import 'package:dodal_app/providers/user_bloc.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_settings/member_manage_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/avatar_image.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberCertificationBox extends StatefulWidget {
  const MemberCertificationBox({
    super.key,
    required this.user,
    required this.challenge,
    required this.getUsers,
  });

  final Future<void> Function() getUsers;
  final ChallengeUser user;
  final OneChallengeResponse challenge;

  @override
  State<MemberCertificationBox> createState() => _MemberCertificationBoxState();
}

class _MemberCertificationBoxState extends State<MemberCertificationBox> {
  List<UserWeekCertInfo?> _certList = [];

  _showCountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => MemberManageBottomSheet(
        getUsers: widget.getUsers,
        userId: widget.user.userId,
        roomId: widget.challenge.id,
      ),
    );
  }

  _createUserCertList() {
    List<UserWeekCertInfo?> list = List.generate(7, (index) => null);
    for (final certInfo in widget.user.userWeekCertInfoList!) {
      final index = DayEnum.values.indexOf(certInfo.dayCode!);
      list[index] = certInfo;
    }
    setState(() {
      _certList = list;
    });
  }

  @override
  void initState() {
    _createUserCertList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const AvatarImage(image: null, width: 32, height: 32),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.nickname,
                        style: context.body4(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '인증 ${widget.user.certSuccessCnt}회 | 인증 실패 ${widget.user.certFailCnt}회',
                        style: context.caption(color: AppColors.systemGrey1),
                      ),
                    ],
                  )
                ],
              ),
              Builder(
                builder: (context) {
                  final state = BlocProvider.of<UserBloc>(context).state.result;
                  if (state!.id != widget.user.userId) {
                    return TextButton(
                      onPressed: () {
                        _showCountBottomSheet(context);
                      },
                      child: Text(
                        '관리하기',
                        style: context.caption(
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
          const SizedBox(height: 17),
          SizedBox(
            height: 50,
            child: GridView.count(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              physics: const NeverScrollableScrollPhysics(),
              children: [for (final i in _certList) FeedImageBox(certInfo: i)],
            ),
          )
        ],
      ),
    );
  }
}

class FeedImageBox extends StatelessWidget {
  const FeedImageBox({super.key, required this.certInfo});

  final UserWeekCertInfo? certInfo;

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.systemGrey3;

    if (certInfo != null) {
      if (certInfo!.certCode == CertCode.success) {
        borderColor = AppColors.success;
      } else if (certInfo!.certCode == CertCode.fail) {
        borderColor = AppColors.danger;
      }
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: certInfo != null
          ? Stack(
              children: [
                ImageWidget(
                  width: double.infinity,
                  height: double.infinity,
                  image: certInfo!.certImageUrl,
                  borderRadius: 2,
                ),
                if (certInfo!.certCode != CertCode.pending)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4)),
                      ),
                      child: Icon(
                        certInfo!.certCode == CertCode.success
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        size: 16,
                        color: AppColors.systemWhite,
                      ),
                    ),
                  )
              ],
            )
          : null,
    );
  }
}
