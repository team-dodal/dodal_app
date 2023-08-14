import 'package:dodal_app/model/tag_model.dart';
import 'package:dodal_app/model/user_model.dart';
import 'package:dodal_app/providers/user_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestList extends StatelessWidget {
  const InterestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 202,
          decoration: const BoxDecoration(color: AppColors.lightYellow),
        ),
        Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 414,
                  child: BlocBuilder<UserCubit, User?>(
                    builder: (context, state) {
                      List<Tag> tagList = state!.tagList;
                      return PageView.builder(
                        itemCount: tagList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.systemWhite,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.systemGrey3,
                                    offset: Offset(0, 0),
                                    blurRadius: 4,
                                    blurStyle: BlurStyle.outer,
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '불끈불끈 건강 💪',
                                      style: Typo(context).body1()!.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '#체력 키우기 #살기 위해 한다',
                                      style: Typo(context).body4()!.copyWith(
                                          color: AppColors.systemGrey1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
