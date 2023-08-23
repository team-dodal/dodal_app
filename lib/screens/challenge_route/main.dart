import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/screens/create_feed/main.dart';
import 'package:dodal_app/screens/group_settings_menu/main.dart';
import 'package:dodal_app/screens/challenge_route/chat_screen.dart';
import 'package:dodal_app/screens/challenge_route/home_feed_screen.dart';
import 'package:dodal_app/screens/challenge_route/ranking_screen.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:dodal_app/services/challenge/service.dart';
import 'package:flutter/material.dart';

const routeNameList = ['홈', '채팅', '랭킹'];

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

  void _routeMenuScreen() {
    Navigator.of(context)
        .push(SlidePageRoute(screen: const GroupSettingsMenuScreen()));
  }

  @override
  void initState() {
    _tabController = TabController(length: routeNameList.length, vsync: this);
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
                  onPressed: _routeMenuScreen,
                  icon: const Icon(Icons.menu),
                )
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: routeNameList.map((name) => Tab(text: name)).toList(),
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
              child: [
                HomeFeedScreen(challenge: challenge),
                const RankingScreen(),
                const ChatScreen(),
              ][_currentIndex],
            ),
            floatingActionButton: _currentIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const CreateFeedScreen()));
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
          );
        });
  }
}
