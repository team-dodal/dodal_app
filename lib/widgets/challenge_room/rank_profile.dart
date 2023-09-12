import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RankProfile extends StatelessWidget {
  const RankProfile({
    super.key,
    required this.imageUrl,
    required this.rank,
    required this.name,
    required this.certCnt,
  });

  final String? imageUrl;
  final String? name;
  final int rank;
  final int? certCnt;

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    if (rank == 1) {
      rankColor = AppColors.gold;
    } else if (rank == 2) {
      rankColor = AppColors.silver;
    } else {
      rankColor = AppColors.bronze;
    }

    double imageWidth = MediaQuery.of(context).size.width / 5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ImageWidget(
                image: imageUrl,
                width: imageWidth,
                height: imageWidth,
                shape: BoxShape.circle,
              ),
            ),
            if (rank == 1)
              Positioned(
                top: 0,
                child: SvgPicture.asset('assets/icons/first_rank_crown.svg'),
              ),
            Positioned(
              child: Container(
                padding: const EdgeInsets.all(6),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rankColor,
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.systemGrey3,
                      offset: Offset(0, 0),
                      blurRadius: 8,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Text(
                  '$rank',
                  style: context.body3(
                    color: AppColors.systemWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(name ?? '', style: context.body2(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        if (certCnt != null)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            decoration: const BoxDecoration(
              color: AppColors.lightOrange,
            ),
            child: Text(
              '인증 $certCnt회',
              style: context.body4(color: AppColors.orange),
            ),
          )
      ],
    );
  }
}
