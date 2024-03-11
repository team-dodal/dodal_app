import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/common/model/challenge_detail_model.dart';
import 'package:dodal_app/src/challenge/challenge_settings_menu/page/admin_menu.dart';
import 'package:dodal_app/src/challenge/challenge_settings_menu/page/member_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeMenuPage extends StatelessWidget {
  const ChallengeMenuPage({
    super.key,
    required this.challenge,
  });

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    final userId = BlocProvider.of<AuthBloc>(context).state.user!.id;
    bool isHost = challenge.hostId == userId;
    bool isJoined = challenge.isJoin;

    return Scaffold(
      appBar: AppBar(title: Text(challenge.title)),
      body: Builder(
        builder: (context) {
          if (isHost) {
            return AdminMenu(challenge: challenge);
          }
          if (isJoined) {
            return MemberMenu(challenge: challenge);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
