import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';

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
    double numberWidth = imageWidth / 4;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ImageWidget(
                image: imageUrl,
                width: imageWidth,
                height: imageWidth,
                shape: BoxShape.circle,
              ),
            ),
            Positioned(
              child: Container(
                width: numberWidth,
                height: numberWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: rankColor,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: context.body3(
                      color: AppColors.systemWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(name ?? '', style: context.body2(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
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
