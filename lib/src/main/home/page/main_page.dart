import 'package:dodal_app/src/main/home/widget/category_select_widget.dart';
import 'package:dodal_app/src/main/home/widget/interest_list.dart';
import 'package:dodal_app/src/main/home/widget/popular_list.dart';
import 'package:dodal_app/src/main/home/widget/recent_list.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: const Column(
          children: [
            CategorySelect(),
            SizedBox(height: 32),
            InterestList(),
            SizedBox(height: 32),
            PopularList(),
            SizedBox(height: 48),
            RecentList(),
            SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
