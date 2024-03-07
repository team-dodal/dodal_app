import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/comment/bloc/comment_bloc.dart';
import 'package:dodal_app/src/common/theme/color.dart';
import 'package:dodal_app/src/comment/widget/bottom_text_input.dart';
import 'package:dodal_app/src/comment/widget/comment_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentBlocState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            context.pop(state.list.length);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('댓글')),
            body: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Builder(builder: (context) {
                switch (state.status) {
                  case CommonStatus.init:
                  case CommonStatus.loading:
                    return const Center(child: CupertinoActivityIndicator());
                  case CommonStatus.error:
                    return Center(child: Text(state.errorMessage!));
                  case CommonStatus.loaded:
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          width: double.infinity,
                          color: AppColors.basicColor2,
                        );
                      },
                      itemCount: state.list.length,
                      itemBuilder: (context, index) => CommentBox(
                        comment: state.list[index],
                        removeComment: (commentId) async {
                          context
                              .read<CommentBloc>()
                              .add(RemoveCommentBlocEvent(commentId));
                        },
                      ),
                    );
                }
              }),
            ),
            bottomSheet: BottomTextInput(
              controller: textEditingController,
              postComment: () async {
                context
                    .read<CommentBloc>()
                    .add(SubmitCommentBlocEvent(textEditingController.text));
                textEditingController.clear();
              },
            ),
          ),
        );
      },
    );
  }
}
