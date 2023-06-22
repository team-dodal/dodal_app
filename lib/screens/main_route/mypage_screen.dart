import 'package:dodal_app/screens/modify_user/main.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('MyPage'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => const ModifyUserScreen()));
            },
            child: const Text('유저 수정'),
          )
        ],
      ),
    );
  }
}
