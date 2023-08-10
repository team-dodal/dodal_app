import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_list/count_bottom_sheet.dart';
import 'package:dodal_app/widgets/challenge_list/sort_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class FilterTopBar extends StatelessWidget {
  const FilterTopBar({super.key});
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  _showCountBottomSheet(BuildContext context) {
    ChallengeListFilter cubit =
        BlocProvider.of<ChallengeListFilterCubit>(context).state;

    onChanged(List<int> value) {
      context.read<ChallengeListFilterCubit>().updateData(certCntList: value);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => CountBottomSheet(
        cubit: cubit,
        onChanged: onChanged,
      ),
    );
  }

  _showSortBottomSheet(BuildContext context) {
    ChallengeListFilter cubit =
        BlocProvider.of<ChallengeListFilterCubit>(context).state;

    onChanged(value) {
      context.read<ChallengeListFilterCubit>().updateData(conditionCode: value);
      Navigator.pop(context);
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => SortBottomSheet(
        cubit: cubit,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
        builder: (context, state) {
      return Column(
        key: ,
        children: [
          Container(height: 8, color: AppColors.basicColor2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _showCountBottomSheet(context);
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: AppColors.systemGrey3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '주 3회',
                        style: Typo(context)
                            .body4()!
                            .copyWith(color: AppColors.systemGrey1),
                      ),
                      const SizedBox(width: 4),
                      Transform.rotate(
                        angle: math.pi,
                        child: SvgPicture.asset('assets/icons/arrow_icon.svg'),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showSortBottomSheet(context);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/swap_icon.svg'),
                      const SizedBox(width: 4),
                      Text(
                        CONDITION_LIST[state.conditionCode],
                        style: Typo(context)
                            .body4()!
                            .copyWith(color: AppColors.systemGrey1),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
    });
  }
}
