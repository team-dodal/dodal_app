import 'package:dodal_app/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/screens/challenge_settings_menu/challenge_report_screen.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class MemberManageBottomSheet extends StatelessWidget {
  const MemberManageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: Column(
        children: [
          ListTile(
            title: Center(child: Text('내보내기', style: context.body2())),
            onTap: () {},
          ),
          ListTile(
            title: Center(child: Text('신고하기', style: context.body2())),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChallengeReportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
