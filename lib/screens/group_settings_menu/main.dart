import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/group_settings_menu/manage_group_screen.dart';
import 'package:dodal_app/screens/group_settings_menu/modify_group_screen.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(challenge.title),
      ),
      body: Column(
          children: isHost
              ? [
                  ListTile(
                    title: const Text('도전 상세 정보 편집'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('도전 인증 관리'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text('도전 멤버 관리'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),
                  Container(
                    height: 8,
                    decoration: const BoxDecoration(color: AppColors.bgColor2),
                  ),
                  ListTile(
                    title: const Text('도전 그룹 삭제하기'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {},
                  ),
                ]
              : [
                  ListTile(
                    title: const Text('나가기'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext ctx) =>
                              const ModifyGroupScreen()));
                    },
                  ),
                  ListTile(
                    title: const Text('신고하기'),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext ctx) =>
                              const ManageGroupScreen()));
                    },
                  ),
                ]),
    );
  }
}
