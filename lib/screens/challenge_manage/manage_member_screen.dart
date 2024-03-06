import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/providers/manage_challenge_feed_bloc.dart';
import 'package:dodal_app/providers/manage_challenge_member_bloc.dart';
import 'package:dodal_app/model/challenge_detail_model.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/challenge_settings/member_certification_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageMemberScreen extends StatelessWidget {
  const ManageMemberScreen({super.key, required this.challenge});

  final ChallengeDetail challenge;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageChallengeMemberBloc, ManageChallengeMemberState>(
      listener: (context, state) {
        if (state.status == CommonStatus.loaded) {
          context
              .read<ManageChallengeFeedBloc>()
              .add(RequestCertFeedListEvent());
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case CommonStatus.init:
          case CommonStatus.loading:
            return const Center(child: CupertinoActivityIndicator());
          case CommonStatus.error:
            return Center(child: Text(state.errorMessage!));
          case CommonStatus.loaded:
            return ListView.separated(
              separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1,
                color: AppColors.systemGrey3,
              ),
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                return MemberCertificationBox(
                  user: state.result[index],
                  challenge: challenge,
                );
              },
            );
        }
      },
    );
  }
}
