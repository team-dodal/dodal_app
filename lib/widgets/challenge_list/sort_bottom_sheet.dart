import 'package:dodal_app/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  _onTap(BuildContext context, ConditionEnum condition) {
    context.read<ChallengeListFilterCubit>().updateData(condition: condition);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
          builder: (context, state) {
        final condition = state.condition;
        return Column(
          children: ConditionEnum.values
              .map(
                (item) => ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.displayName,
                        style: context.body2(),
                      ),
                      if (item == condition)
                        SvgPicture.asset('assets/icons/check_icon.svg')
                    ],
                  ),
                  onTap: () {
                    _onTap(context, item);
                  },
                ),
              )
              .toList(),
        );
      }),
    );
  }
}
