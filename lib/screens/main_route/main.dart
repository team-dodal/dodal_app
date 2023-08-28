import 'package:animations/animations.dart';
import 'package:dodal_app/helper/slide_page_route.dart';
import 'package:dodal_app/model/navigation_route.dart';
import 'package:dodal_app/screens/main_route/feed_screen.dart';
import 'package:dodal_app/screens/main_route/home_screen.dart';
import 'package:dodal_app/screens/main_route/mypage_screen.dart';
import 'package:dodal_app/screens/notification/main.dart';
import 'package:dodal_app/screens/settings_menu/main.dart';
import 'package:dodal_app/services/user/service.dart';
import 'package:dodal_app/theme/color.dart';
import 'package:dodal_app/utilities/fcm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'challenge_screen.dart';

final List<NavigationRoute> _routes = [
  NavigationRoute(
    name: '홈',
    icon: 'assets/icons/home_icon.svg',
    screen: const HomeScreen(),
  ),
  NavigationRoute(
    name: '피드',
    icon: 'assets/icons/feed_icon.svg',
    screen: const FeedScreen(),
  ),
  NavigationRoute(
    name: '도전',
    icon: 'assets/icons/flag_icon.svg',
    screen: const ChallengeScreen(),
  ),
  NavigationRoute(
    name: '마이',
    icon: 'assets/icons/my_icon.svg',
    screen: const MyPageScreen(),
  ),
];

class MainRoute extends StatefulWidget {
  const MainRoute({super.key});

  @override
  State<MainRoute> createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _handleActionBtn(Widget screen) {
    Navigator.of(context).push(SlidePageRoute(screen: screen));
  }

  @override
  void initState() {
    UserService.updateFcmToken(Fcm.token);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_routes.map((route) => route.name).toList()[_currentIndex]),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              onPressed: () {
                _handleActionBtn(const NotiFicationScreen());
              },
              icon: const Icon(Icons.notifications_none),
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
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _routes.map((route) => route.screen).toList()[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          for (var i = 0; i < _routes.length; i++)
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _routes[i].icon!,
                colorFilter: ColorFilter.mode(
                  _currentIndex == i
                      ? AppColors.systemGrey1
                      : AppColors.systemGrey2,
                  BlendMode.srcIn,
                ),
              ),
              label: _routes[i].name,
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
