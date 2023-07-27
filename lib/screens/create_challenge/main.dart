import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/screens/create_challenge/challenge_content_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_preview_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_tag_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_title_screen.dart';
import 'package:dodal_app/widgets/common/create_screen_layout.dart';
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

  _submit() {
    final state = BlocProvider.of<CreateChallengeCubit>(context).state;
    print(state.title);
    print(state.content);
    print(state.thumbnailImg);
    print(state.tagValue);
    print(state.recruitCnt);
    print(state.certCnt);
    print(state.certContent);
    print(state.warnContent);
    print(state.certCorrectImg);
    print(state.certWrongImg);
    // ChallengeService.createChallenge(
    //   title: _title,
    //   content: _content,
    //   thumbnailImg: _thumbnailImg,
    //   tagValue: _tagValue!,
    //   recruitCnt: _recruitCnt!,
    //   certCnt: _certCnt,
    //   certContent: _certContent,
    //   warnContent: _warnContent,
    //   certCorrectImg: _certCorrectImg,
    //   certWrongImg: _certWrongImg,
    // );
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
