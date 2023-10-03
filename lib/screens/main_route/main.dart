import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/providers/create_challenge_cubit.dart';
import 'package:dodal_app/screens/create_challenge/main.dart';
import 'package:dodal_app/screens/notification/main.dart';
import 'package:dodal_app/screens/settings_menu/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'challenge_screen.dart';
import 'feed_screen.dart';
import 'home_screen.dart';
import 'mypage_screen.dart';

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
    screen: const HomeScreen(),
  ),
  Route(
    name: '피드',
    iconPath: 'assets/icons/feed_icon.svg',
    activeIconPath: 'assets/icons/feed_active_icon.svg',
    screen: const FeedScreen(),
  ),
  Route(
    name: '도전',
    iconPath: 'assets/icons/flag_icon.svg',
    activeIconPath: 'assets/icons/flag_active_icon.svg',
    screen: const ChallengeScreen(),
  ),
  Route(
    name: '마이',
    iconPath: 'assets/icons/my_icon.svg',
    activeIconPath: 'assets/icons/my_active_icon.svg',
    screen: MyPageScreen(),
  ),
];

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  int _currentIndex = 0;

  void _handleActionBtn(Widget screen) {
    Navigator.of(context).push(SlidePageRoute(screen: screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _currentIndex == 0
            ? Image.asset('assets/images/main_logo.png')
            : Text(
                routeList.map((route) => route.name).toList()[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              onPressed: () {
                _handleActionBtn(const NotiFicationScreen());
              },
              icon: const Icon(Icons.notifications_none),
            ),
          if (_currentIndex == 2)
            IconButton(
              onPressed: () {
                _handleActionBtn(BlocProvider(
                  create: (context) => CreateChallengeCubit(),
                  child: const CreateChallengeScreen(),
                ));
              },
              icon: const Icon(Icons.add_rounded),
            ),
          if (_currentIndex == 3)
            IconButton(
              onPressed: () {
                _handleActionBtn(const SettingsMenuScreen());
              },
              icon: const Icon(Icons.settings),
            )
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
