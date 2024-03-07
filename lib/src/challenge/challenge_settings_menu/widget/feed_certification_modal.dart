import 'package:dodal_app/src/common/layout/modal_layout.dart';
import 'package:dodal_app/src/common/enum/certification_code_enum.dart';
import 'package:dodal_app/src/common/model/members_feed_model.dart';
import 'package:dodal_app/src/challenge/manage/bloc/manage_challenge_feed_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/common/theme/typo.dart';
import 'package:dodal_app/src/common/widget/avatar_image.dart';
import 'package:dodal_app/src/common/widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCertificationModal extends StatelessWidget {
  const FeedCertificationModal({super.key, required this.feed});

  final MembersFeed feed;

  _request(BuildContext context, bool value) {
    context.read<ManageChallengeFeedBloc>().add(
        ApproveOrRejectEvent(feedId: feed.challengeFeedId, approve: value));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const AvatarImage(image: null, width: 32, height: 32),
                  const SizedBox(width: 8),
                  Text(
                    feed.requestUserNickname,
                    style: context.body2(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1,
            child: ImageWidget(
              image: feed.certImageUrl,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const SizedBox(height: 16),
          Text(feed.certContent),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.systemGrey3),
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: feed.certCode == CertCode.fail.index.toString()
                      ? null
                      : () => _request(context, false),
                  child: Text(
                    '거절',
                    style: context.body2(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton(
                  onPressed: feed.certCode == CertCode.success.index.toString()
                      ? null
                      : () => _request(context, true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                  ),
                  child: Text(
                    '승인',
                    style: context.body2(
                      fontWeight: FontWeight.bold,
                      color: AppColors.systemWhite,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
