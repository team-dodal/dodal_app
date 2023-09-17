import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/challenge_settings/member_box.dart';
import 'package:flutter/material.dart';

class ManageMemberScreen extends StatelessWidget {
  const ManageMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        width: double.infinity,
        height: 1,
        color: AppColors.systemGrey3,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return const MemberBox();
      },
    );
  }
}
