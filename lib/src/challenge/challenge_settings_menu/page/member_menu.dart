import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/common/repositories/challenge_repository.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MemberMenu extends StatelessWidget {
  const MemberMenu({super.key, required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    challengeOut() async {
      showDialog(
        context: context,
        builder: (context) => SystemDialog(
          title: '정말로 나가시겠습니까?',
          children: [
            SystemDialogButton(
              text: '취소',
              primary: false,
              onPressed: () {
                context.pop();
              },
            ),
            SystemDialogButton(
              text: '나가기',
              onPressed: () async {
                final res =
                    await ChallengeRepository.out(challengeId: challenge.id);
                if (!res) return;
                if (context.mounted) {
                  context.go('/main');
                }
              },
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        ListTile(
          title: const Text('나가기'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: challengeOut,
        ),
        ListTile(
          title: const Text('신고하기'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            context.push('/report/${challenge.id}');
          },
        ),
      ],
    );
  }
}
