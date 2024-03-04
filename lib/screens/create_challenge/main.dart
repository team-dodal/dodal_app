import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/screens/create_challenge/challenge_content_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_preview_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_tag_screen.dart';
import 'package:dodal_app/screens/create_challenge/challenge_title_screen.dart';
import 'package:dodal_app/layout/create_screen_layout.dart';
import 'package:dodal_app/screens/create_challenge/complete_screen.dart';
import 'package:dodal_app/widgets/common/system_dialog.dart';
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

  void _error(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(subTitle: errorMessage),
    );
  }

  void _success(bool isUpdate) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => CompleteCreateChallenge(isUpdate: isUpdate),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateChallengeBloc, CreateChallengeState>(
      listener: (context, state) {
        if (state.status == CommonStatus.error) {
          _error(state.errorMessage!);
        }
        if (state.status == CommonStatus.loaded) {
          _success(state.isUpdate);
        }
      },
      child: CreateScreenLayout(
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
            nextStep: () {
              context
                  .read<CreateChallengeBloc>()
                  .add(SubmitCreateChallengeEvent());
            },
          )
        ],
      ),
    );
  }
}
