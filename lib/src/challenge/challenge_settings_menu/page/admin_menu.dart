import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key, required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('도전 상세 정보 편집'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            context.push('/create-challenge', extra: challenge);
          },
        ),
        ListTile(
          title: const Text('도전 인증 관리'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            context.push('/challenge/${challenge.id}/manage/0');
          },
        ),
        ListTile(
          title: const Text('도전 멤버 관리'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {
            context.push('/challenge/${challenge.id}/manage/1');
          },
        ),
      ],
    );
  }
}
