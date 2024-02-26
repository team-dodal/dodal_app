import 'package:dodal_app/model/category_model.dart';
import 'package:dodal_app/providers/calendar_feed_bloc.dart';
import 'package:dodal_app/providers/category_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_bloc.dart';
import 'package:dodal_app/providers/challenge_list_filter_cubit.dart';
import 'package:dodal_app/providers/user_room_feed_info_bloc.dart';
import 'package:dodal_app/screens/challenge_list/main.dart';
import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/widgets/common/input/select_input.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:dodal_app/widgets/mypage/calendar.dart';
import 'package:dodal_app/widgets/mypage/user_info_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  Widget _isEmpty(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        NoListContext(
          title: '아직 참여한 도전이 없네요!',
          subTitle: '도전에 참여해보세요',
          buttonText: '도전 찾아보기',
          onButtonPress: () {
            List<Category> list =
                context.read<CategoryListBloc>().state.categoryListForFilter();
            ChallengeListFilterState filterState =
                context.read<ChallengeListFilterCubit>().state;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      ChallengeListFilterCubit(category: list[0]),
                  child: BlocProvider(
                    create: (context) => ChallengeListBloc(
                      category: filterState.category,
                      tag: filterState.tag,
                      condition: filterState.condition,
                      certCntList: filterState.certCntList,
                    ),
                    child: const ChallengeListScreen(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _isSuccess(BuildContext context) {
    final list = context.read<UserRoomFeedInfoBloc>().state.challengeList;
    final selectedId = context.read<UserRoomFeedInfoBloc>().state.selectedId!;

    UsersChallengeRoom selected =
        list.firstWhere((room) => room.roomId == selectedId);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SelectInput(
            title: '도달한 목표',
            onChanged: (value) {
              context
                  .read<UserRoomFeedInfoBloc>()
                  .add(ChangeSelectedRoomIdEvent(value.value));
            },
            list: list
                .map((room) => Select(label: room.title!, value: room.roomId))
                .toList(),
            value: Select(label: selected.title!, value: selected.roomId),
          ),
        ),
        BlocProvider(
          create: (context) => CalendarFeedBloc(selectedId),
          child: const Calendar(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<UserRoomFeedInfoBloc, UserRoomFeedInfoState>(
        builder: (context, state) {
          return Column(
            children: [
              const UserInfoBox(),
              Builder(
                builder: (context) {
                  switch (state.status) {
                    case UserRoomFeedInfoStatus.init:
                      return const Center(child: CupertinoActivityIndicator());
                    case UserRoomFeedInfoStatus.loading:
                      return const Center(child: CupertinoActivityIndicator());
                    case UserRoomFeedInfoStatus.error:
                      return Center(child: Text(state.errorMessage!));
                    case UserRoomFeedInfoStatus.success:
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Builder(
                          builder: (context) {
                            if (state.challengeList.isEmpty) {
                              return _isEmpty(context);
                            }
                            return _isSuccess(context);
                          },
                        ),
                      );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
