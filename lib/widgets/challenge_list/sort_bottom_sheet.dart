import 'dart:io';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  _onTap(BuildContext context, String condition) {
    context
        .read<ChallengeListFilterCubit>()
        .updateData(conditionCode: CONDITION_LIST.indexOf(condition));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColors.bgColor1,
        ),
        padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
                builder: (context, state) {
              final conditionCode = state.conditionCode;
              return Column(
                children: [
                  for (final condition in CONDITION_LIST)
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(condition, style: Typo(context).body2()),
                          if (CONDITION_LIST.indexOf(condition) ==
                              conditionCode)
                            SvgPicture.asset('assets/icons/check_icon.svg')
                        ],
                      ),
                      onTap: () {
                        _onTap(context, condition);
                      },
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
