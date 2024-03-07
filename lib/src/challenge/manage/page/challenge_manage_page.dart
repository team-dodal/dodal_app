import 'package:animations/animations.dart';
import 'package:dodal_app/src/challenge/manage/page/feed_manage_page.dart';
import 'package:dodal_app/src/challenge/manage/page/member_manage_page.dart';
import 'package:flutter/material.dart';

class Route {
  final String name;
  final Widget Function() screen;

  Route({required this.name, required this.screen});
}

List<Route> routeList = [
  Route(
    name: '인증 관리',
    screen: () => const FeedManagePage(),
  ),
  Route(
    name: '멤버 관리',
    screen: () => const MemberManagePage(),
  ),
];

class ChallengeManagePage extends StatefulWidget {
  const ChallengeManagePage({super.key, required this.index});

  final int index;

  @override
  State<ChallengeManagePage> createState() => _ChallengeManagePageState();
}

class _ChallengeManagePageState extends State<ChallengeManagePage>
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
        child: routeList.map((route) => route.screen()).toList()[_currentIndex],
      ),
    );
  }
}
