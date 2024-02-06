import 'package:dodal_app/providers/feed_list_bloc.dart';
import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/feed_content_box/main.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  Widget _empty() {
    return const Center(
      child: NoListContext(
        title: '생성된 피드가 없습니다.',
        subTitle: '가장 처음 인증글을 올려보는 건 어떠세요?',
      ),
    );
  }

  Widget _success(List<FeedContentResponse> list) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        thickness: 8,
        color: AppColors.systemGrey4,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) => FeedContentBox(feedContent: list[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedListBloc, FeedListState>(
      builder: (context, state) {
        switch (state.status) {
          case FeedListStatus.init:
          case FeedListStatus.loading:
            return const Center(child: CupertinoActivityIndicator());
          case FeedListStatus.success:
            if (state.list.isEmpty) {
              return _empty();
            } else {
              return _success(state.list);
            }
          case FeedListStatus.error:
            return Center(child: Text(state.errorMessage!));
        }
      },
    );
  }
}
