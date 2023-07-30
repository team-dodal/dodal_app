import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';

class InterestList extends StatelessWidget {
  const InterestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 202,
      decoration: const BoxDecoration(
        color: AppColors.lightYellow,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '관심있는\n도전을 추천드려요 🧡',
              style: Typo(context)
                  .headline4()!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Material(
              color: AppColors.lightYellow,
              child: InkWell(
                onTap: () {},
                child: const Row(
                  children: [
                    Text('관심사 추가하기'),
                    Icon(Icons.add, size: 16),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
