import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreviewMenu extends StatelessWidget {
  const PreviewMenu({
    super.key,
    required this.challenge,
  });

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: const Text('신고하기'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          context.push('/report/${challenge.id}');
        },
      ),
    ]);
  }
}
