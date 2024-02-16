import 'package:dodal_app/model/certification_code_enum.dart';
import 'package:dodal_app/providers/manage_challenge_feed_bloc.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/theme/typo.dart';
import 'package:dodal_app/widgets/common/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'feed_certification_modal.dart';

class CertificateFeedImage extends StatelessWidget {
  const CertificateFeedImage({super.key, required this.feed});

  final FeedItem feed;

  _showFeedModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ManageChallengeFeedBloc>(),
        child: FeedCertificationModal(feed: feed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        _showFeedModal(context);
      },
      child: Stack(
        children: [
          ImageWidget(
            image: feed.certImageUrl,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 6,
            right: 6,
            child: CertMark(certCode: feed.certCode!),
          )
        ],
      ),
    );
  }
}

class CertMark extends StatelessWidget {
  const CertMark({super.key, required this.certCode});

  final String certCode;

  @override
  Widget build(BuildContext context) {
    CertCode status = CertCode.values[int.parse(certCode)];

    if (status == CertCode.pending) return const SizedBox();

    Color boxColor =
        status == CertCode.success ? AppColors.success : AppColors.danger;
    IconData boxIcon =
        status == CertCode.success ? Icons.check_rounded : Icons.close_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        children: [
          Text(
            status.name,
            style: context.caption(
              fontWeight: FontWeight.bold,
              color: AppColors.systemWhite,
            ),
          ),
          const SizedBox(width: 2),
          Icon(boxIcon, size: 18, color: AppColors.systemWhite)
        ],
      ),
    );
  }
}
