import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class CertCountButton extends StatelessWidget {
  const CertCountButton({super.key, required this.onPress});

  final void Function(BuildContext) onPress;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeListFilterCubit, ChallengeListFilter>(
        builder: (context, state) {
      bool isSelectedAll = state.certCntList.length == 7;
      String text = isSelectedAll
          ? '전체'
          : state.certCntList.map((e) => '주 $e회').join(', ');

      return Flexible(
        child: TextButton(
          onPressed: () => onPress(context),
          style: TextButton.styleFrom(
            side: const BorderSide(color: AppColors.systemGrey3),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: context.body4(
                    color: AppColors.systemGrey1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Transform.rotate(
                angle: math.pi,
                child: SvgPicture.asset('assets/icons/arrow_icon.svg'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
