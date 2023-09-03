import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 120),
          Image.asset(
            'assets/images/character/sad.png',
            width: 46,
          ),
          const SizedBox(height: 10),
          Text(
            '채팅 기능은 오픈 준비 중입니다.',
            style: context.headline4(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '조금만 기다려주세요!',
            style: context.body4(color: AppColors.systemGrey2),
          ),
        ],
      ),
    );
  }
}
