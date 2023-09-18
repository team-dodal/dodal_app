import 'package:animations/animations.dart';
import 'package:dodal_app/services/challenge/response.dart';
import 'package:flutter/material.dart';

import 'manage_feed_screen.dart';
import 'manage_member_screen.dart';

class Route {
  final String name;
  final Widget Function(OneChallengeResponse) screen;

  Route({required this.name, required this.screen});
}

List<Route> routeList = [
  Route(
    name: '인증 관리',
    screen: (challenge) => ManageFeedScreen(challenge: challenge),
  ),
  Route(
    name: '멤버 관리',
    screen: (challenge) => const ManageMemberScreen(),
  ),
];

class ManageRoute extends StatefulWidget {
  const ManageRoute({super.key, required this.index, required this.challenge});

  final OneChallengeResponse challenge;
  final int index;

  @override
  State<ManageRoute> createState() => _ManageRouteState();
}

class _ManageRouteState extends State<ManageRoute>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    _tabController = TabController(length: routeList.length, vsync: this);
    setState(() {
      _currentIndex = widget.index;
      _tabController.index = widget.index;
    });
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
        title: const Text('도전 그룹 관리'),
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
            .map((route) => route.screen(widget.challenge))
            .toList()[_currentIndex],
      ),
    );
  }
}
