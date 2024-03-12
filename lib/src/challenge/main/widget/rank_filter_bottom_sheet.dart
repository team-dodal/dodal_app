import 'package:dodal_app/src/common/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ChallengeRankFilterEnum {
  all('전체'),
  month('월간'),
  week('주간');

  const ChallengeRankFilterEnum(this.displayName);
  final String displayName;
}

class RankFilterBottomSheet extends StatelessWidget {
  const RankFilterBottomSheet({super.key, required this.onChange});

  final void Function(ChallengeRankFilterEnum value) onChange;

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: Column(
        children: ChallengeRankFilterEnum.values
            .map(
              (item) => ListTile(
                title: Text(item.displayName, style: context.body2()),
                onTap: () {
                  onChange(item);
                  context.pop();
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
