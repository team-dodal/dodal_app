import 'package:dodal_app/services/user/response.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/widgets/common/input/select_input.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:dodal_app/widgets/mypage/calendar.dart';
import 'package:dodal_app/widgets/mypage/user_info_box.dart';
import 'package:flutter/material.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  UserResponse? _user;
  Select? _selectedChallenge;

  _getUser() async {
    _user = await UserService.me();
    if (_user!.challengeRoomList!.isNotEmpty) {
      _selectedChallenge = Select(
        label: _user!.challengeRoomList![0].title!,
        value: _user!.challengeRoomList![0].roomId,
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Builder(builder: (context) {
        if (_user == null) {
          return Container();
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserInfoBox(user: _user!, refresh: _getUser),
            const SizedBox(height: 20),
            Builder(
              builder: (context) {
                if (_user!.challengeRoomList!.isEmpty) {
                  return const NoListContext(
                    title: '아직 참여한 도전이 없네요!',
                    subTitle: '도전에 참여해보세요',
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SelectInput(
                        title: '도달한 목표',
                        onChanged: (value) {
                          setState(() {
                            _selectedChallenge = value;
                          });
                        },
                        list: _user!.challengeRoomList!
                            .map((challengeRoom) => Select(
                                  label: challengeRoom.title!,
                                  value: challengeRoom.roomId,
                                ))
                            .toList(),
                        value: _selectedChallenge,
                      ),
                    ),
                    Calendar(roomId: _selectedChallenge!.value),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }
}
