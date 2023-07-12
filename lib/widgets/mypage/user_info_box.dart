import 'package:dodal_app/screens/modify_user/main.dart';
import 'package:flutter/material.dart';

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              const Row(
                children: [
                  // 이미지
                  // 닉네임
                ],
                // 수정버튼
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => const ModifyUserScreen()));
                },
                child: const Text('유저 수정'),
              )
            ],
          ),
          const Text('data'),
          const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // 태그들
              ],
            ),
          ),
          Container(
            child: const Row(
              children: [
                // 최장 인증 연속 달성
                // 선
                // 현재 연속 달성
              ],
            ),
          )
        ],
      ),
    );
  }
}
