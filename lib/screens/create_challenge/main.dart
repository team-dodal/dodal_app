import 'package:dodal_app/screens/create_challenge/challenge_content_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_tag_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_title_screen.dart';
import 'package:dodal_app/widgets/common/create_screen_layout.dart';
import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  int _currentIndex = 0;
  int steps = 3;
  String? _selectedTag;
  String title = '';
  String content = '';

  _submit() {}

  @override
  Widget build(BuildContext context) {
    return CreateScreenLayout(
      currentIndex: _currentIndex,
      popStep: () {
        setState(() {
          _currentIndex -= 1;
        });
      },
      children: [
        ChallengeTagScreen(
          step: _currentIndex + 1,
          steps: steps,
          nextStep: (tag) {
            setState(() {
              _currentIndex += 1;
              _selectedTag = tag;
            });
          },
        ),
        ChallengeTitleScreen(
          step: _currentIndex + 1,
          steps: steps,
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        ChallengeContentScreen(
          step: _currentIndex + 1,
          steps: steps,
          nextStep: _submit,
        ),
      ],
    );
  }
}
