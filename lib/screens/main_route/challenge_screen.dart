import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:flutter/material.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('group'),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const CreateChallengeScreen()));
              },
              child: const Text('그룹 생성')),
        ],
      ),
    );
  }
}
