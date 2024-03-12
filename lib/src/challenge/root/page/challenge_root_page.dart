import 'package:dodal_app/src/challenge/main/page/challenge_main_page.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/challenge/main/bloc/challenge_info_bloc.dart';
import 'package:dodal_app/src/challenge/challenge_preview/page/challenge_preview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChallengeRootPage extends StatelessWidget {
  const ChallengeRootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.replace('/main');
        return false;
      },
      child: BlocBuilder<ChallengeInfoBloc, ChallengeInfoState>(
        builder: (context, state) {
          switch (state.status) {
            case CommonStatus.init:
            case CommonStatus.loading:
              return Scaffold(
                appBar: AppBar(),
                body: const Center(child: CupertinoActivityIndicator()),
              );
            case CommonStatus.error:
              return Scaffold(
                appBar: AppBar(),
                body: Center(child: Text(state.errorMessage!)),
              );
            case CommonStatus.loaded:
              final challenge = state.result!;
              if (challenge.isJoin) {
                return const ChallengeMainPage();
              } else {
                return const ChallengePreviewPage();
              }
          }
        },
      ),
    );
  }
}
