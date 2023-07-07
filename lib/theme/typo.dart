import 'package:flutter/material.dart';

class Typo {
  BuildContext context;
  Typo(this.context);

  TextStyle? headline1() => Theme.of(context).textTheme.displayLarge;
  TextStyle? headline2() => Theme.of(context).textTheme.headlineMedium;
  TextStyle? headline3() => Theme.of(context).textTheme.headlineSmall;
  TextStyle? headline4() => Theme.of(context).textTheme.titleLarge;
  TextStyle? body1() => Theme.of(context).textTheme.titleMedium;
  TextStyle? body2() => Theme.of(context).textTheme.titleSmall;
  TextStyle? body3() => Theme.of(context).textTheme.bodyLarge;
  TextStyle? body4() => Theme.of(context).textTheme.bodyMedium;
  TextStyle? caption() => Theme.of(context).textTheme.bodySmall;
}
