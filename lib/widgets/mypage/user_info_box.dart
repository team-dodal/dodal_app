import 'package:dodal_app/model/my_info_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/screens/modify_user/main.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

class UserInfoBox extends StatelessWidget {
  const UserInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyInfoCubit, User?>(builder: (context, user) {
      user!;
      return Card(
        color: AppColors.bgColor1,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.systemGrey4,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: user.profileUrl != ''
                          ? FadeInImage(
                              placeholder: MemoryImage(kTransparentImage),
                              image: NetworkImage(user.profileUrl),
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : const SizedBox(),
                    ),
                    Text(user.nickname),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const ModifyUserScreen()));
                  },
                  child: const Text('유저 수정'),
                ),
              ],
            ),
            const Text('data'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final tag in user.tagList)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      decoration: const BoxDecoration(
                          color: AppColors.lightOrange,
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Text(
                        tag.name,
                        style: Typo(context).caption()!.copyWith(
                              color: AppColors.orange,
                            ),
                      ),
                    )
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
    });
  }
}
