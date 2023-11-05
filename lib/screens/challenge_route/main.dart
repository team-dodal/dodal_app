import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/model/certification_code_enum.dart';
import 'package:dodal_app/screens/challenge_route/chat_screen.dart';
import 'package:dodal_app/screens/challenge_route/home_feed_screen.dart';
import 'package:dodal_app/screens/challenge_route/ranking_screen.dart';
import 'package:dodal_app/screens/create_feed/main.dart';
import 'package:dodal_app/screens/challenge_settings_menu/main.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:dodal_app/widgets/challenge_room/challenge_bottom_sheet.dart';
import 'package:flutter/material.dart';

class Route {
  final String name;
  final Widget Function(OneChallengeResponse challenge) screen;

  Route({required this.name, required this.screen});
}

List<Route> routeList = [
  Route(name: '홈', screen: (value) => HomeFeedScreen(challenge: value)),
  Route(name: '랭킹', screen: (value) => RankingScreen(challenge: value)),
  Route(name: '채팅', screen: (value) => const ChatScreen()),
];

class ChallengeRoute extends StatefulWidget {
  const ChallengeRoute({super.key, required this.id});

  final int id;

  @override
  State<ChallengeRoute> createState() => _ChallengeRouteState();
}

class _ChallengeRouteState extends State<ChallengeRoute>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  Future<OneChallengeResponse?> getOneChallenge() async =>
      ChallengeService.getChallengeOne(challengeId: widget.id);

  void _routeMenuScreen(OneChallengeResponse challenge) {
    Navigator.of(context)
        .push(SlidePageRoute(
            screen: GroupSettingsMenuScreen(challenge: challenge)))
        .then((value) {
      setState(() {});
    });
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
    return FutureBuilder(
        future: getOneChallenge(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          final OneChallengeResponse challenge = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () {
                    _routeMenuScreen(challenge);
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: routeList.map((route) => Tab(text: route.name)).toList(),
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
            bottomSheet: _currentIndex == 0
                ? Builder(builder: (context) {
                    String text;
                    Function()? onPress;
                    switch (challenge.todayCertCode) {
                      case CertCode.pending:
                        text = '인증 대기중';
                        break;
                      case CertCode.success:
                        text = '인증 완료';
                        break;
                      default:
                        text = '인증하기';
                        onPress = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateFeedScreen(challenge: challenge),
                            ),
                          );
                          setState(() {});
                        };
                        break;
                    }
                    return ChallengeBottomSheet(
                      buttonText: text,
                      roomId: challenge.id,
                      bookmarked: challenge.isBookmarked,
                      onPress: onPress,
                    );
                  })
                : null,
          );
        });
  }
}
