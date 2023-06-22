import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/screens/create_feed/main.dart';
import 'package:dodal_app/screens/group_menu/main.dart';
import 'package:dodal_app/screens/group_route/chat_screen.dart';
import 'package:dodal_app/screens/group_route/home_feed_screen.dart';
import 'package:dodal_app/screens/group_route/ranking_screen.dart';
import 'package:flutter/material.dart';

import '../../model/navigation_route.dart';

final List<NavigationRoute> tabRoute = [
  NavigationRoute(name: '홈', screen: const HomeFeedScreen()),
  NavigationRoute(name: '채팅', screen: const ChatScreen()),
  NavigationRoute(name: '랭킹', screen: const RankingScreen()),
];

class GroupRoute extends StatefulWidget {
  const GroupRoute({super.key});

  @override
  State<GroupRoute> createState() => _GroupRouteState();
}

class _GroupRouteState extends State<GroupRoute> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  void _routeMenuScreen() {
    Navigator.of(context).push(SlidePageRoute(screen: const GroupMenuScreen()));
  }

  @override
  void initState() {
    _tabController = TabController(length: tabRoute.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          tabs: tabRoute.map((route) => Tab(text: route.name)).toList(),
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
        child: tabRoute.map((route) => route.screen).toList()[_currentIndex],
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
  }
}
