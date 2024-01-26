import 'package:dodal_app/widgets/home/category_select/main.dart';
import 'package:dodal_app/widgets/home/interest_list.dart';
import 'package:dodal_app/widgets/home/popular_list.dart';
import 'package:dodal_app/widgets/home/recent_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
