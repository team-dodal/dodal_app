import 'package:dodal_app/enum/status_enum.dart';
import 'package:dodal_app/providers/comment_bloc.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/comment/bottom_text_input.dart';
import 'package:dodal_app/widgets/comment/comment_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
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
            Navigator.pop(context, state.list.length);
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
