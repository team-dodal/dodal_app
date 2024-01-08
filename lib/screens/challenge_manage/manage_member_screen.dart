import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/services/manage_challenge/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/challenge_settings/member_certification_box.dart';
import 'package:flutter/material.dart';

class ManageMemberScreen extends StatefulWidget {
  const ManageMemberScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  State<ManageMemberScreen> createState() => _ManageMemberScreenState();
}

class _ManageMemberScreenState extends State<ManageMemberScreen> {
  List<ChallengeUser> _userList = [];

  Future<void> _getUsers() async {
    final res =
        await ManageChallengeService.manageUsers(roomId: widget.challenge.id);
    setState(() {
      _userList = res;
    });
  }

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        width: double.infinity,
        height: 1,
        color: AppColors.systemGrey3,
      ),
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        return MemberCertificationBox(
          user: _userList[index],
          challenge: widget.challenge,
          getUsers: _getUsers,
        );
      },
    );
  }
}
