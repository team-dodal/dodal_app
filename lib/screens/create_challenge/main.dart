import 'dart:io';

import 'package:dodal_app/screens/create_challenge/challenge_content_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_tag_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_title_screen.dart';
import 'package:dodal_app/services/challenge_service.dart';
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
  String? _tagValue;
  String _title = '';
  String _content = '';
  File? _thumbnailImg;
  int? _recruitCnt;
  final int _certCnt = 1;
  final String _certContent = '';
  final String _warnContent = '';
  File? _certCorrectImg;
  File? _certWrongImg;

  _submit() {
    ChallengeService.createChallenge(
      title: _title,
      content: _content,
      thumbnailImg: _thumbnailImg,
      tagValue: _tagValue!,
      recruitCnt: _recruitCnt!,
      certCnt: _certCnt,
      certContent: _certContent,
      warnContent: _warnContent,
      certCorrectImg: _certCorrectImg,
      certWrongImg: _certWrongImg,
    );
  }

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
              _tagValue = tag;
            });
          },
        ),
        ChallengeTitleScreen(
          step: _currentIndex + 1,
          steps: steps,
          nextStep: ({content = '', recruitCnt = 0, thumbnailImg, title = ''}) {
            setState(() {
              _currentIndex += 1;
              _title = title;
              _content = content;
              _recruitCnt = recruitCnt;
              _thumbnailImg = thumbnailImg;
            });
          },
          title: _title,
          content: _content,
          thumbnailImg: _thumbnailImg,
          recruitCnt: _recruitCnt,
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
