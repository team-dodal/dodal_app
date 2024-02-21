import 'package:dodal_app/providers/manage_challenge_feed_bloc.dart';
import 'package:dodal_app/providers/manage_challenge_member_bloc.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/challenge_settings/member_certification_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageMemberScreen extends StatelessWidget {
  const ManageMemberScreen({super.key, required this.challenge});

  final OneChallengeResponse challenge;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageChallengeMemberBloc, ManageChallengeMemberState>(
      listener: (context, state) {
        if (state.status == ManageChallengeMemberStatus.success) {
          context
              .read<ManageChallengeFeedBloc>()
              .add(RequestCertFeedListEvent());
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case ManageChallengeMemberStatus.init:
          case ManageChallengeMemberStatus.loading:
            return const Center(child: CupertinoActivityIndicator());
          case ManageChallengeMemberStatus.error:
            return Center(child: Text(state.errorMessage!));
          case ManageChallengeMemberStatus.success:
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
