import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/challenge_list/cert_cnt_button.dart';
import 'package:dodal_app/widgets/challenge_list/count_bottom_sheet.dart';
import 'package:dodal_app/widgets/challenge_list/sort_bottom_sheet.dart';
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
      return Column(
        children: [
          Container(height: 8, color: AppColors.basicColor2),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CertCountButton(onPress: _showCountBottomSheet),
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
