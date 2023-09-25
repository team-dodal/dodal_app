import 'package:dodal_app/widgets/common/input/select_input.dart';
import 'package:dodal_app/widgets/mypage/calendar.dart';
import 'package:dodal_app/widgets/mypage/user_info_box.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const UserInfoBox(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SelectInput(
              title: '도달한 목표',
              onChanged: (value) {},
              list: const [],
              value: null,
            ),
          ),
          const Calendar(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
