import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_list/count_bottom_sheet.dart';
import 'package:dodal_app/widgets/challenge_list/sort_bottom_sheet.dart';
import 'package:dodal_app/widgets/common/filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterTopBar extends StatelessWidget {
  const FilterTopBar({super.key});

  _showCountBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ChallengeListFilterCubit>(context),
        child: const CountBottomSheet(),
      ),
    );
  }

  _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<ChallengeListFilterCubit>(context),
        child: const SortBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
        builder: (context, state) {
      bool isSelectedAll = state.certCntList.length == 7;
      String text = isSelectedAll
          ? '전체'
          : state.certCntList.map((e) => '주 $e회').join(', ');

      return Column(
        children: [
          Container(height: 8, color: AppColors.basicColor2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterButton(
                  onPressed: () {
                    _showCountBottomSheet(context);
                  },
                  text: text,
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
                        style: context.body4(color: AppColors.systemGrey1),
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
