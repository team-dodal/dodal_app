import 'package:dodal_app/src/common/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  _onTap(BuildContext context, ConditionEnum condition) {
    context
        .read<ChallengeListFilterCubit>()
        .updateCondition(condition: condition);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: BlocBuilder<ChallengeListFilterCubit, ChallengeListFilterState>(
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
        },
      ),
    );
  }
}
