import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/model/certification_code_enum.dart';
import 'package:dodal_app/model/status_enum.dart';
import 'package:dodal_app/providers/bookmark_bloc.dart';
import 'package:dodal_app/providers/challenge_info_bloc.dart';
import 'package:dodal_app/providers/challenge_ranking_bloc.dart';
import 'package:dodal_app/providers/create_feed_bloc.dart';
import 'package:dodal_app/screens/challenge_route/chat_screen.dart';
import 'package:dodal_app/screens/challenge_route/home_feed_screen.dart';
import 'package:dodal_app/screens/challenge_route/preview_screen.dart';
import 'package:dodal_app/screens/challenge_route/ranking_screen.dart';
import 'package:dodal_app/screens/create_feed/main.dart';
import 'package:dodal_app/screens/challenge_settings_menu/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/widgets/challenge_room/challenge_bottom_sheet.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Route extends Equatable {
  final String name;
  final Widget Function(OneChallengeResponse challenge) screen;

  const Route({required this.name, required this.screen});

  @override
  List<Object?> get props => [name, screen];
}

List<Route> routeList = [
  Route(name: '홈', screen: (value) => HomeFeedScreen(challenge: value)),
  Route(
    name: '랭킹',
    screen: (value) => BlocProvider(
      create: (context) => ChallengeRankingBloc(value.id),
      child: RankingScreen(challenge: value),
    ),
  ),
  Route(name: '채팅', screen: (value) => const ChatScreen()),
];

class ChallengeRoute extends StatefulWidget {
  const ChallengeRoute({super.key});

  @override
  State<ChallengeRoute> createState() => _ChallengeRouteState();
}

class _ChallengeRouteState extends State<ChallengeRoute>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  void _routeMenuScreen(OneChallengeResponse challenge) {
    Navigator.push(
      context,
      SlidePageRoute(
        screen: GroupSettingsMenuScreen(challenge: challenge),
      ),
    );
  }

  void _certificateFeed(OneChallengeResponse challenge) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CreateFeedBloc(),
          child: CreateFeedScreen(challenge: challenge),
        ),
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: routeList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeInfoBloc, ChallengeInfoState>(
      builder: (context, state) {
        switch (state.status) {
          case CommonStatus.init:
          case CommonStatus.loading:
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CupertinoActivityIndicator()),
            );
          case CommonStatus.error:
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text(state.errorMessage!)),
            );
          case CommonStatus.loaded:
            final challenge = state.result!;
            if (!challenge.isJoin) {
              return const ChallengePreviewScreen();
            }
            return Scaffold(
              appBar: AppBar(
                actions: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.share),
                  // ),
                  IconButton(
                    onPressed: () {
                      _routeMenuScreen(challenge);
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs:
                      routeList.map((route) => Tab(text: route.name)).toList(),
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                ),
                title: const Text('그룹'),
              ),
              body: PageTransitionSwitcher(
                transitionBuilder: (child, animation, secondaryAnimation) {
                  return FadeThroughTransition(
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    child: child,
                  );
                },
                child: routeList
                    .map((route) => route.screen(challenge))
                    .toList()[_currentIndex],
              ),
              bottomSheet: Builder(
                builder: (context) {
                  if (_currentIndex == 0) {
                    return Builder(
                      builder: (context) {
                        String text = '인증하기';
                        Function()? onPress = () {
                          _certificateFeed(challenge);
                        };
                        if (challenge.todayCertCode == CertCode.success) {
                          text = '인증 완료';
                          onPress = null;
                        }
                        if (challenge.todayCertCode == CertCode.pending) {
                          text = '인증 대기중';
                          onPress = null;
                        }
                        return BlocProvider(
                          create: (context) => BookmarkBloc(
                            roomId: challenge.id,
                            isBookmarked: challenge.isBookmarked,
                          ),
                          child: ChallengeBottomSheet(
                            buttonText: text,
                            onPress: onPress,
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
        }
      },
    );
  }
}
