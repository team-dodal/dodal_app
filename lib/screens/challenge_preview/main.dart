import 'package:dodal_app/services/challenge_service.dart';
import 'package:flutter/material.dart';

class ChallengePreviewScreen extends StatefulWidget {
  const ChallengePreviewScreen({super.key, required this.id});

  final int id;

  @override
  State<ChallengePreviewScreen> createState() => _ChallengePreviewScreenState();
}

class _ChallengePreviewScreenState extends State<ChallengePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ChallengeService.getChallengeOne(challengeId: widget.id),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Scaffold(appBar: AppBar());
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Text('hi'),
        );
      },
    );
  }
}
