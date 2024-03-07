import 'package:dodal_app/src/common/layout/filter_bottom_sheet_layout.dart';
import 'package:dodal_app/src/challenge_list/bloc/challenge_list_filter_cubit.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountBottomSheet extends StatelessWidget {
  const CountBottomSheet({super.key});

  _onChanged(BuildContext context, List<int> certCntList, int i) {
    List<int> clone = certCntList;
    if (clone.length == 7) {
      clone = [];
    }
    if (clone.contains(i)) {
      if (clone.length <= 1) return;
      clone.remove(i);
      context
          .read<ChallengeListFilterCubit>()
          .updateCertCnt(certCntList: clone);
    } else {
      context
          .read<ChallengeListFilterCubit>()
          .updateCertCnt(certCntList: [...clone, i]);
    }
  }

  _changeAll(BuildContext context) {
    context
        .read<ChallengeListFilterCubit>()
        .updateCertCnt(certCntList: [1, 2, 3, 4, 5, 6, 7]);
  }

  @override
  Widget build(BuildContext context) {
    return FilterBottomSheetLayout(
      child: Column(
        children: [
          Text(
            '도전 빈도 선택',
            style: context.body1(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                BlocBuilder<ChallengeListFilterCubit, ChallengeListFilterState>(
              builder: (context, state) {
                final certCntList = state.certCntList;
                return SizedBox(
                  height: 120,
                  child: GridView.count(
                    crossAxisCount: 4,
                    childAspectRatio: 82 / 46,
                    children: [
                      CountButton(
                        text: '전체',
                        selected: certCntList.length == 7,
                        onPressed: () {
                          _changeAll(context);
                        },
                      ),
                      for (final i in [1, 2, 3, 4, 5, 6, 7])
                        CountButton(
                          text: i != 7 ? '주 $i회' : '매일',
                          selected: certCntList.length != 7 &&
                              certCntList.contains(i),
                          onPressed: () {
                            _onChanged(context, certCntList, i);
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CountButton extends StatelessWidget {
  const CountButton({
    super.key,
    required this.text,
    this.onPressed,
    this.selected = false,
  });

  final String text;
  final bool selected;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: 82,
        height: 46,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor:
                selected ? AppColors.systemGrey1 : AppColors.systemGrey4,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          child: Text(
            text,
            style: context.body2(
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color:
                    selected ? AppColors.systemWhite : AppColors.systemBlack),
          ),
        ),
      ),
    );
  }
}
