import 'package:animations/animations.dart';
import 'package:dodal_app/src/main/feed_list/page/feed_list_page.dart';
import 'package:dodal_app/src/main/home/page/main_page.dart';
import 'package:dodal_app/src/main/my_challenge/page/my_challenge_page.dart';
import 'package:dodal_app/src/main/my_info/page/my_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Route {
  final String name;
  final String iconPath;
  final String activeIconPath;
  final Widget screen;

  Route({
    required this.iconPath,
    required this.activeIconPath,
    required this.name,
    required this.screen,
  });
}

List<Route> routeList = [
  Route(
    name: '홈',
    iconPath: 'assets/icons/home_icon.svg',
    activeIconPath: 'assets/icons/home_active_icon.svg',
    screen: const MainPage(),
  ),
  Route(
    name: '피드',
    iconPath: 'assets/icons/feed_icon.svg',
    activeIconPath: 'assets/icons/feed_active_icon.svg',
    screen: const FeedListPage(),
  ),
  Route(
    name: '도전',
    iconPath: 'assets/icons/flag_icon.svg',
    activeIconPath: 'assets/icons/flag_active_icon.svg',
    screen: const MyChallengePage(),
  ),
  Route(
    name: '마이',
    iconPath: 'assets/icons/my_icon.svg',
    activeIconPath: 'assets/icons/my_active_icon.svg',
    screen: const MyInfoPage(),
  ),
];

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _currentIndex == 0
            ? Image.asset('assets/images/main_logo.png')
            : Text(
                routeList.map((route) => route.name).toList()[_currentIndex],
              ),
        actions: _currentIndex != 3
            ? [
                IconButton(
                  onPressed: () {
                    context.push('/search');
                  },
                  icon: SvgPicture.asset('assets/icons/search_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    context.push('/notification');
                  },
                  icon: SvgPicture.asset('assets/icons/bell_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    context.push('/create-challenge');
                  },
                  icon: SvgPicture.asset('assets/icons/plus_icon.svg'),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    context.push('/bookmark');
                  },
                  icon: SvgPicture.asset('assets/icons/bookmark_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    context.push('/notification');
                  },
                  icon: SvgPicture.asset('assets/icons/bell_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    context.push('/settings');
                  },
                  icon: SvgPicture.asset('assets/icons/settings_icon.svg'),
                ),
              ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            transitionType: SharedAxisTransitionType.horizontal,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: routeList.map((route) => route.screen).toList()[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          for (int i = 0; i < routeList.length; i++)
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _currentIndex == i
                    ? routeList[i].activeIconPath
                    : routeList[i].iconPath,
              ),
              label: routeList[i].name,
            )
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
      ),
    );
  }
}
