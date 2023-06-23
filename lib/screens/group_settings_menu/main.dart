import 'package:dodal_app/screens/group_settings_menu/manage_group_screen.dart';
import 'package:dodal_app/screens/group_settings_menu/modify_group_screen.dart';
import 'package:flutter/material.dart';

class GroupSettingsMenuScreen extends StatelessWidget {
  const GroupSettingsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 메뉴'),
      ),
      body: Column(children: [
        ListTile(
          title: const Text('그룹 편집'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext ctx) => const ModifyGroupScreen()));
          },
        ),
        ListTile(
          title: const Text('인증 관리'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext ctx) => const ManageGroupScreen()));
          },
        ),
      ]),
    );
  }
}
