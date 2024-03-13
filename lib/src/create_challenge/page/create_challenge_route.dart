import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/create_challenge/bloc/create_challenge_cubit.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_content_page.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_preview_page.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_tag_page.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_title_page.dart';
import 'package:dodal_app/src/common/layout/create_screen_layout.dart';
import 'package:dodal_app/src/common/widget/system_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateChallengeRoute extends StatefulWidget {
  const CreateChallengeRoute({super.key});

  @override
  State<CreateChallengeRoute> createState() => _CreateChallengeRouteState();
}

class _CreateChallengeRouteState extends State<CreateChallengeRoute> {
  int _currentIndex = 0;
  int steps = 4;

  void _error(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => SystemDialog(subTitle: errorMessage),
    );
  }

  void _success(bool isUpdate) {
    context.go('/main');
    context.push(
      '/create-challenge/complete/${isUpdate ? 'update' : 'create'}',
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
        children: [
          CreateChallengeTagPage(
            step: _currentIndex + 1,
            steps: steps,
            nextStep: () {
              setState(() {
                _currentIndex += 1;
              });
            },
          ),
          CreateChallengeTitlePage(
            step: _currentIndex + 1,
            steps: steps,
            previousStep: () {
              setState(() {
                _currentIndex -= 1;
              });
            },
            nextStep: () {
              setState(() {
                _currentIndex += 1;
              });
            },
          ),
          CreateChallengeContentPage(
            step: _currentIndex + 1,
            steps: steps,
            previousStep: () {
              setState(() {
                _currentIndex -= 1;
              });
            },
            nextStep: () {
              setState(() {
                _currentIndex += 1;
              });
            },
          ),
          CreateChallengePreviewPage(
            step: _currentIndex + 1,
            steps: steps,
            previousStep: () {
              setState(() {
                _currentIndex -= 1;
              });
            },
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
