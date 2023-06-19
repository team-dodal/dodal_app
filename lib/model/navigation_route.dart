import 'package:flutter/material.dart';

class NavigationRoute {
  final String name;
  final Icon? icon;
  final Widget screen;
  NavigationRoute({
    required this.name,
    this.icon,
    required this.screen,
  });
}
