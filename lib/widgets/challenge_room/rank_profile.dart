import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';

class RankProfile extends StatelessWidget {
  const RankProfile({
    super.key,
    required this.imageUrl,
    required this.rank,
    this.name,
  });

  final String? imageUrl;
  final String? name;
  final int rank;

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

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ImageWidget(
          image: imageUrl,
          width: 90,
          height: 90,
          shape: BoxShape.circle,
        ),
        Positioned(
          child: Container(
            width: 22,
            height: 22,
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
    );
  }
}
