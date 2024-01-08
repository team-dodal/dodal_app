import 'package:dodal_app/screens/report/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:flutter/material.dart';

class PreviewMenu extends StatelessWidget {
  const PreviewMenu({
    super.key,
    required this.challenge,
  });

  final OneChallengeResponse challenge;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: const Text('신고하기'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ReportScreen(),
            ),
          );
        },
      ),
    ]);
  }
}
