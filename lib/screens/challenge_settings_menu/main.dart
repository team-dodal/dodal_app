import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/challenge_settings_menu/admin_menu.dart';
import 'package:dodal_app/screens/challenge_settings_menu/member_menu.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSettingsMenuScreen extends StatelessWidget {
  const GroupSettingsMenuScreen({
    super.key,
    required this.challenge,
  });

  final OneChallengeResponse challenge;

  @override
  Widget build(BuildContext context) {
    final userId = BlocProvider.of<UserCubit>(context).state!.id;
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
