import 'package:animations/animations.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/providers/my_challenge_list_bloc.dart';
import 'package:dodal_app/screens/challenge_route/main.dart';
import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:dodal_app/services/manage_challenge/response.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/widgets/common/no_list_context.dart';
import 'package:dodal_app/widgets/home/admin_challenge_box.dart';
import 'package:dodal_app/widgets/home/joined_challenge_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '진행 중인 도전'), Tab(text: '운영 중인 도전')],
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
        ),
        Expanded(
          child: PageTransitionSwitcher(
            child: [const JoinedList(), const AdminList()][_currentIndex],
            transitionBuilder: (child, animation, secondaryAnimation) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }
}

class JoinedList extends StatelessWidget {
  const JoinedList({super.key});

  Widget _empty() {
    return const Column(
      children: [
        SizedBox(height: 130),
        NoListContext(
          title: '진행 중인 도전이 없습니다.',
          subTitle: '도전 그룹을 운영해 보는 건 어떠세요?',
        ),
      ],
    );
  }

  Widget _list(List<JoinedChallengesResponse> list) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChallengeRoute(id: list[index].id),
            ));
          },
          child: JoinedChallengeBox(
            id: list[index].id,
            title: list[index].title,
            thumbnailImg: list[index].thumbnailImg,
            tag: list[index].tag,
            adminProfile: list[index].adminProfileUrl,
            adminNickname: list[index].adminNickname,
            recruitCnt: list[index].recruitCnt,
            userCnt: list[index].userCnt,
            certCnt: list[index].certCnt,
            weekUserCertCnt: list[index].weekUserCertCnt,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChallengeListBloc, MyChallengeListState>(
      builder: (context, state) {
        switch (state.status) {
          case MyChallengeListStatus.init:
          case MyChallengeListStatus.loading:
            return const Center(child: CupertinoActivityIndicator());
          case MyChallengeListStatus.success:
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    color: AppColors.bgColor2,
                    child: Builder(
                      builder: (context) {
                        if (state.joinedList.isNotEmpty) {
                          return _list(state.joinedList);
                        }
                        return _empty();
                      },
                    ),
                  ),
                ),
              ],
            );
          case MyChallengeListStatus.error:
            return Center(child: Text(state.errorMessage!));
        }
      },
    );
  }
}

class AdminList extends StatelessWidget {
  const AdminList({super.key});

  Widget _empty(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 130),
        NoListContext(
          title: '운영 중인 도전이 없습니다.',
          subTitle: '도전 그룹을 운영해 보는 건 어떠세요?',
          buttonText: '도전 생성하기',
          onButtonPress: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => BlocProvider(
                  create: (context) => CreateChallengeCubit(),
                  child: const CreateChallengeScreen(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _list(List<HostChallengesResponse> list) {
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChallengeRoute(
                id: list[index].challengeRoomId,
              ),
            ));
          },
          child: AdminChallengeBox(
            id: list[index].challengeRoomId,
            title: list[index].title,
            thumbnailImg: list[index].thumbnailImgUrl,
            tag: list[index].tag,
            adminProfile: list[index].profileUrl,
            adminNickname: list[index].nickname,
            recruitCnt: list[index].recruitCnt,
            userCnt: list[index].userCnt,
            certCnt: list[index].certCnt,
            certRequestCnt: list[index].certRequestCnt,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyChallengeListBloc, MyChallengeListState>(
      builder: (context, state) {
        switch (state.status) {
          case MyChallengeListStatus.init:
          case MyChallengeListStatus.loading:
            return const Center(child: CupertinoActivityIndicator());
          case MyChallengeListStatus.success:
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    color: AppColors.bgColor2,
                    child: Builder(
                      builder: (context) {
                        if (state.adminList.isNotEmpty) {
                          return _list(state.adminList);
                        }
                        return _empty(context);
                      },
                    ),
                  ),
                ),
              ],
            );
          case MyChallengeListStatus.error:
            return Center(child: Text(state.errorMessage!));
        }
      },
    );
  }
}
