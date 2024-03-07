import 'package:animations/animations.dart';
import 'package:dodal_app/src/common/helper/slide_page_route.dart';
import 'package:dodal_app/src/create_challenge/bloc/create_challenge_cubit.dart';
import 'package:dodal_app/src/my_bookmark/bloc/my_bookmark_cubit.dart';
import 'package:dodal_app/src/notification/bloc/notification_list_bloc.dart';
import 'package:dodal_app/src/common/bloc/user_bloc.dart';
import 'package:dodal_app/src/my_bookmark/page/my_bookmark_page.dart';
import 'package:dodal_app/src/create_challenge/page/create_challenge_route.dart';
import 'package:dodal_app/src/notification/page/notification_page.dart';
import 'package:dodal_app/src/search/page/search_page.dart';
import 'package:dodal_app/src/settings_menu/page/settings_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../my_challenge/page/my_challenge_page.dart';
import '../../feed_list/page/feed_list_page.dart';
import '../../home/page/main_page.dart';
import '../../my_info/page/my_info_page.dart';

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
                routeList.map((route) => route.name).toList()[_currentIndex],
              ),
        actions: _currentIndex != 3
            ? [
                IconButton(
                  onPressed: () {
                    _handleActionBtn(const SearchPage());
                  },
                  icon: SvgPicture.asset('assets/icons/search_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    _handleActionBtn(
                      BlocProvider(
                        create: (context) => NotificationListBloc(
                          userId: context.read<UserBloc>().state.result!.id,
                        ),
                        child: const NotiFicationPage(),
                      ),
                    );
                  },
                  icon: SvgPicture.asset('assets/icons/bell_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    _handleActionBtn(BlocProvider(
                      create: (context) => CreateChallengeBloc(),
                      child: const CreateChallengeRoute(),
                    ));
                  },
                  icon: SvgPicture.asset('assets/icons/plus_icon.svg'),
                ),
              ]
            : [
                IconButton(
                  onPressed: () {
                    _handleActionBtn(BlocProvider(
                      create: (context) => MyBookmarkCubit(),
                      child: const MyBookmarkPage(),
                    ));
                  },
                  icon: SvgPicture.asset('assets/icons/bookmark_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    _handleActionBtn(
                      BlocProvider(
                        create: (context) => NotificationListBloc(
                          userId: context.read<UserBloc>().state.result!.id,
                        ),
                        child: const NotiFicationPage(),
                      ),
                    );
                  },
                  icon: SvgPicture.asset('assets/icons/bell_icon.svg'),
                ),
                IconButton(
                  onPressed: () {
                    _handleActionBtn(const SettingsMenuPage());
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
