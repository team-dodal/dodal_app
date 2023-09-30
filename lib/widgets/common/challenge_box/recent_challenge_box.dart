import 'package:dodal_app/model/challenge_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/challenge_box/list_challenge_box.dart';
import 'package:flutter/material.dart';

class RecentChallengeBox extends StatelessWidget {
  const RecentChallengeBox({super.key, required this.challenge});

  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: AppColors.systemGrey3,
              offset: Offset(0, 0),
              blurRadius: 8,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Column(
          children: [
            ListChallengeBox(
              id: challenge.id,
              title: challenge.title,
              thumbnailImg: challenge.thumbnailImg,
              tag: challenge.tag,
              adminProfile: challenge.adminProfile,
              adminNickname: challenge.adminNickname,
              recruitCnt: challenge.recruitCnt,
              userCnt: challenge.userCnt,
              certCnt: challenge.certCnt,
            ),
            const Text('data')
          ],
        ),
      ),
    );
  }
}
