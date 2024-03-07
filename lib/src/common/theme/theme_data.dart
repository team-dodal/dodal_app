import 'package:dodal_app/src/common/theme/color.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Pretendard',
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // headline1
    headlineMedium: TextStyle(
      fontSize: 24,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // headline2
    headlineSmall: TextStyle(
      fontSize: 22,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // headline3
    titleLarge: TextStyle(
      fontSize: 20,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // headline4
    titleMedium: TextStyle(
      fontSize: 18,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // body1
    titleSmall: TextStyle(
      fontSize: 16,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // body2
    bodyLarge: TextStyle(
      fontSize: 15,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // body3
    bodyMedium: TextStyle(
      fontSize: 14,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // body4
    bodySmall: TextStyle(
      fontSize: 12,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
      color: AppColors.systemBlack,
    ), // caption
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    backgroundColor: AppColors.bgColor1,
    scrolledUnderElevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.systemBlack,
    ),
  ),
  cardTheme: const CardTheme(
    color: AppColors.bgColor1,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.orange,
      foregroundColor: AppColors.bgColor1,
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      disabledBackgroundColor: AppColors.bgColor4,
      disabledForegroundColor: AppColors.systemGrey2,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.bgColor1,
      foregroundColor: AppColors.orange,
      side: BorderSide.none,
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      disabledBackgroundColor: AppColors.bgColor4,
      disabledForegroundColor: AppColors.systemGrey2,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.bgColor3,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.systemBlack),
      borderRadius: BorderRadius.circular(8),
    ),
    hintStyle: const TextStyle(
      fontSize: 16,
      letterSpacing: 0.5,
      fontWeight: FontWeight.normal,
      color: AppColors.systemGrey2,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.bgColor1,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.systemGrey1,
    unselectedItemColor: AppColors.systemGrey2,
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      letterSpacing: 0.5,
      fontWeight: FontWeight.bold,
      color: AppColors.systemGrey1,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12,
      letterSpacing: 0.5,
      fontWeight: FontWeight.bold,
      color: AppColors.systemGrey2,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorColor: AppColors.systemBlack,
    dividerColor: AppColors.bgColor2,
    labelStyle: TextStyle(fontWeight: FontWeight.bold),
    unselectedLabelColor: AppColors.systemGrey2,
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
    labelColor: AppColors.systemBlack,
    indicator: UnderlineTabIndicator(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(width: 2),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      padding: EdgeInsets.zero,
    ),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.orange)
      .copyWith(background: AppColors.bgColor1, primary: AppColors.orange),
);
