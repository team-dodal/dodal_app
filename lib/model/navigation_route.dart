import 'package:flutter/material.dart';

class NavigationRoute {
  final String name;
  final dynamic icon;
  final dynamic activeIcon;
  final Widget screen;
  NavigationRoute({
    required this.name,
    this.icon,
    this.activeIcon,
    required this.screen,
  });
}
