import 'package:dodal_app/widgets/mypage/calendar.dart';
import 'package:dodal_app/widgets/mypage/user_info_box.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UserInfoBox(),
          SizedBox(height: 20),
          Calendar(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
