import 'package:dodal_app/screens/main_route/main.dart';
import 'package:dodal_app/screens/report/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
import 'package:flutter/material.dart';

class MemberMenu extends StatelessWidget {
  const MemberMenu({super.key, required this.challenge});

  final OneChallengeResponse challenge;

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
                Navigator.pop(context);
              },
            ),
            SystemDialogButton(
              text: '나가기',
              onPressed: () async {
                final res =
                    await ChallengeService.out(challengeId: challenge.id);
                if (!res) return;
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainRoute(),
                    ),
                    (route) => route.isFirst,
                  );
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
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReportScreen(roomId: challenge.id),
              ),
            );
          },
        ),
      ],
    );
  }
}
