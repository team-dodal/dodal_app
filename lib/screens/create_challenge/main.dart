import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/screens/create_challenge/complete_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_content_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_preview_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_tag_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_title_screen.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/layout/create_screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChallengeScreen extends StatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  int _currentIndex = 0;
  int steps = 4;

  _submit() async {
    final state = BlocProvider.of<CreateChallengeCubit>(context).state;
    var res;
    if (state.id != null) {
      res = await ChallengeService.updateChallenge(
        title: state.title!,
        content: state.content!,
        thumbnailImg: state.thumbnailImg,
        tagValue: state.tagValue!.value,
        recruitCnt: state.recruitCnt!,
        certCnt: state.certCnt!,
        certContent: state.certContent!,
        certCorrectImg: state.certCorrectImg,
        certWrongImg: state.certWrongImg,
      );
    } else {
      res = await ChallengeService.createChallenge(
        title: state.title!,
        content: state.content!,
        thumbnailImg: state.thumbnailImg,
        tagValue: state.tagValue!.value,
        recruitCnt: state.recruitCnt!,
        certCnt: state.certCnt!,
        certContent: state.certContent!,
        certCorrectImg: state.certCorrectImg,
        certWrongImg: state.certWrongImg,
      );
    }
    if (res == null) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (ctx) =>
              CompleteCreateChallenge(isUpdate: state.id != null)),
      (route) => false,
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
          nextStep: () {
            setState(() {
              _currentIndex += 1;
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
          nextStep: () {
            setState(() {
              _currentIndex += 1;
            });
          },
        ),
        ChallengePreviewScreen(
          step: _currentIndex + 1,
          steps: steps,
          nextStep: _submit,
        )
      ],
    );
  }
}
