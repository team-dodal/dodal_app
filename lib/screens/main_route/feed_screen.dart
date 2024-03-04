import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/providers/feed_list_bloc.dart';
import 'package:dodal_app/services/feed/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/feed_content_box/main.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  ScrollController scrollController = ScrollController();

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
      controller: scrollController,
      separatorBuilder: (context, index) => const Divider(
        thickness: 8,
        color: AppColors.systemGrey4,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) => FeedContentBox(feedContent: list[index]),
    );
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - 200 <=
          scrollController.offset) {
        context.read<FeedListBloc>().add(LoadFeedListEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedListBloc, FeedListState>(
      builder: (context, state) {
        switch (state.status) {
          case CommonStatus.init:
            return const Center(child: CupertinoActivityIndicator());
          case CommonStatus.loading:
          case CommonStatus.loaded:
            if (state.list.isEmpty) {
              return _empty();
            } else {
              return _success(state.list);
            }
          case CommonStatus.error:
            return Center(child: Text(state.errorMessage!));
        }
      },
    );
  }
}
