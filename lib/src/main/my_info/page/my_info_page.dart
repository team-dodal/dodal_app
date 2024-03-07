import 'package:dodal_app/src/common/model/category_model.dart';
import 'package:dodal_app/src/common/enum/status_enum.dart';
import 'package:dodal_app/src/common/model/users_rooms_info_model.dart';
import 'package:dodal_app/src/main/my_info/bloc/calendar_feed_bloc.dart';
import 'package:dodal_app/src/common/bloc/category_list_bloc.dart';
import 'package:dodal_app/src/main/my_info/bloc/user_room_feed_info_bloc.dart';
import 'package:dodal_app/src/common/widget/input/select_input.dart';
import 'package:dodal_app/src/common/widget/no_list_context.dart';
import 'package:dodal_app/src/main/my_info/widget/calendar.dart';
import 'package:dodal_app/src/main/my_info/widget/user_info_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyInfoPage extends StatelessWidget {
  const MyInfoPage({super.key});

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
            context.push('/challenge-list', extra: {'category': list[0]});
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
                .map((room) => Select(label: room.title, value: room.roomId))
                .toList(),
            value: Select(label: selected.title, value: selected.roomId),
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
                    case CommonStatus.init:
                      return const Center(child: CupertinoActivityIndicator());
                    case CommonStatus.loading:
                      return const Center(child: CupertinoActivityIndicator());
                    case CommonStatus.error:
                      return Center(child: Text(state.errorMessage!));
                    case CommonStatus.loaded:
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
